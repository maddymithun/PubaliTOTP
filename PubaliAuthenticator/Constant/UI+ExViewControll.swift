//
//  UI+ExViewControll.swift
//  DemoTwo
//
//  Created by Mahmudul on 25/4/19.
//  Copyright © 2019 Mahmudul. All rights reserved.
//


import Foundation
import UIKit
import SwiftKeychainWrapper
import StoreKit
import CommonCrypto
import CryptoKit
import CryptoSwift

var vSpinner : UIView?
var navTableView = ReusableTableView()
var loadingAlert : UIAlertController?
let hmackKey = "qw23erzdrwsZQTPV8ONL1611464375840"
let ekychmackKey = "qw23erzdrwsZQTPV8ONL1611464375840"
let shohozhmacKey = "4D2N8A1T9B6F7H3K4J5L6P0R"


extension  UIViewController {
    static var isEncrypted : String = "0"
    static var isUpdateRequire : String = "0"
    static var appStoreURL : String = "itms-apps://apple.com/app/id1522834437"
    static let heightRatio = UIScreen.main.bounds.height / 896
    static let widthRatio = UIScreen.main.bounds.width / 414
    

    var topbarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        } else {
            let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
            return topBarHeight
        }
    }
    func showSuccessAlert(withTitle title: String, andMessage message:String) {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style:
            UIAlertAction.Style.default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert,animated: true,completion: nil)
        }
        //        self.present(alert, animated: true, completion: nil)
    }
    open override func awakeFromNib() {
           navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
       }
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    func addActionSheetForiPad(actionSheet: UIAlertController) {
        if let popoverPresentationController = actionSheet.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverPresentationController.permittedArrowDirections = []
        }
    }
    // error and close the application
    func showErrorAlert(viewController: UIViewController, message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        viewController.present(alert, animated: true, completion: nil)
    }
    func showSpinner(onView : UIView) {
        
        DispatchQueue.main.async {
            let spinnerView = UIView.init(frame: UIScreen.main.bounds)
            spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.6)
            let subContainerView = UIView.init(frame: CGRect(x: spinnerView.center.x - 100, y: spinnerView.center.y, width: 200, height: 50))
            subContainerView.backgroundColor = UIColor(hexString: "#F9F9F9")
            subContainerView.layer.cornerRadius = 10.0
            subContainerView.layer.borderWidth = 1.0
            subContainerView.layer.borderColor = UIColor.lightGray.cgColor
            subContainerView.layer.masksToBounds = true
            //var blurImg = UIImageView()
            let indicator = UIActivityIndicatorView(frame: CGRect(x: 20, y: 12, width: 30, height: 30))
            indicator.style = .whiteLarge
            //indicator.center = blurImg.center
            indicator.startAnimating()
            indicator.color = UIColor(hexString: "#3c8c53")
            
            subContainerView.addSubview(indicator)
            // let label = UILabel()
            //print("tuhin------\(spinnerView.center.x),---\(ai.frame.size.width)")
            let label = UILabel(frame: CGRect(x: 60, y: 15, width: 140, height: 21))
            label.textAlignment = .center
            label.text = "Please Wait....."
            subContainerView.addSubview(label)
            spinnerView.addSubview(subContainerView)
            onView.addSubview(spinnerView)
            vSpinner = spinnerView
            // Indicator.sharedInstance.showIndicator()
            //            loadingAlert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
            //            if let bgView = loadingAlert?.view.subviews.first, let groupView = bgView.subviews.first, let contentView = groupView.subviews.first {
            //                contentView.backgroundColor = UIColor(hexString: "#3c8c53")
            //            }
            //            //alertContentView.backgroundColor = UIColor(hexString: "#3c8c53")
            //            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            //            loadingIndicator.hidesWhenStopped = true
            //            loadingIndicator.style = UIActivityIndicatorView.Style.gray
            //            loadingIndicator.startAnimating()
            //
            //            loadingAlert?.view.addSubview(loadingIndicator)
            //            self.present(loadingAlert!, animated: true, completion: nil)
            
        }
    }
    func showBinimoySpinner(onView : UIView) {
        
        DispatchQueue.main.async {
            let spinnerView = UIView.init(frame: UIScreen.main.bounds)
            spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.6)
            let subContainerView = UIView.init(frame: CGRect(x: spinnerView.center.x - 100, y: spinnerView.center.y, width: 200, height: 50))
            subContainerView.backgroundColor = UIColor(hexString: "#F9F9F9")
            subContainerView.layer.cornerRadius = 10.0
            subContainerView.layer.borderWidth = 1.0
            subContainerView.layer.borderColor = UIColor.lightGray.cgColor
            subContainerView.layer.masksToBounds = true
            //var blurImg = UIImageView()
            let indicator = UIActivityIndicatorView(frame: CGRect(x: 20, y: 12, width: 30, height: 30))
            indicator.style = .whiteLarge
            //indicator.center = blurImg.center
            indicator.startAnimating()
            indicator.color = UIColor(hexString: "#1390A6")
            
            subContainerView.addSubview(indicator)
            // let label = UILabel()
            //print("tuhin------\(spinnerView.center.x),---\(ai.frame.size.width)")
            let label = UILabel(frame: CGRect(x: 60, y: 15, width: 140, height: 21))
            label.textAlignment = .center
            label.text = "Please Wait....."
            subContainerView.addSubview(label)
            spinnerView.addSubview(subContainerView)
            onView.addSubview(spinnerView)
            vSpinner = spinnerView
            // Indicator.sharedInstance.showIndicator()
            //            loadingAlert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
            //            if let bgView = loadingAlert?.view.subviews.first, let groupView = bgView.subviews.first, let contentView = groupView.subviews.first {
            //                contentView.backgroundColor = UIColor(hexString: "#3c8c53")
            //            }
            //            //alertContentView.backgroundColor = UIColor(hexString: "#3c8c53")
            //            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            //            loadingIndicator.hidesWhenStopped = true
            //            loadingIndicator.style = UIActivityIndicatorView.Style.gray
            //            loadingIndicator.startAnimating()
            //
            //            loadingAlert?.view.addSubview(loadingIndicator)
            //            self.present(loadingAlert!, animated: true, completion: nil)
            
        }
    }
    func removeSpinner() {
        DispatchQueue.main.async {
            //           // print("tuhin--dfs-f-sfs-fs-fs-fs-fs")
            vSpinner?.removeFromSuperview()
            vSpinner = nil
            //            loadingAlert?.dismiss(animated: true, completion: nil)
            //            loadingAlert = nil
            //}
            // NotificationCenter.default.addObserver(loadingAlert, selector: Selector("hideAlertController"), name: NSNotification.Name(rawValue: "DismissAllAlertsNotification"), object: nil)
        }
    }
    func addMoreButtonToNavBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "more_vert_black.png"), style: .plain, target: self, action: #selector(self.dropDownMenuAction))//UIBarButtonItem(title: "Logout", style: .plain, target: self , action: #selector(self.dropDownMenuAction))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
   
    @objc func dropDownMenuAction() {
        
        if navTableView.tableView?.isHidden == true{
            navTableView.tableView?.isHidden = false
        }
        else{
            navTableView.tableView?.isHidden = true
        }
    }
    func popViewControllerss(popViews: Int, animated: Bool = true) {
        if self.navigationController!.viewControllers.count > popViews
        {
            let vc = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - popViews - 1]
            self.navigationController?.popToViewController(vc, animated: animated)
        }
    }

    func returnNumberSpell(inputString : String )->String{
        let string = Int(inputString )
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.spellOut
        
        formatter.locale = Locale(identifier: "en_IN")
        let spellOutText = formatter.string(for: string)?.uppercased() ?? ""
       return spellOutText
    }
    func getAmountSpellText(numberText : String)->String{
        
        let components = numberText.components(separatedBy: ".")
        if(numberText.contains(".") == true){
        if components.count == 2 {
                var firstPart = components[0]
            firstPart = self.returnNumberSpell(inputString: firstPart );
                var secondPart = components[1]
                secondPart = self.returnNumberSpell(inputString: secondPart );
            if(numberText.count > 0){
                    return "TK \(firstPart).\(secondPart) ONLY";
                }else{
                    return "";
                }
            }
        }else{
            var inputText = self.returnNumberSpell(inputString: numberText );
            if(numberText.count > 0){
                return  "TK \(inputText) ONLY";
            }else{
                return "";
            }
        }
        return ""
    }
    func getAllErrorMessages(from jsonObject: [String: Any]) -> String {
        guard let errors = jsonObject["errors"] as? [String: Any] else {
            return "" // No errors found
        }

        var errorMessages: [String] = []
        for (key, value) in errors {
            if let messages = value as? [String] {
                errorMessages.append(contentsOf: messages.map { "\(key): \($0)" })
            } else if let message = value as? String {
                errorMessages.append("\(key): \(message)")
            } else {
                // Handle unexpected value types for errors, if needed
                print("Unexpected error value type: \(type(of: value))")
            }
        }

        return errorMessages.joined(separator: "\n")
    }
    func convertToErrorDictionary(textData: Data) -> [String: Any]? {
       
            do {
                return try JSONSerialization.jsonObject(with: textData, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        return nil
    }
    
    func aesEncryptEKYC(key: String,dataString: String) -> String {
        
        var result = ""
        
        do {
            
            let key: [UInt8] = Array(key.utf8) as [UInt8]
            
            let aes = try AES(key: key, blockMode: ECB() , padding:.pkcs7) // AES128 .ECB pkcs7
            
            let encrypted = try aes.encrypt(Array(dataString.utf8))
            
            result = encrypted.toBase64()
            
            
            print("AES Encryption Result: \(result)")
            
        } catch {
        
            print("Error: \(error)")
        }
        return result
    }
    func aesDecryptEKYC(key: String, encryptedBase64: String) -> String? {
        do {
            // Convert the encryption key to a byte array
            let keyBytes: [UInt8] = Array(key.utf8)
            
            // Create AES with the same key, block mode (ECB), and padding (PKCS7)
            let aes = try AES(key: keyBytes, blockMode: ECB(), padding: .pkcs7)
            
            // Decode the base64-encoded ciphertext
            guard let encryptedBytes = Data(base64Encoded: encryptedBase64) else {
                print("Error: Could not decode base64 string")
                return nil
            }
            
            // Decrypt the ciphertext
            let decryptedBytes = try aes.decrypt(Array(encryptedBytes))
            
            // Convert the decrypted bytes to a UTF-8 string
            let decryptedString = String(bytes: decryptedBytes, encoding: .utf8)
            
            return decryptedString
            
        } catch {
            print("Error during decryption: \(error)")
            return nil
        }
    }
    func getDeviceInfo()->String{
        let phoneName = UIDevice.current.name
        let sysModel = UIDevice.modelName
        let sysName = UIDevice.current.systemName
        let sysVer = UIDevice.current.systemVersion
        let deviceInfo = "\(phoneName.count)" + phoneName + "\(sysModel.count)" + sysModel + "\(sysName.count)" + sysName + "\(sysVer.count)" + sysVer
        return deviceInfo
    }
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? UIImage()
    }
    func resizeNIDImage(image: UIImage, targetSize: CGSize) -> UIImage {
        
        let size = image.size
        
//        let widthRatio  = targetSize.width  / size.width
//        let heightRatio = targetSize.height / size.height
//
//        // Figure out what our orientation is, and use that to form the rectangle
//        var newSize: CGSize
//        if(widthRatio > heightRatio) {
//            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
//        } else {
//            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
//        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? UIImage()
    }
    func presentReviewRequest() {
           let twoSecondsFromNow = DispatchTime.now() + 2.0
           DispatchQueue.main.asyncAfter(deadline: twoSecondsFromNow) {
               if #available(iOS 14.0, *) {
                 if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                    SKStoreReviewController.requestReview(in: scene)
                  }
                     } else {
                        SKStoreReviewController.requestReview()
                            }
           }
       }
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        //location is relative to the current view
        // do something with the touched point
        print("tuhin------touch")
        if touch?.view != navTableView.tableView {
            if(navTableView.tableView?.isHidden == false){
                navTableView.tableView?.isHidden = true
            }
        }
    }
    @available(iOS 13.0, *)
    func encrypt(_ text: String, using key: SymmetricKey) -> Data? {
        guard let data = text.data(using: .utf8) else { return nil }
        do {
            let sealedBox = try AES.GCM.seal(data, using: key)
            return sealedBox.combined // The combined data (nonce, ciphertext, tag)
        } catch {
            print("Encryption error: \(error)")
            return nil
        }
    }

    // Function to decrypt data
    @available(iOS 13.0, *)
    func decrypt(_ encryptedData: Data, using key: SymmetricKey) -> String? {
        do {
            let sealedBox = try AES.GCM.SealedBox(combined: encryptedData)
            let decryptedData = try AES.GCM.open(sealedBox, using: key)
            return String(data: decryptedData, encoding: .utf8)
        } catch {
            print("Decryption error: \(error)")
            return nil
        }
    }

    func isPasswordValid(_ password: String) -> Bool {
        // Rule 1: Passwords must be at least nine(9) characters in length
        if password.count < 9 {
            return false
        }

        // Rule 2: Follow at least three(3) rules from below
        var rulesComplied = 0

        // Rule 2.1: English uppercase characters (A to Z)
        if password.range(of: "[A-Z]", options: .regularExpression) != nil {
            rulesComplied += 1
        }

        // Rule 2.2: English lowercase characters (a to z)
        if password.range(of: "[a-z]", options: .regularExpression) != nil {
            rulesComplied += 1
        }

        // Rule 2.3: Numeric number (0 to 9)
        if password.range(of: "[0-9]", options: .regularExpression) != nil {
            rulesComplied += 1
        }

        // Rule 2.4: Non-alphabetic characters (for example, !, $, #, %)
        if password.range(of: "[^a-zA-Z0-9]", options: .regularExpression) != nil {
            rulesComplied += 1
        }

        return rulesComplied >= 3
    }

    func hideMidCharsForEmail(_ value: String) -> String {
       return String(value.enumerated().map { index, char in
          return [value.count - 1, value.count - 2,value.count - 3].contains(index) ? char : "*"
       })
    }
    func getHMACKString(str : String)->String{
       
        return str.hmac(algorithm: .SHA256, key: hmackKey)
    }
    func getekycHMACKString(str : String)->String{
       
        return str.hmac(algorithm: .SHA256, key: ekychmackKey)
    }
    func getHMACKShohozString(str : String)->String{
            return str.hmac(algorithm: .SHA256, key: shohozhmacKey)
    }
    func getRequestReferrenceString()->String{
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let timestamp = String( (0..<20).map{ _ in letters.randomElement()! })
        return timestamp
    }
    func getCSRFToken()->String{
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let csrfToken = String((0..<32).map{ _ in letters.randomElement()! })
        let csrfhmac = self.getekycHMACKString(str: csrfToken)
        let finalcsrftok = "\(csrfhmac)::\(csrfToken)"
        return finalcsrftok
    }
}
func localToUTC(dateStr: String) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "h:mm a"
    dateFormatter.calendar = Calendar.current
    dateFormatter.timeZone = TimeZone.current
    
    if let date = dateFormatter.date(from: dateStr) {
        dateFormatter.timeZone = TimeZone(abbreviation: "BDT")
        dateFormatter.dateFormat = "H:mm:ss"
    
        return dateFormatter.string(from: date)
    }
    return nil
}

