//
//  BioMetricViewController.swift
//  PubaliAuthenticator
//
//  Created by pblsdd-mac3 on 14/3/24.
//

import UIKit
import LocalAuthentication
@available(iOS 13.0, *)
class BioMetricViewController: UIViewController {

    @IBOutlet weak var lbOr: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnGoFaceIDSetting: UIButton!
    @IBOutlet weak var imgFaceId: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnGoFaceIDSetting.isHidden=true
        NSLayoutConstraint.activate([
            imgFaceId.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imgFaceId.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            imgFaceId.widthAnchor.constraint(equalToConstant: 200), // Example width
            imgFaceId.heightAnchor.constraint(equalToConstant: 200)  // Example height
                ])
        /// Trigger Face ID authentication when the view loads
               if isFaceIDAvailable() {
                   authenticateWithFaceID()
                   btnLogin.isHidden=true
                   lbOr.isHidden=true
               } else {
                   handleFaceIDNotAvailable()
                   btnGoFaceIDSetting.isHidden=false
               }
       
    }
    /// Handle Face ID success
       func onFaceIDSuccess() {
                 let  instanceId = UserDefaults.standard.string(forKey: "instanceId")
           
                   if instanceId != nil{
                       let storyboard = UIStoryboard(name: "Main", bundle: nil)
                       let loginViewController = storyboard.instantiateViewController(withIdentifier: "otp") as! OTPGenerateViewController
                       loginViewController.modalPresentationStyle = .fullScreen
                       present(loginViewController, animated: true, completion: nil)
           
                   } else {
                       let storyboard = UIStoryboard(name: "Main", bundle: nil)
                       let loginViewController = storyboard.instantiateViewController(withIdentifier: "login") as! LoginViewController
                       loginViewController.modalPresentationStyle = .fullScreen
                       present(loginViewController, animated: true, completion: nil)
           
                   }
       }
    /// Handle Face ID failure
      func onFaceIDFailure(error: NSError) {
          // Handle different failure cases
          var message = "Face ID authentication failed."
          
          switch error.code {
          case LAError.userCancel.rawValue:
              message = "Authentication was canceled by the user."
          case LAError.biometryNotEnrolled.rawValue:
              message = "Face ID is not set up. Please go to Settings to enroll."
          case LAError.biometryLockout.rawValue:
              message = "Face ID is locked due to too many failed attempts."
          default:
              message = error.localizedDescription
          }
          
          let alert = UIAlertController(title: "Authentication Failed", message: message, preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default))
          present(alert, animated: true)
      }
    // Check if Face ID is available on the device
        func isFaceIDAvailable() -> Bool {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                return context.biometryType == .faceID
            }
            
            return false
        }
    /// Authenticate with Face ID
       func authenticateWithFaceID() {
           let context = LAContext()
           let reason = "Please authenticate with Face ID to access secure content."
           
           context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
               DispatchQueue.main.async {
                   if success {
                       // Authentication was successful, proceed with secure content
                       self.onFaceIDSuccess()
                   } else {
                       // Authentication failed or was canceled
                       if let error = error {
                           self.onFaceIDFailure(error: error as NSError)
                       }
                   }
               }
           }
       }
      ///Handle the case where Face ID is not available
      func handleFaceIDNotAvailable() {
          let alert = UIAlertController(title: "Face ID Not Available", message: "This device does not support Face ID.", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default))
          present(alert, animated: true)
      }
    @IBAction func btnActionGoFaceID(_ sender: Any) {
        let faceIDSettingsURL = URL(string: "App-Prefs:FaceID&Passcode")!
               
               // Check if the URL can be opened
               if UIApplication.shared.canOpenURL(faceIDSettingsURL) {
                   // Open the Face ID settings
                   UIApplication.shared.open(faceIDSettingsURL, options: [:], completionHandler: nil)
               } else {
                   print("Could not open Face ID settings.")
               }
    }
    func authenticateUser() {
            let context = LAContext()
            var error: NSError?

            // Check if the device supports biometric authentication
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Authenticate to access your account"

                // Perform biometric authentication
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                    DispatchQueue.main.async {
                        if success {
                            // Biometric authentication successful
                            print("Authentication successful")
                           // self.showAlert(alertTitle: "Alert", alertMessage: "Authentication successful")
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let loginViewController = storyboard.instantiateViewController(withIdentifier: "otp") as! OTPGenerateViewController
                            loginViewController.modalPresentationStyle = .fullScreen
                            self.present(loginViewController, animated: true, completion: nil)
                        } else {
                            // Biometric authentication failed
                            print("Authentication failed")
                            DispatchQueue.main.async {
                                self.showAlert(alertTitle: "Alert", alertMessage: "Authentication failed")
                                //self.btnGoFaceIDSetting.isHidden=false
                            }
                        }
                    }
                }
            } else {
                // Device does not support biometric authentication
                print("Biometric authentication not available")
                DispatchQueue.main.async {
                    self.btnGoFaceIDSetting.isHidden=false
                    self.showAlert(alertTitle: "Alert", alertMessage: "Biometric authentication not available")
                    self.btnGoFaceIDSetting.setButtonBackground()
                }
            }
        }
    
    func showAlert(alertTitle:String,alertMessage:String) {
        // Create an alert controller
        let alertController = UIAlertController(title: alertTitle, message:alertMessage, preferredStyle: .alert)
        
        // Add an action (button)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            // Handle the action (if needed)
            print("OK button tapped")
        }
        
        // Add the action to the alert controller
        alertController.addAction(action)
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    /// not use. its used for touch
    func authenticateWithTouchID(completion: @escaping (Bool, Error?) -> Void) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate with Touch ID"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    completion(success, authenticationError)
                }
            }
        } else {
            completion(false, error)
        }
    }
    func loadFromKeychain(forKey key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject? = nil
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        if status == errSecSuccess {
            return dataTypeRef as? Data
        } else {
            return nil
        }
    }

    @IBAction func goToDeviceLogin(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let splashViewController = storyboard.instantiateViewController(withIdentifier: "DeviceLoginViewController") as! DeviceLoginViewController
        splashViewController.modalPresentationStyle = .fullScreen
        present(splashViewController, animated: true, completion: nil)
    }
}
