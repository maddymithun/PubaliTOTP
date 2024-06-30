//
//  DeviceSignUpViewController.swift
//  PubaliAuthenticator
//
//  Created by Mithun Chandra Dey on 30/6/24.
//

import UIKit
import SwiftKeychainWrapper
class DeviceSignUpViewController: UIViewController {

    @IBOutlet weak var etChangePassword: UITextField!
    @IBOutlet weak var viewChangePassword: UIView!
    @IBOutlet weak var etPassowrd: UITextField!
    @IBOutlet weak var etEmail: UITextField!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var viewSignUpEmail: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailCodeViewDesign()
        
    }
    @IBAction func btnSingup(_ sender: Any) {
        if isValidEmail(etEmail.text ?? ""){
            if etPassowrd.text?.count ?? 0>6{
                let signUpSuccess = signUp(email: etEmail.text ?? "", password: etPassowrd.text ?? "")
                print("Sign up successful: \(signUpSuccess)")
                if signUpSuccess{
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let loginViewController = storyboard.instantiateViewController(withIdentifier: "DeviceLoginViewController") as! DeviceLoginViewController
                    loginViewController.modalPresentationStyle = .fullScreen
                    self.present(loginViewController, animated: true, completion: nil)
                }
            }else{
                alert(message: "Password more then 6 characters")
            }
        }else{
            alert(message: "Enter valid mail")
        }
    }
    func emailCodeViewDesign(){
        etPassowrd.borderStyle = UITextField.BorderStyle.none
        etChangePassword.borderStyle = UITextField.BorderStyle.none
        etEmail.borderStyle = UITextField.BorderStyle.none
        viewSignUpEmail.setEkycGrayBorder()
        viewPassword.setEkycGrayBorder()
        viewChangePassword.setEkycGrayBorder()
    }
    func isValidEmail(_ email: String) -> Bool {
         // Regular expression for basic email validation
         let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
         let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
         return emailPredicate.evaluate(with: email)
     }
    func signUp(email: String, password: String) -> Bool {
        if etPassowrd.text ?? "" != etChangePassword.text ?? ""{
            self.alert(message: "New password and Confirm password is not same")
            return false
        }
           /// Save email to keychain
           let emailSaved = KeychainWrapper.standard.set(email, forKey: "userEmail")
           /// Save password to keychain
           let passwordSaved = KeychainWrapper.standard.set(password, forKey: "userPassword")
            
           return emailSaved && passwordSaved
       }

}