extension KeyedDecodingContainer {
    func decodeWrapper<T>(key: K, defaultValue: T) throws -> T
        where T : Decodable {
            return try decodeIfPresent(T.self, forKey: key) ?? defaultValue
    }
    
}
extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}


extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}


class ReusableTableView: NSObject, UITableViewDataSource, UITableViewDelegate
{
    var tableView: UITableView?
    var tableViewData: [String] = ["Profile","Change Password","Transactions Profile","Change OTP Channel","Log Out"]
    var parentVC : UIViewController?
    override init()
    {
        super.init()
        tableView = UITableView(frame: CGRect(x: (UIScreen.main.bounds.width - 200), y: UIApplication.shared.statusBarFrame.size.height +
            (parentVC?.navigationController?.navigationBar.frame.height ?? 0.0), width: 200, height: 300), style: .plain)
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.backgroundColor = UIColor(hexString: "#FDFDFD")
        // Register all of your cells
        //tableView.register(UINib(nibName: "SomeNib", bundle: nil), forCellReuseIdentifier: "example-id")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return UITableView.automaticDimension
    //    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if( !(cell != nil))
        {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        }
        
        cell!.textLabel?.text = tableViewData[indexPath.row]
        cell?.backgroundColor = UIColor(hexString: "#FDFDFD")
        return cell!
    }
    

}




