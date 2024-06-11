//
//  OTPGenerateViewController.swift
//  PubaliAuthenticator
//
//  Created by pblsdd-mac3 on 14/3/24.
//

import UIKit
import Lottie
import CryptoKit
@available(iOS 13.0, *)
class OTPGenerateViewController: UIViewController {
    @IBOutlet weak var progressView: UIProgressView!
    var timer: Timer?
    var counter = 0
    //var countdownTimer: Timer?
    var totalSeconds = 119
    //var currentSeconds: Int = 119
    var progressTimer: Timer?
    var animationView: LottieAnimationView?
    @IBOutlet weak var btnOTPGenerateAction: UIButton!
    @IBOutlet weak var btnOTPHeight: NSLayoutConstraint!
    @IBOutlet var motherView: UIView!
    @IBOutlet weak var lbBottomView: UILabel!
    @IBOutlet weak var lbTimerIcon: UILabel!
    @IBOutlet weak var lbTimer: UILabel!
    @IBOutlet weak var lbClip: UILabel!
    @IBOutlet weak var lbOTP: UILabel!
    @IBOutlet weak var generateView: UIView!
    @IBOutlet weak var lbMail: UILabel!
    @IBOutlet weak var uiViewBiometric: UIView!
    @IBOutlet weak var imgCopy: UIImageView!
    var instanceID:String = ""
    var email:String=""
    var ReqRef:String=""
    var responseString:String=""
    var authBearerToken:String=""
    @IBOutlet weak var imgTimerShow: UIImageView!
    @IBOutlet weak var lbMailid: UILabel!
    @IBOutlet weak var imgCopyheight: NSLayoutConstraint!
    var symmetricKey: SymmetricKey?
    var remainingTime: TimeInterval = 120.0
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    var totalTime: TimeInterval = 120 // 120 seconds
    var backgroundEnteredTime: Date?
    var progress: Float = 0.0
    var enterBackgroundTime: Date?
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImage(named: "bgotp")
        let backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.frame = view.bounds
        motherView.addSubview(backgroundImageView)
        motherView.sendSubviewToBack(backgroundImageView)
        let backgroundbottomImage = UIImage(named: "cardbg")
        let backgroundImagebottomView = UIImageView(image: backgroundbottomImage)
        backgroundImagebottomView.contentMode = .scaleAspectFill
        backgroundImagebottomView.frame = view.bounds
        uiViewBiometric.backgroundColor = UIColor(red: 241/255, green: 245/255, blue: 249/255, alpha: 1.0)
        generateView.backgroundColor = UIColor(red: 241/255, green: 245/255, blue: 249/255, alpha: 1.0)
        generateImageView()
        instanceID = UserDefaults.standard.string(forKey: "instanceId") ?? ""
        email = UserDefaults.standard.string(forKey: "email") ?? ""
        print("email: \(email) \(instanceID)")
        uiViewBiometric.setOTPGrayBorder()
        progressView.progress = 0
        progressView.progressTintColor = UIColor(hexString: "1CB05F")
        //progressView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(copyTapped))
        imgCopy.isUserInteractionEnabled = true
        imgCopy.addGestureRecognizer(tapGestureRecognizer)
       // btnOTPGenerateAction.addTarget(self, action: #selector(findOTPFromAPIDesign), for: .touchUpInside)
        btnOTPGenerateAction.setButtonBackground()
        authBearerToken=UserDefaults.standard.string(forKey: "token") ?? ""
        NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
               NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        if Reachability.isConnectedToNetwork() {
            processing()
            self.requestOTP()
        }else{
            self.showAlert(alertTitle: "Alert", alertMessage: "Check internet connectivity")
        }

    }
    
    
    func generateImageView(){
        let emailAddress = UserDefaults.standard.string(forKey: "email")
        lbMailid.text=emailAddress ?? ""
        
    }
    @IBAction func btnGenOTPAction(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
            processing()
            self.requestOTP()
        }else{
            self.showAlert(alertTitle: "Alert", alertMessage: "Check internet connectivity")
        }
        
    }
    
    
    @objc func copyTapped(sender: UITapGestureRecognizer) {
        // Get the CGPoint of the tap
        let tapLocation = sender.location(in: imgCopy)
        if imgCopy.bounds.contains(tapLocation) {
            // Now you can access the label's text
            let otpText = lbOTP.text ?? ""
            print("Label Text: \(otpText)")
            Utility.show(message: "Copy..", controller: self)
            UIPasteboard.general.string = lbOTP.text
        }
    }
    @objc func requestOTP(){
         totalSeconds = 119
         remainingTime=119
        DispatchQueue.main.async {
            do {
                self.showSpinner(onView: self.view)
                self.ReqRef = UUID().uuidString
                var hmackInputString = "\("PICB")\("TOTP")\("IOS")\(self.email)\(self.instanceID)"
                print("hMac code\(hmackInputString)")
                var  hmackEncrString = self.getHMACKShohozString(str: hmackInputString)
                print("datasing\(hmackEncrString)")
                DispatchQueue.main.async {
                    self.processing()
                }
                let requestDetails = TOTPRequest(
                    baseurl:AllURL.MIDWAREURL,
                    apiendpoint: "cib/api/v1/Auth/generatelogintotp",
                    method: "POST",
                    apicode: "B24TOTP102",
                    headerkeyval: [
                        HeaderKeyVal(headerKey: "Content-Type", headerVal: "application/json"),
                        HeaderKeyVal(headerKey: "x-api-key", headerVal: "sdsf3vhvpq9865sjgdjh656hsg##"),
                        HeaderKeyVal(headerKey: "Authorization", headerVal: "Bearer "+self.authBearerToken)
                    ],
                    bodyobject: BodyTOTP(
                        email: self.email,
                        mac: "",
                        modulename: "TOTP",
                        product: "PICB",
                        platform: "IOS",
                        instanceid: self.instanceID,
                        datasign: hmackEncrString,
                        message: "",
                        status: "",
                        ip: "",
                        reqref:self.ReqRef
                    )
                )
                let encoder = JSONEncoder()
                guard let requestData = try? encoder.encode(requestDetails) else {
                    print("Failed to encode request data")
                    self.removeSpinner()
                    self.stopLoadingAnimation()
                    return
                }
                print("test \(requestDetails)")
                let urlString = AllURL.FM_DETAILS
                
                // Create a URLRequest with your API endpoint and method
                guard let url = URL(string:urlString ) else {
                    fatalError("Invalid URL")
                    self.removeSpinner()
                    self.stopLoadingAnimation()
                    print("Invalid URL")
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
                        self.showAlert(alertTitle: "Alert", alertMessage: "\(error)")
                        self.firstTimeAllGone()
                        self.stopLoadingAnimation()
                        self.removeSpinner()
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse else {
                        print("Invalid response")
                        self.firstTimeAllGone()
                        self.showAlert(alertTitle: "Alert", alertMessage: "Unexpected error")
                        self.stopLoadingAnimation()
                        self.removeSpinner()
                        return
                    }
                    
                    print("Response status code: \(httpResponse.statusCode)")
                    self.removeSpinner()
                    if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        print("Response data: \(responseString)")
                        do{
                            DispatchQueue.main.async {
                                self.stopLoadingAnimation()
                                self.removeSpinner()
                            }
                            let st = String(data:data,encoding: .utf8)
                            if let jsonData = responseString.data(using: .utf8) { // Convert the JSON string to Data
                                do {
                                    let decoder = JSONDecoder()
                                    let response = try decoder.decode(ResponseTOTP.self, from: jsonData) // Decode to struct
                                    print("Instance ID: \(response.instanceid ?? "nil")")
                                    if response.status=="200"{
                                        DispatchQueue.main.async {
                                            self.findOTPFromAPIDesign()
                                            //self.startTimer()
                                            self.startProgressBar()
                                            self.lbOTP.text=response.totp ?? ""
                                            self.removeSpinner()
                                    
                                        }
                                    }
                                    else if (response.status=="401"){
                                        DispatchQueue.main.async {
                                            self.stopLoadingAnimation()
                                            self.removeSpinner()
                                            self.EndOTPFromAPIDesign()
                                            self.showErrorAlert(viewController: self, message: "Session has been expire")
                                            self.removeSpinner()
                                        }
                                    }
                                    
                                    else{
                                        DispatchQueue.main.async {
                                            self.showAlert(alertTitle: "Alert", alertMessage:response.message ?? "")
                                            self.stopLoadingAnimation()
                                            self.EndOTPFromAPIDesign()
                                            self.removeSpinner()
                                        }
                                    }
                                } catch {
                                    print("Error parsing JSON: \(error)")
                                    self.removeSpinner()
                                }
                            }
                            
                            
                        }catch{
                            DispatchQueue.main.async {
                                print(error.localizedDescription)
                                self.firstTimeAllGone()
                                self.stopLoadingAnimation()
                                self.showAlert(alertTitle: "Alert", alertMessage: "Somethings went wrong")
                                self.removeSpinner()
                            }
                        }
                        
                    }
                }
                
                task.resume()
                
            } catch {
                print("Unexpected error: \(error).")
                self.stopLoadingAnimation()
                self.removeSpinner()
            }
        }
    }
    
    func startProgressBar() {
        progressTimer?.invalidate()
        //progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateProgressBar), userInfo: nil, repeats: true)
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                   self?.updateProgressBar()
               }
