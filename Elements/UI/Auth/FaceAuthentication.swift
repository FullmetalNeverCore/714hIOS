import Foundation
import UIKit
import LocalAuthentication

func faceauth(completion: @escaping (Bool) -> Void) {
    let ctx = LAContext()
    var error: NSError?
    
    if ctx.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
        // We are able to evaluate policy, now trying to scan face.
        ctx.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Accessing the Mikoshi.") { success, authErr in
            DispatchQueue.main.async {
                if success {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    } else {
        completion(false)
    }
}