public class Indicator {
    
    public static let sharedInstance = Indicator()
    var blurImg = UIImageView()
    var indicator = UIActivityIndicatorView()
    
    private init()
    {
        blurImg.frame = UIScreen.main.bounds
        blurImg.backgroundColor = UIColor.black
        blurImg.isUserInteractionEnabled = true
        blurImg.alpha = 0.5
        indicator.style = .whiteLarge
        indicator.center = blurImg.center
        indicator.startAnimating()
        indicator.color = UIColor(hexString: "#3c8c53")
    }
    
    func showIndicator(){
        DispatchQueue.main.async( execute: {
            
            UIApplication.shared.keyWindow?.addSubview(self.blurImg)
            UIApplication.shared.keyWindow?.addSubview(self.indicator)
        })
    }
    func hideIndicator(){
        
        DispatchQueue.main.async( execute:
            {
                self.blurImg.removeFromSuperview()
                self.indicator.removeFromSuperview()
        })
    }
}
class AlertController: UIAlertController {
    func hideAlertController() {
        self.dismiss(animated: true, completion: nil)
    }
}


//extension String{
//    func aesEncrypt(key: String) throws -> String {
//
//        var result = ""
//
//        do {
//
//            let key: [UInt8] = Array(key.utf8) as [UInt8]
//
//            let aes = try AES(key: key, blockMode: CBC(iv: key) , padding:.pkcs5) // AES128 .ECB pkcs7
//
//            let encrypted = try aes.encrypt(Array(self.utf8))
//
//            result = encrypted.toBase64()!
//
//
//            print("AES Encryption Result: \(result)")
//
//        } catch {
//            if let data = self.data(using: .utf8) {
//                return data.base64EncodedString()
//            }
//            print("Error: \(error)")
//        }
//        return result
//    }
//    func base64Encoded() -> String? {
//               if let data = self.data(using: .utf8) {
//                   return data.base64EncodedString()
//               }
//               return nil
//           }
//}

