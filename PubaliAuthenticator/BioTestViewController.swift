//
//  BioTestViewController.swift
//  PubaliAuthenticator
//
//  Created by Mithun Chandra Dey on 30/4/24.
//

import UIKit
import LocalAuthentication
class BioTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    override func viewDidAppear(_ animated: Bool) {
          super.viewDidAppear(animated)
          requestFaceIDAuthentication()
      }
      
    func requestFaceIDAuthentication() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate with Face ID to access this feature."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.onAuthenticationSuccess()
                    } else {
                        self.handleFaceIDError(authenticationError)
                    }
                }
            }
        } else {
            // Handle when Face ID is unavailable
            self.handleFaceIDError(error)
        }
    }

    func handleFaceIDError(_ error: Error?) {
        guard let error = error as? LAError else {
            print("Unknown error")
            return
        }
        
        var message = ""
        
        switch error.code {
        case .authenticationFailed:
            message = "Face ID authentication failed. Please try again."
        case .userCancel:
            message = "Authentication was canceled. Please try again."
        case .userFallback:
            message = "Authentication fallback triggered. Please use your passcode."
        case .biometryNotAvailable:
            message = "Face ID is not available on this device."
        case .biometryNotEnrolled:
            message = "Face ID is not set up. Please enroll in Settings."
        case .biometryLockout:
            message = "Face ID is locked due to too many failed attempts. Please use your passcode."
        default:
            message = "An unknown error occurred. Please try again."
        }
        
        let alert = UIAlertController(title: "Face ID Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func onAuthenticationSuccess() {
        print("Authentication was successful.")
        // Your logic here (e.g., navigating to a different screen or updating the UI)
    }
}