//        // Renew background task every 25 seconds to avoid termination
//        DispatchQueue.main.asyncAfter(deadline: .now() + 25) {
//                    self.startNewBackgroundTask()
//                }
    }
    @objc func updateProgressBar() {

        progressView.isHidden=false
        progressView.semanticContentAttribute = .forceLeftToRight
        progressView.progressTintColor = UIColor(hexString: "1CB05F")
//        if currentSeconds > 0 {
//                  currentSeconds -= 1
//                  
//                  let minutes = currentSeconds / 60
//                  let seconds = currentSeconds % 60
//                  
//                  lbTimer.text = String(format: "%d:%02d", minutes, seconds)
//                  lbTimer.textColor=UIColor.systemGreen
//                  // Calculate progress as a fraction of total time
//                  let progress = Float(currentSeconds) / Float(totalSeconds)
//                  progressView.progress = progress
//                  imgTimerShow.image = UIImage(named: "timer")
//              } else {
//                  countdownTimer?.invalidate() // Stop the timer
//                  countdownTimer = nil
//                  lbTimer.textColor=UIColor.black
//                  lbTimer.text = "0:00"
//                  progressView.progress = 0.0
//                  EndOTPFromAPIDesign()
//                  endAllBackgroundTasks()
//                  // Perform additional actions if needed (e.g., show an alert, trigger an event)
//              }
        
        /////////
        guard remainingTime > 0 else {
                    timer?.invalidate()
                    timer = nil
                    lbTimer.textColor=UIColor.black
                    lbTimer.text = "0:00"
                    progressView.progress = 0.0
                    EndOTPFromAPIDesign()
                    //endAllBackgroundTasks()
                    return
                }
                progressView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                remainingTime -= 1
                progress = Float(totalTime - remainingTime) / Float(totalTime)
                progressView.setProgress(progress, animated: true)
                
                let minutes = Int(remainingTime) / 60
                let seconds = Int(remainingTime) % 60
                lbTimer.text = String(format: "%02d:%02d", minutes, seconds)
                imgTimerShow.image = UIImage(named: "timer")
    }
    
    @objc  func findOTPFromAPIDesign(){
        DispatchQueue.main.async {
            self.btnOTPGenerateAction.isHidden=true
            self.btnOTPHeight.constant=0
            self.imgCopy.isHidden=false
            self.lbOTP.isHidden=false
            self.imgCopyheight.constant=30
        }
        
        
    }
    @objc  func firstTimeAllGone(){
        DispatchQueue.main.async { [self] in
            self.btnOTPGenerateAction.isHidden=true
            self.btnOTPHeight.constant=0
            self.imgCopy.isHidden=true
            lbOTP.isHidden=true
            self.imgCopyheight.constant=0
            
        }
        
    }
    @objc  func EndOTPFromAPIDesign(){
        btnOTPGenerateAction.isHidden=false
        btnOTPHeight.constant=40
        imgCopy.isHidden=true
        lbOTP.isHidden=true
        self.imgCopyheight.constant=0
        progressView.progress=0
        imgTimerShow.image = imgTimerShow.image!.withRenderingMode(.alwaysTemplate)
        //imgTimerShow.tintColor = UIColor.black
        imgTimerShow.tintColor = UIColor.lightGray
        
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
        
        animationView = .init(name: "generate")
        // animationView!.frame = Viewlottie.bounds
        animationView?.contentMode = .scaleAspectFit
        animationView?.loopMode = .loop
        animationView?.backgroundBehavior = .pauseAndRestore
        animationView?.isHidden = true
        animationView?.backgroundColor = UIColor(named: "#1CB05F")
        view.addSubview(animationView!)
        animationView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView?.centerXAnchor.constraint(equalTo: lbOTP.centerXAnchor),
            animationView?.centerYAnchor.constraint(equalTo: lbOTP.centerYAnchor),
            animationView?.widthAnchor.constraint(equalToConstant: 100), // Adjust size as needed
            animationView?.heightAnchor.constraint(equalToConstant: 60)
        ].compactMap { $0 }) // Remove optional constraints
        startLoadingAnimation()
    }
    func startLoadingAnimation() {
        animationView?.play()
    }
    
    func stopLoadingAnimation() {
        animationView?.stop()
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


    @objc func appWillResignActive() {
            enterBackgroundTime = Date()
            backgroundTask = UIApplication.shared.beginBackgroundTask {
                UIApplication.shared.endBackgroundTask(self.backgroundTask)
                self.backgroundTask = .invalid
            }
        }
        
        @objc func appDidBecomeActive() {
            if let enterBackgroundTime = enterBackgroundTime {
                let elapsedTime = Date().timeIntervalSince(enterBackgroundTime)
                remainingTime -= elapsedTime
                if remainingTime < 0 {
                    remainingTime = 0
                }
                //progress = Float(totalTime - remainingTime) / Float(totalTime)
                progress = Float(remainingTime) / Float(totalTime)
                progressView.setProgress(progress, animated: true)
                
                let minutes = Int(remainingTime) / 60
                let seconds = Int(remainingTime) % 60
                lbTimer.text = String(format: "%02d:%02d", minutes, seconds)
            }
            if backgroundTask != .invalid {
                UIApplication.shared.endBackgroundTask(backgroundTask)
                backgroundTask = .invalid
            }
        }
    
}
extension UIView{
    func setOTPGrayBorder(){
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 0.5
        
    }
}