enum CryptoAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512

    var HMACAlgorithm: CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:      result = kCCHmacAlgMD5
        case .SHA1:     result = kCCHmacAlgSHA1
        case .SHA224:   result = kCCHmacAlgSHA224
        case .SHA256:   result = kCCHmacAlgSHA256
        case .SHA384:   result = kCCHmacAlgSHA384
        case .SHA512:   result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }

    var digestLength: Int {
        var result: Int32 = 0
        switch self {
        case .MD5:      result = CC_MD5_DIGEST_LENGTH
        case .SHA1:     result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:   result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:   result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:   result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:   result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
    
    // Function to convert a hex string to Data
    func hexStringToData(_ hexString: String) -> Data {
        var data = Data()
        var hex = hexString
        if hex.count % 2 != 0 { hex = "0" + hex } // Ensure even number of characters
        for i in stride(from: 0, to: hex.count, by: 2) {
            let subStr = hex[hex.index(hex.startIndex, offsetBy: i)..<hex.index(hex.startIndex, offsetBy: i+2)]
            let byte = UInt8(subStr, radix: 16)!
            data.append(byte)
        }
        return data
    }

}

extension String {

    func hmac(algorithm: CryptoAlgorithm, key: String) -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = Int(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = algorithm.digestLength
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        let keyStr = key.cString(using: String.Encoding.utf8)
        let keyLen = Int(key.lengthOfBytes(using: String.Encoding.utf8))

        CCHmac(algorithm.HMACAlgorithm, keyStr!, keyLen, str!, strLen, result)

        let digest = stringFromResult(result: result, length: digestLen)

        result.deallocate()

        return digest
    }

    private func stringFromResult(result: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String {
        let hash = NSMutableString()
        for i in 0..<length {
            hash.appendFormat("%02x", result[i])
        }
        return String(hash).lowercased()
    }
}
public extension UIDevice {

    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                       return "iPod touch (5th generation)"
            case "iPod7,1":                                       return "iPod touch (6th generation)"
            case "iPod9,1":                                       return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":           return "iPhone 4"
            case "iPhone4,1":                                     return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                        return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                        return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                        return "iPhone 5s"
            case "iPhone7,2":                                     return "iPhone 6"
            case "iPhone7,1":                                     return "iPhone 6 Plus"
            case "iPhone8,1":                                     return "iPhone 6s"
            case "iPhone8,2":                                     return "iPhone 6s Plus"
            case "iPhone8,4":                                     return "iPhone SE"
            case "iPhone9,1", "iPhone9,3":                        return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                        return "iPhone 7 Plus"
            case "iPhone10,1", "iPhone10,4":                      return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                      return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                      return "iPhone X"
            case "iPhone11,2":                                    return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                      return "iPhone XS Max"
            case "iPhone11,8":                                    return "iPhone XR"
            case "iPhone12,1":                                    return "iPhone 11"
            case "iPhone12,3":                                    return "iPhone 11 Pro"
            case "iPhone12,5":                                    return "iPhone 11 Pro Max"
            case "iPhone12,8":                                    return "iPhone SE (2nd generation)"
            case "iPhone13,1":                                    return "iPhone 12 mini"
            case "iPhone13,2":                                    return "iPhone 12"
            case "iPhone13,3":                                    return "iPhone 12 Pro"
            case "iPhone13,4":                                    return "iPhone 12 Pro Max"
            case "iPhone14,4":                                    return "iPhone 13 mini"
            case "iPhone14,5":                                    return "iPhone 13"
            case "iPhone14,2":                                    return "iPhone 13 Pro"
            case "iPhone14,3":                                    return "iPhone 13 Pro Max"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":      return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":                 return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":                 return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                          return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                            return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                          return "iPad (7th generation)"
            case "iPad11,6", "iPad11,7":                          return "iPad (8th generation)"
            case "iPad12,1", "iPad12,2":                          return "iPad (9th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":                 return "iPad Air"
            case "iPad5,3", "iPad5,4":                            return "iPad Air 2"
            case "iPad11,3", "iPad11,4":                          return "iPad Air (3rd generation)"
            case "iPad13,1", "iPad13,2":                          return "iPad Air (4th generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":                 return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":                 return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":                 return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                            return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                          return "iPad mini (5th generation)"
            case "iPad14,1", "iPad14,2":                          return "iPad mini (6th generation)"
            case "iPad6,3", "iPad6,4":                            return "iPad Pro (9.7-inch)"
            case "iPad7,3", "iPad7,4":                            return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":      return "iPad Pro (11-inch) (1st generation)"
            case "iPad8,9", "iPad8,10":                           return "iPad Pro (11-inch) (2nd generation)"
            case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7":  return "iPad Pro (11-inch) (3rd generation)"
            case "iPad6,7", "iPad6,8":                            return "iPad Pro (12.9-inch) (1st generation)"
            case "iPad7,1", "iPad7,2":                            return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":      return "iPad Pro (12.9-inch) (3rd generation)"
            case "iPad8,11", "iPad8,12":                          return "iPad Pro (12.9-inch) (4th generation)"
            case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11":return "iPad Pro (12.9-inch) (5th generation)"
            case "AppleTV5,3":                                    return "Apple TV"
            case "AppleTV6,2":                                    return "Apple TV 4K"
            case "AudioAccessory1,1":                             return "HomePod"
            case "AudioAccessory5,1":                             return "HomePod mini"
            case "i386", "x86_64", "arm64":                                return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                              return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }

        return mapToDevice(identifier: identifier)
    }()

}
extension UISegmentedControl{
    func removeBorder(){
        let backgroundImage = UIImage.getColoredRectImageWith(color: UIColor.white.cgColor, andSize: self.bounds.size)
        self.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .selected, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .highlighted, barMetrics: .default)

