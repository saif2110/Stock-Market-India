//
//  AppDelegate.swift
//  Stock Market India
//
//  Created by Junaid Mukadam on 06/12/20.
//

import UIKit
import Alamofire
import SwiftyJSON
import NilTutorial
import GoogleSignIn
import GoogleMobileAds
import DropDown
import InAppPurchase

var numberOFStocks = 32

@main
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInDelegate {
    var window:UIWindow?
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        let userId = user.userID ?? "000"
        let fullName = user.profile.name ?? "null"
        let email = user.profile.email ?? "null"
        let profileID = user.profile.imageURL(withDimension: 300)?.absoluteString
        
        let Parameters:Parameters = [
            "id":userId,
            "Name":fullName ,
            "Email":email ,
            "Profile_URL":profileID ?? ""
        ]
        
        postWithParameter(Url: "Profilepost.php", parameters: Parameters) { (json, err) in
            
            if json["code"].string ?? "null" == "007" {
                UserDefaults.standard.setisLogin(value: true)
                UserDefaults.standard.setid(value: userId)
                UserDefaults.standard.setUsername(value: fullName)
                UserDefaults.standard.setUserEmail(value: email)
                UserDefaults.standard.setUserUserProfilePic(value: profileID ?? "")
                NotificationCenter.default.post(name: NSNotification.Name("setDetails"), object: nil)
                
            }else if json["message"].string?.contains("Duplicate entry") ?? false {
                
                postWithParameter(Url: "getProfileData.php", parameters: ["id":userId]) { (json, err) in
                    
                    print(json)
                    
                    if json["code"].string ?? "null" == "007" {
                        
                        UserDefaults.standard.setisLogin(value: true)
                        UserDefaults.standard.setid(value: userId)
                        UserDefaults.standard.setUsername(value: json["Name"].string ?? "Null")
                        UserDefaults.standard.setUserEmail(value: json["Email"].string ?? "Null")
                        UserDefaults.standard.setUserUserProfilePic(value: json["Profile_URL"].string ?? "Null")
                        UserDefaults.standard.setFullAccess(value: json["FullAccess"].string ?? "false")
                        NotificationCenter.default.post(name: NSNotification.Name("setDetails"), object: nil)
                        
                    }
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DropDown.startListeningToKeyboard()
        
        UserDefaults.standard.setnumberOftimeAppOpen(value:
                                                        UserDefaults.standard.getnumberOftimeAppOpen()+1)
        
        GIDSignIn.sharedInstance().clientID = "569740869698-n9dn4t2gjqvlcvbva27juj3ik5h4rhoq.apps.googleusercontent.com"
        
        GIDSignIn.sharedInstance().delegate = self
        
        if !UserDefaults.standard.isFirstTimeOpen() {
            
            let tutorialVC = NilTutorialViewController(imagesSet: [#imageLiteral(resourceName: "tutorial1"),#imageLiteral(resourceName: "tutorial2"),#imageLiteral(resourceName: "tutorial3")]) {
                // Add action afer skip button pressed here
                UserDefaults.standard.setisFirstTimeOpen(value: true)
                let MainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = MainStoryboard.instantiateViewController(withIdentifier: "RootNavigationController") as? UINavigationController
                self.window?.rootViewController = controller
                
            }
            
            tutorialVC.setAutoScrollTime(seconds: 2)
            tutorialVC.enableAutoScroll()
            
            tutorialVC.hideSkipButton()
            tutorialVC.setSkipButtonTextColor(textColor: UIColor.red)
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                tutorialVC.showSkipButton()
            }
            self.window?.rootViewController = tutorialVC
            
        }else{
            
            UserDefaults.standard.setisFirstTimeOpen(value: true)
            let MainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = MainStoryboard.instantiateViewController(withIdentifier: "RootNavigationController") as? UINavigationController
            self.window?.rootViewController = controller
            
        }
        
        window?.tintColor = .systemRed
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers =  ["71672e5a891db378b63d88dd080cc4ab"]
        
        let iap = InAppPurchase.default
        iap.addTransactionObserver(fallbackHandler: {_ in
            // Handle the result of payment added by Store
            // See also `InAppPurchase#purchase`
            print("what the hell is this")
        })
        
        
        if UserDefaults.standard.isProMember() {
            numberOFStocks = 40
        }
        
        
        
        return true
    }
}

func LikeAlgoritham(Name:String,Date:String) -> String {
    
    let Likes = AlphateNumberforLike(alphabate: String(Name.first ?? "R")) + AlphateNumberforLike(alphabate: String(Name.last ?? "s")) + Int(String(Date.first!))!
    return String(Int(Likes))
    
}

func DisLikeAlgoritham(Name:String,Date:String) -> String {
    let Likes = AlphateNumberforDisLike(alphabate: String(Name.first ?? "R")) + AlphateNumberforDisLike(alphabate: String(Name.last ?? "R")) + Int(String(Date.first!))!
    return String(Int(Likes))
    
}

func AlphateNumberforLike(alphabate:String) -> Int {
    
    switch alphabate.lowercased() {
    case "a":
        return 6
    case "b":
        return 8
    case "c":
        return 10
    case "d":
        return 13
    case "e":
        return 10
    case "f":
        return 8
    case "g":
        return 6
    case "h":
        return 11
    case "i":
        return 5
    case "j":
        return 5
    case "k":
        return 10
    case "l":
        return 10
    case "m":
        return 10
    case "n":
        return 7
    case "o":
        return 5
    case "p":
        return 8
    case "q":
        return 10
    case "r":
        return 9
    case "s":
        return 11
    case "t":
        return 6
    case "u":
        return 7
    case "v":
        return 9
    case "w":
        return 11
    case "x":
        return 8
    case "y":
        return 12
    case "z":
        return 8
    default:
        return 9
    }
}

func AlphateNumberforDisLike(alphabate:String) -> Int {
    
    switch alphabate.lowercased() {
    case "a":
        return 6
    case "b":
        return 8
    case "c":
        return 7
    case "d":
        return 5
    case "e":
        return 6
    case "f":
        return 11
    case "g":
        return 8
    case "h":
        return 9
    case "i":
        return 8
    case "j":
        return 8
    case "k":
        return 8
    case "l":
        return 7
    case "m":
        return 6
    case "n":
        return 7
    case "o":
        return 12
    case "p":
        return 10
    case "q":
        return 7
    case "r":
        return 8
    case "s":
        return 7
    case "t":
        return 6
    case "u":
        return 7
    case "v":
        return 6
    case "w":
        return 11
    case "x":
        return 8
    case "y":
        return 6
    case "z":
        return 8
    default:
        return 9
    }
}

func createEmailUrl(to: String, subject: String, body: String) -> URL? {
    let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    
    let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
    let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
    let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
    let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
    let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
    
    if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
        return gmailUrl
    } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
        return outlookUrl
    } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
        return yahooMail
    } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
        return sparkUrl
    }
    
    return defaultUrl
}
