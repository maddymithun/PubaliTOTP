//
//  LoginViewController.swift
//  PubaliAuthenticator
//
//  Created by pblsdd-mac3 on 14/3/24.
//

import UIKit
import Lottie
import CryptoKit

@available(iOS 13.0, *)
class LoginViewController: UIViewController {
    private var lottieAnimationView: LottieAnimationView!
    private var backgroundOverlayView: UIView!
    @IBOutlet weak var codeView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet var loginView: UIView!
    @IBOutlet weak var etCode: UITextField!
    @IBOutlet weak var etEmail: UITextField!
    private let backgroundView = UIView()
    var hmackEncrString:String=""
    var authBearerToken:String=""
    var ReqRef:String=""
    let userDefaults = UserDefaults.standard
    @IBOutlet weak var btnSubmit: UIButton!
    var deviceRegistrationResponse:ResponseDevice!
    let keyIdentifier = "MySymmetricKeyIdentifier"
    var symmetricKey: SymmetricKey?
    override func viewDidLoad() {
        super.viewDidLoad()

        let backgroundImage = UIImage(named: "loginbg")
        let backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.frame = view.bounds
        loginView.addSubview(backgroundImageView)
        loginView.sendSubviewToBack(backgroundImageView)
        emailCodeViewDesign()
        //setupBackgroundOverlay()
        authBearerToken=UserDefaults.standard.string(forKey: "token") ?? ""
        btnSubmit.setButtonBackground()
    }
    func requestDevice(){
        do {
            ReqRef = UUID().uuidString
            var hmackInputString = "\("PICB")\("TOTP")\("IOS")\(etEmail.text ?? "")\( etCode.text ?? "")"
            print("hMac code\(hmackInputString)")
            hmackEncrString = self.getHMACKShohozString(str: hmackInputString)
            processing()
            let requestDetails = DeviceRequest(
                baseurl: "https://172.16.254.113/CorporateBankingApiTEST",
                apiendpoint: "cib/api/v1/Auth/deviceregistration",
                method: "POST",
                apicode: "B24TOTP101",
                headerkeyval: [
                    HeaderKeyVal(headerKey: "Content-Type", headerVal: "application/json"),
                    HeaderKeyVal(headerKey: "x-api-key", headerVal: "sdsf3vhvpq9865sjgdjh656hsg##"),
                    HeaderKeyVal(headerKey: "Authorization", headerVal: "Bearer "+authBearerToken)
                ],
            
                bodyobject: BodyObject(
                 
                    email: etEmail.text ?? "",
                    mac: "",
                    activationcode: etCode.text ?? "",
                    modulename: "TOTP",
                    product: "PICB",
                    platform: "IOS",
                    instance: "",
                    datasign: hmackEncrString,
                    message: "",
                    status: "",
                    ip: "",
                    reqref:ReqRef
                )
            )
            let encoder = JSONEncoder()
            guard let requestData = try? encoder.encode(requestDetails) else {
                fatalError("Failed to encode request data")
                print("Failed to encode request data")
                DispatchQueue.main.async {
                    self.stopAnimation()
                }
            }
            let urlString = AllURL.FM_DETAILS

            // Create a URLRequest with your API endpoint and method
            guard let url = URL(string:urlString ) else {
                fatalError("Invalid URL")
                print("Invalid URL")
                DispatchQueue.main.async {
                    self.stopAnimation()
                }
            }

            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = requestDetails.method
            urlRequest.httpBody = requestData
            urlRequest.allHTTPHeaderFields = [
              "Content-Type": "application/json",
              "x-api-key": "65654d6sdjhsjdh##"
            ]

            // Make the API call
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                    DispatchQueue.main.async {
                        self.stopAnimation()
                    }
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Invalid response")
                    DispatchQueue.main.async {
                        self.stopAnimation()
                    }
                    return
                }

                print("Response status code: \(httpResponse.statusCode)")

                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("Response data: \(responseString)")
                    do{
                        DispatchQueue.main.async {
                            self.stopAnimation()
                        }
                        let jsonModel = JSONDecoder()
                        
                        let responseFinal = try jsonModel.decode(ResponseDevice.self, from: data)
                        print("*****This is the data 4: \(responseFinal)")
                        
                        if responseFinal.status == "200"
                        { 
                            DispatchQueue.main.async {
                                
                               
                                UserDefaults.standard.set(self.etEmail.text ?? "", forKey: "email")
                                UserDefaults.standard.set(responseFinal.instanceid, forKey: "instanceId")
                                print(responseFinal.instanceid)
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let loginViewController = storyboard.instantiateViewController(withIdentifier: "otp") as! OTPGenerateViewController
                                loginViewController.modalPresentationStyle = .fullScreen
                                self.present(loginViewController, animated: true, completion: nil)
                            }
                            
                        }   else if (responseFinal.status=="401"){
                            DispatchQueue.main.async {
                                self.stopAnimation()
                                self.removeSpinner()
                                self.showErrorAlert(viewController: self, message: "Session has been expire")
                                
                            }
                        }
                        
                        else{
                           
                            DispatchQueue.main.async {
                                self.stopAnimation()
                                self.showAlert(alertTitle: "Alert", alertMessage:responseFinal.message ?? "")
                                
                            }
                            
                        }
                        
                    }catch{
                        DispatchQueue.main.async {
                            self.stopAnimation()
                            print(error.localizedDescription)
                            self.showAlert(alertTitle: "Alert", alertMessage: "Unexpected error: \(error.localizedDescription)")
                        }
                    }
         
                }
            }

            task.resume()
            
        } catch {
            print("Unexpected error: \(error).")
            showAlert(alertTitle: "Alert", alertMessage: "Unexpected error: \(error).")
        }
    }

    @IBAction func btnLogin(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
            if isValidEmail(etEmail.text ?? ""){
                       if(etEmail.text?.isEmpty ?? true){
                           showAlert(alertTitle: "Alert", alertMessage: "please enter mail id")
                           return
                       }
                       if(etCode.text?.isEmpty ?? true){
                           showAlert(alertTitle: "Alert", alertMessage: "please enter code")
                           return
                       }
                   }else{
                       showAlert(alertTitle: "Alert", alertMessage: "Mail is not valid mail")
                       return
                   }
            requestDevice()
        } else {
            showAlert(alertTitle: "Connectivity", alertMessage: "please check internet connection")
            DispatchQueue.main.async {
                self.stopAnimation()
            }
        }

     
    }
    func emailCodeViewDesign(){
        etCode.borderStyle = UITextField.BorderStyle.none
        etEmail.borderStyle = UITextField.BorderStyle.none
        codeView.setEkycGrayBorder()
        emailView.setEkycGrayBorder()
    }
    func isValidEmail(_ email: String) -> Bool {
         // Regular expression for basic email validation
         let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
         let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
         return emailPredicate.evaluate(with: email)
     }
    func showAlert(alertTitle:String,alertMessage:String) {
        // Create an alert controller
        let alertController = UIAlertController(title: alertTitle, message:alertMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
       
        }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    func processing(){
     
        setupBackgroundOverlay()
        lottieAnimationView = LottieAnimationView(name: "loading") // Replace with your Lottie animation name
               lottieAnimationView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
               lottieAnimationView.center = view.center
               lottieAnimationView.contentMode = .scaleAspectFit
               backgroundOverlayView.addSubview(lottieAnimationView)
               lottieAnimationView.play(fromProgress: 0, toProgress: 1, loopMode: .loop)
   }

    func setupBackgroundOverlay() {
            backgroundOverlayView = UIView(frame: view.bounds)
            backgroundOverlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5) // 50% transparency
            view.addSubview(backgroundOverlayView)
        }
    // Method to start the animation
       func startAnimation() {
           DispatchQueue.main.async {
               self.backgroundOverlayView.isHidden = false // Show the overlay
               self.lottieAnimationView.play(fromProgress: 0, toProgress: 1, loopMode: .loop)
           }
       }
       
       // Method to stop the animation
       func stopAnimation() {
           DispatchQueue.main.async {
              // self.stopAnimation()
               //self.setupBackgroundOverlay()
               self.backgroundOverlayView.isHidden = true // Hide the overlay
           }
       }
    
    func accessTokenGen(){
   
        
        do {
            var hmackTokenValue = "\("PICB")\("TOTP")\("IOS")\("picbtotp2024")\("dibakar:feni1992")"
           var hmackEncrStringToken = self.getHMACKShohozString(str: hmackTokenValue)
            let requestDetails = AccessTokenRequest(
                      baseUrl: "https://172.16.254.113/CorporateBankingApiTEST",
                      apiEndpoint: "cib/api/v1/Auth/gentotpaccesstoken",
                      method: "get",
                      apiCode: "B24TOTP100",
                      HeaderKeyVal: [
                          HeaderKeyVal(headerKey: "Content-Type", headerVal: "application/json"),
                          HeaderKeyVal(headerKey: "x-api-key", headerVal: "sdsf3vhvpq9865sjgdjh656hsg##")
                      ],
                      bodyObject: AccessTokenRequestBody(
                          product: "PICB",
                          modulename: "TOTP",
                          platform: "IOS",
                          username: "picbtotp2024",
                          password: "dibakar:feni1992",
                          datasign:hmackEncrStringToken
                      )
                  )
            let encoder = JSONEncoder()
            guard let requestData = try? encoder.encode(requestDetails) else {
                print("Failed to encode request data")
              
                return
            }
            let urlString = AllURL.FM_DETAILS
            
            // Create a URLRequest with your API endpoint and method
            guard let url = URL(string:urlString ) else {
                fatalError("Invalid URL")
                print("Invalid URL")
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = requestData
            urlRequest.allHTTPHeaderFields = [
                "Content-Type": "application/json",
                "x-api-key": "65654d6sdjhsjdh##"
            ]
            // Make the API call
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Invalid response")
                    return
                }
                
                print("Response status code: \(httpResponse.statusCode)")
                self.removeSpinner()
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("Response data: \(responseString)")
                    do{
                        
                        let jsonModel = JSONDecoder()
                        
                        let responseFinal = try jsonModel.decode(AccessTokenResponse.self, from: data)
                        if(responseFinal.status=="200"){
                            DispatchQueue.main.async {
                                print("response token:\(responseFinal.accesstoken)")
                            }
                            
                            
                        }else{
                            
                        }
                        
                    }catch{
                        print(error.localizedDescription)
                        
                    }
                    
                }
            }
            
            task.resume()
            
        } catch {
            print("Unexpected error: \(error).")
           
        }
          }
    

    

}
extension UIView{
    func setEkycGrayBorder(){
        
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 0.5
        
    }
    func setButtonBackground(){
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor(hexString: "1CB05F").cgColor
        self.layer.backgroundColor = UIColor(hexString: "1CB05F").cgColor
        self.layer.cornerRadius = 16
        self.layer.borderWidth = 0.5
    }
}