        let deviderImage = UIImage.getColoredRectImageWith(color: UIColor.white.cgColor, andSize: CGSize(width: 1.0, height: self.bounds.size.height))
        self.setDividerImage(deviderImage, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(hexString: "#3c8c53")], for: .selected)
    }

    func addUnderlineForSelectedSegment(){
        removeBorder()
        let underlineWidth: CGFloat = self.bounds.size.width / CGFloat(self.numberOfSegments)
        let underlineHeight: CGFloat = 2.0
        let underlineXPosition = CGFloat(selectedSegmentIndex * Int(underlineWidth))
        let underLineYPosition = self.bounds.size.height - 1.0
        let underlineFrame = CGRect(x: underlineXPosition, y: underLineYPosition, width: underlineWidth, height: underlineHeight)
        let underline = UIView(frame: underlineFrame)
        underline.backgroundColor = UIColor(red: 67/255, green: 129/255, blue: 244/255, alpha: 1.0)
        underline.tag = 1
        self.addSubview(underline)
    }

    func changeUnderlinePosition(){
        guard let underline = self.viewWithTag(1) else {return}
        let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)
        UIView.animate(withDuration: 0.1, animations: {
            underline.frame.origin.x = underlineFinalXPosition
        })
    }
    
    
   

}

extension UIImage{

    class func getColoredRectImageWith(color: CGColor, andSize size: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let graphicsContext = UIGraphicsGetCurrentContext()
        graphicsContext?.setFillColor(color)
        let rectangle = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        graphicsContext?.fill(rectangle)
        let rectangleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rectangleImage!
    }
}
