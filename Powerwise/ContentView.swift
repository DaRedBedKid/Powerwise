//
//  ContentView.swift
//  Powerwise
//
//  Created by Eli on 10/23/24.
//
import SwiftUI

struct ContentView: View {
    @State private var energyUsageText: String = "Fetching..."
    private let energyUsageService = EnergyUsageService()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Energy Monitor")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
            
            VStack(spacing: 10) {
                Text("Current Energy Usage:")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Text("\(energyUsageText) Watts")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(energyUsageColor())
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 15)
                            .fill(Color(.systemGray)))
            .shadow(radius: 5)
            
            Spacer()
            
            Button(action: {
                startMonitoringEnergyUsage()
            }) {
                Text("Refresh")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .onAppear {
            startMonitoringEnergyUsage()
        }
    }
    
    // Function to start monitoring and fetch energy usage
    func startMonitoringEnergyUsage() {
        energyUsageService.fetchEnergyUsageWithAppleScript { output in
            if let output = output {
                DispatchQueue.main.async {
                    self.energyUsageText = parseWatts(from: output) ?? "N/A"
                }
            } else {
                DispatchQueue.main.async {
                    self.energyUsageText = "N/A"
                }
            }
        }
    }

    // Parse watts value from the powermetrics output
    func parseWatts(from output: String) -> String? {
        let lines = output.split(separator: "\n")
        for line in lines {
            if line.contains("Average Power:") {
                if let range = line.range(of: #"([0-9]*\.?[0-9]+)\s+W"#, options: .regularExpression) {
                    let powerString = String(line[range])
                    return powerString.replacingOccurrences(of: " W", with: "")
                }
            }
        }
        return nil
    }
    
    // Determine color based on energy usage
    func energyUsageColor() -> Color {
        if let usage = Double(energyUsageText), usage > 100 {
            return .red
        } else {
            return .green
        }
    }
}
