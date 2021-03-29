//
//  SettingMain.swift
//  Stock Market India
//
//  Created by Junaid Mukadam on 12/12/20.
//

import UIKit
import GoogleSignIn
import AuthenticationServices
import Alamofire
import Kingfisher
import SwiftyJSON

class SettingMain: UITableViewCell,ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding {
    
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.window!
    }
    
    func setDetails(){
        self.Name.text = UserDefaults.standard.getUsername()
        self.email.text = UserDefaults.standard.getUserEmail()
        if UserDefaults.standard.getUserProfilePic().contains("https"){
            ProfilePhoto.kf.setImage(with: URL(string: UserDefaults.standard.getUserProfilePic()))
        }
        
        self.SignInView.isHidden = true
    }
    
    @IBOutlet weak var LoginLabel: UILabel!
    @IBOutlet weak var SignInView: UIView!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var Name: UILabel!
    
    @IBOutlet weak var postStockTip: UIButton!
    @IBOutlet weak var ProfilePhoto: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setDetailsfucn),
                                               name: NSNotification.Name("setDetails"),
                                               object: nil)
        
        if UserDefaults.standard.isLogin(){
            setDetails()
            SignInView.isHidden = true
            
        }
        
        ProfilePhoto.layer.cornerRadius = ProfilePhoto.bounds.width/2
        ProfilePhoto.contentMode = .scaleAspectFill
        ProfilePhoto.clipsToBounds = true
        ProfilePhoto.translatesAutoresizingMaskIntoConstraints = false
        ProfilePhoto.layer.masksToBounds = true
        ProfilePhoto.layer.borderColor =
            #colorLiteral(red: 0.8775149376, green: 0.8862032043, blue: 0.8862032043, alpha: 1)
        ProfilePhoto.layer.borderWidth = 1
        postStockTip.layer.cornerRadius = 5
        
        
        let googleButton = UIButton()
        googleButton.setTitle("Sign in with Google", for: .normal)
        googleButton.setImage(#imageLiteral(resourceName: "google.png"), for: .normal)
        googleButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 12)
        googleButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        googleButton.setTitleColor(UIColor.white, for: .normal)
        googleButton.layer.cornerRadius = 12
        googleButton.layer.borderWidth = 0
        googleButton.backgroundColor = UIColor.black
        googleButton.addTarget(self, action: #selector(googlePressed), for: .touchUpInside)
        
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            GIDSignIn.sharedInstance().presentingViewController = topController
        }
        
        
        
        
        let appleLogin = UIButton()
        appleLogin.layer.cornerRadius = 12
        appleLogin.layer.borderWidth = 0
        appleLogin.backgroundColor = UIColor.black
        appleLogin.layer.borderColor = UIColor.black.cgColor
        appleLogin.setTitle("Sign in with Apple", for: .normal)
        appleLogin.setTitleColor(UIColor.white, for: .normal)
        appleLogin.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        appleLogin.setImage(#imageLiteral(resourceName: "Apple").withTintColor(.white), for: .normal)
        
        appleLogin.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 12)
        appleLogin.addTarget(self, action: #selector(actionHandleAppleSignin), for: .touchUpInside)
        self.SignInView.addSubview(appleLogin)
        // Setup Layout Constraints to be in the center of the screen
        appleLogin.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            appleLogin.topAnchor.constraint(equalTo: self.LoginLabel.bottomAnchor, constant: 10),
            appleLogin.leadingAnchor.constraint(equalTo: self.SignInView.leadingAnchor, constant: 20),
            appleLogin.trailingAnchor.constraint(equalTo: self.SignInView.trailingAnchor, constant: -20),
            appleLogin.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        
        self.SignInView.addSubview(googleButton)
        googleButton.translatesAutoresizingMaskIntoConstraints  = false
        NSLayoutConstraint.activate([
            googleButton.topAnchor.constraint(equalTo: appleLogin.bottomAnchor, constant: 15),
            googleButton.leadingAnchor.constraint(equalTo: self.SignInView.leadingAnchor, constant: 20),
            googleButton.trailingAnchor.constraint(equalTo: self.SignInView.trailingAnchor, constant: -20),
            googleButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
    }
    
    @objc func setDetailsfucn(){
        setDetails()
    }
    
    @objc func actionHandleAppleSignin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @objc func googlePressed(){
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            let userIdentifier = appleIDCredential.user
            let fullName:String = (appleIDCredential.fullName?.givenName ?? "givenName") + " " +  (appleIDCredential.fullName?.familyName  ?? "familyName")
            let email:String = appleIDCredential.email ?? "null"
            
            let Parameters:Parameters = [
                "id":userIdentifier,
                "Name":fullName ,
                "Email":email ,
                "Profile_URL":"null",
            ]
            
            postWithParameter(Url: "Profilepost.php", parameters: Parameters) { (json, err) in
                
                if json["code"].string ?? "null" == "007" {
                    UserDefaults.standard.setisLogin(value: true)
                    UserDefaults.standard.setid(value: userIdentifier)
                    UserDefaults.standard.setUsername(value: fullName)
                    UserDefaults.standard.setUserEmail(value: email)
                    UserDefaults.standard.setUserUserProfilePic(value: "null")
                    
                    self.setDetails()
                    
                }else if json["message"].string?.contains("Duplicate entry") ?? false {
                    
                    postWithParameter(Url: "getProfileData.php", parameters: ["id":userIdentifier]) { (json, err) in
                        
                        
                        if json["code"].string ?? "null" == "007" {
                            
                            UserDefaults.standard.setisLogin(value: true)
                            UserDefaults.standard.setid(value: userIdentifier)
                            UserDefaults.standard.setUsername(value: json["Name"].string ?? "Null")
                            UserDefaults.standard.setUserEmail(value: json["Email"].string ?? "Null")
                            UserDefaults.standard.setUserUserProfilePic(value: "null")
                            self.setDetails()
                            
                        }
                    }
                }
            }
        default:
            break
        }
    }
    
    
}
