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
import Purchases

var numberOFStocks = 22

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
        
        window?.tintColor = .systemRed
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        DropDown.startListeningToKeyboard()
        
        UserDefaults.standard.setnumberOftimeAppOpen(value:
                                                        UserDefaults.standard.getnumberOftimeAppOpen()+1)
        
        
        Purchases.debugLogsEnabled = false
        Purchases.configure(withAPIKey: "lkepAliEKBiKaKgjmMWSwwWUeGXlEvSI")
        
        
        GIDSignIn.sharedInstance().clientID = "569740869698-n9dn4t2gjqvlcvbva27juj3ik5h4rhoq.apps.googleusercontent.com"
        
        GIDSignIn.sharedInstance().delegate = self
        
        isSubsActive()
        
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
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers =  ["71672e5a891db378b63d88dd080cc4ab"]
        
        let iap = InAppPurchase.default
        iap.addTransactionObserver(fallbackHandler: {_ in
            // Handle the result of payment added by Store
            // See also `InAppPurchase#purchase`
            print("what the hell is this")
        })
        
        
        if UserDefaults.standard.isProMember() {
            numberOFStocks = 30
        }
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
            if error != nil {
                print("Request authorization failed!")
            } else {
                print("Request authorization succeeded!")
                self.notification()
            }
        }
        
        return true
    }
    
    func notification() {
        
        if nameofDay() != "Friday" && nameofDay() != "Saturday" {
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = "New Stock Tips Available"
            notificationContent.body = "Have two spare minutes ? Click to see today's latest tips."
            notificationContent.sound = .default
            
            var datComp = DateComponents()
            datComp.hour = 12
            datComp.minute = 30
            let trigger = UNCalendarNotificationTrigger(dateMatching: datComp, repeats: true)
            let request = UNNotificationRequest(identifier: "ID", content: notificationContent, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error : Error?) in
                if let theError = error {
                    print(theError.localizedDescription)
                }
            }
        }
    }
    
    //||!(purchaserInfo?.entitlements.active.isEmpty ?? false)
    
    func isSubsActive(){
        
        Purchases.shared.purchaserInfo { (purchaserInfo, error) in
            
            if purchaserInfo?.entitlements.all[IPA.OneMonthPro.rawValue]?.isActive == true ||  purchaserInfo?.entitlements.all[IPA.OneYearPro.rawValue]?.isActive == true || UserDefaults.standard.islifeTimePro() {
                
                UserDefaults.standard.setisProMember(value: true)
                
            }else{
                
                UserDefaults.standard.setisProMember(value: false)

            }
        }
    }
    
}





struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
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
        return 10
    case "b":
        return 12
    case "c":
        return 13
    case "d":
        return 17
    case "e":
        return 14
    case "f":
        return 12
    case "g":
        return 9
    case "h":
        return 15
    case "i":
        return 9
    case "j":
        return 9
    case "k":
        return 14
    case "l":
        return 14
    case "m":
        return 14
    case "n":
        return 11
    case "o":
        return 9
    case "p":
        return 12
    case "q":
        return 14
    case "r":
        return 12
    case "s":
        return 15
    case "t":
        return 10
    case "u":
        return 11
    case "v":
        return 13
    case "w":
        return 15
    case "x":
        return 12
    case "y":
        return 15
    case "z":
        return 12
    default:
        return 11
    }
}

func AlphateNumberforDisLike(alphabate:String) -> Int {
    
    switch alphabate.lowercased() {
    case "a":
        return 8
    case "b":
        return 10
    case "c":
        return 9
    case "d":
        return 7
    case "e":
        return 8
    case "f":
        return 13
    case "g":
        return 10
    case "h":
        return 11
    case "i":
        return 10
    case "j":
        return 10
    case "k":
        return 10
    case "l":
        return 9
    case "m":
        return 8
    case "n":
        return 9
    case "o":
        return 14
    case "p":
        return 12
    case "q":
        return 9
    case "r":
        return 10
    case "s":
        return 9
    case "t":
        return 8
    case "u":
        return 9
    case "v":
        return 8
    case "w":
        return 13
    case "x":
        return 10
    case "y":
        return 8
    case "z":
        return 10
    default:
        return 11
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

extension UIView {
    
    func shadow()  {
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.45
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 5
    }
    
    func shadow2()  {
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 5
    }
}


extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .systemRed
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 16.5)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}


func nameofDay() -> String{
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    let dayInWeek = dateFormatter.string(from: date)
    return dayInWeek
}

