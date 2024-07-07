//
//  DeviceLoginViewController.swift
//  PubaliAuthenticator
//
//  Created by Mithun Chandra Dey on 30/6/24.
//

import UIKit
import SwiftKeychainWrapper

class DeviceLoginViewController: UIViewController {

    @IBOutlet weak var lbForgetPassword: UILabel!
    @IBOutlet weak var lbSingup: UILabel!
    @IBOutlet weak var lbTitleSignUpSignIn: UILabel!
    @IBOutlet weak var etPassword: UITextField!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var etEmail: UITextField!
    @IBOutlet weak var viewEmail: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailCodeViewDesign()
         let emailSaved = UserDefaults.standard.string(forKey: "userEmail")
        if emailSaved == nil{
           
        }else{
            etEmail.text=UserDefaults.standard.string(forKey: "userEmail")
            lbSingup.isHidden=true
        }
        updateLabel(with: "Do not have account? ")
        lbSingup.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(gotoSignUP))
        lbSingup.addGestureRecognizer(tapGesture)
        etPassword.isSecureTextEntry = true

    }
    @objc func gotoSignUP(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if #available(iOS 13.0, *) {
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "DeviceSignUpViewController") as! DeviceSignUpViewController
            loginViewController.modalPresentationStyle = .fullScreen
            present(loginViewController, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    @IBAction func btnLogin(_ sender: Any) {
        if isValidEmail(etEmail.text ?? ""){
            let loginSuccess = login(email: etEmail.text ?? "", password: etPassword.text ?? "")
            print("loginSuccess successful: \(loginSuccess)")
            if loginSuccess{
                      let  instanceId = UserDefaults.standard.string(forKey: "instanceId")
                
                        if instanceId != nil{
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            if #available(iOS 13.0, *) {
                                let loginViewController = storyboard.instantiateViewController(withIdentifier: "otp") as! OTPGenerateViewController
                                loginViewController.modalPresentationStyle = .fullScreen
                                present(loginViewController, animated: true, completion: nil)
                            } else {
                                // Fallback on earlier versions
                            }
                           
                
                        } else {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            if #available(iOS 13.0, *) {
                                let loginViewController = storyboard.instantiateViewController(withIdentifier: "login") as! LoginViewController
                                loginViewController.modalPresentationStyle = .fullScreen
                                present(loginViewController, animated: true, completion: nil)
                            } else {
                                // Fallback on earlier versions
                            }
                            
                
                        }
            }else{
                alert(message: "Login password not match")
            }
        }
    }
    func emailCodeViewDesign(){
        etPassword.borderStyle = UITextField.BorderStyle.none
        etEmail.borderStyle = UITextField.BorderStyle.none
        viewEmail.setEkycGrayBorder()
        viewPassword.setEkycGrayBorder()
    }
    func isValidEmail(_ email: String) -> Bool {
         /// Regular expression for basic email validation
         let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
         let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
         return emailPredicate.evaluate(with: email)
     }
    ///login check
    func login(email: String, password: String) -> Bool {
            // Retrieve email and password from keychain
            if let storedEmail = UserDefaults.standard.string(forKey: "userEmail"),
               let storedPassword = UserDefaults.standard.string(forKey: "userPassword") {
                /// Check if the provided credentials match the stored credentials
                if email == storedEmail && password == storedPassword{
                    return true
                }
            }
            return false
        }
    func updateLabel(with text: String) {
            // Base text from API
            let baseText = text
            
            // Text to be appended
            let appendedText = " Sign Up"
            
            // Create an NSMutableAttributedString with the base text
            let attributedString = NSMutableAttributedString(string: baseText)
            
            // Attributes for the appended text (blue color)
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.systemGreen
            ]
            
            // Create an attributed string with the appended text and attributes
            let attributedAppendedText = NSAttributedString(string: appendedText, attributes: attributes)
            
            // Append the attributed text
            attributedString.append(attributedAppendedText)
            
            // Set the attributed text to the label
           lbSingup.attributedText = attributedString
        }
}
