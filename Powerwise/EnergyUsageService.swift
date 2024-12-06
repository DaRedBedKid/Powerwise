//
//  EnergyUsageService.swift
//  Powerwise
//
//  Created by Eli on 10/23/24.
//
import Foundation

class EnergyUsageService {
    func fetchEnergyUsageWithAppleScript(completion: @escaping (String?) -> Void) {
        let appleScript = """
        do shell script "open /Applications/Powerwise.app" with administrator privileges
        """
        var error: NSDictionary?

        if let scriptObject = NSAppleScript(source: appleScript) {
            let output = scriptObject.executeAndReturnError(&error)

            if let result = output.stringValue {
                completion(result)
            } else if let errorDetails = error {
                print("AppleScript Error: \(errorDetails)")
                completion(nil)
            }
        } else {
            print("Failed to initialize AppleScript.")
            completion(nil)
        }
    }
}
