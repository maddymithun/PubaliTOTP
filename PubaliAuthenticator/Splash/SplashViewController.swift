//
//  SplashViewController.swift
//  PubaliAuthenticator
//
//  Created by pblsdd-mac3 on 14/3/24.
//

import UIKit
import CryptoKit
@available(iOS 13.0, *)
class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        accessTokenGen()
       
    }
    func showLoginScreen() {
   
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
                            print("response token:\(responseFinal.accesstoken)")
                            UserDefaults.standard.set(responseFinal.accesstoken, forKey: "token")
                            DispatchQueue.main.async {
                                self.showLoginScreen()
                              
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

