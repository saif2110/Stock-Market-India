//
//  UserDef.swift
//  EVV
//
//  Created by Abhisar Bhatnagar on 20/11/19.
//  Copyright © 2019 Saif Mukadam. All rights reserved.
//

import Foundation
import SwiftyJSON


enum UserDefaultsKeys : String {
    case isLogin
    case isFirstTimeOpen
    case LikeDisLikeTime
    case numberofTimesconnected
    case isRated
    case IP1
    case IP2
    case FullAccess
    case numberOftimeAppOpen
    case isProMember
    case islifeTimePro
    
    
    
    case Useremail
    case Username
    case UserProfilePic
    case id
}



extension UserDefaults{
    
    func setisFirstTimeOpen(value: Bool){
        set(value,forKey: UserDefaultsKeys.isFirstTimeOpen.rawValue)
    }
    
    func isFirstTimeOpen() -> Bool{
        return bool(forKey: UserDefaultsKeys.isFirstTimeOpen.rawValue)
    }
    
    func setisProMember(value: Bool){
        set(value,forKey: UserDefaultsKeys.isProMember.rawValue)
    }
    
    func isProMember() -> Bool{
        return bool(forKey: UserDefaultsKeys.isProMember.rawValue)
    }
    
    func setislifeTimePro(value: Bool){
        set(value,forKey: UserDefaultsKeys.islifeTimePro.rawValue)
    }
    
    func islifeTimePro() -> Bool{
        return bool(forKey: UserDefaultsKeys.islifeTimePro.rawValue)
    }
    
    func setnumberOftimeAppOpen(value: Double){
        set(value,forKey: UserDefaultsKeys.numberOftimeAppOpen.rawValue)
    }
    
    func getnumberOftimeAppOpen() -> Double{
        return double(forKey: UserDefaultsKeys.numberOftimeAppOpen.rawValue)
    }
    
    func setLikeDisLikeTime(value: Double){
        set(value,forKey: UserDefaultsKeys.LikeDisLikeTime.rawValue)
    }
    
    func getLikeDisLikeTime() -> Double{
        return double(forKey: UserDefaultsKeys.LikeDisLikeTime.rawValue)
    }
    
    
    func setisLogin(value: Bool){
        set(value,forKey: UserDefaultsKeys.isLogin.rawValue)
    }
    
    func isLogin() -> Bool{
        return bool(forKey: UserDefaultsKeys.isLogin.rawValue)
    }
    
    
    func setid(value: String){
        set(value, forKey: UserDefaultsKeys.id.rawValue)
    }
    func getid() -> String{
        return string(forKey: UserDefaultsKeys.id.rawValue) ?? "123"
    }
    
    func setUserEmail(value: String){
        set(value, forKey: UserDefaultsKeys.Useremail.rawValue)
    }
    func getUserEmail() -> String{
        return string(forKey: UserDefaultsKeys.Useremail.rawValue) ?? "123"
    }
    
    func setFullAccess(value: String){
        set(value, forKey: UserDefaultsKeys.FullAccess.rawValue)
    }
    
    func getFullAccess() -> String{
        return string(forKey: UserDefaultsKeys.FullAccess.rawValue) ?? "123"
    }
    
    func setUsername(value: String){
        set(value, forKey: UserDefaultsKeys.Username.rawValue)
    }
    func getUsername() -> String{
        return string(forKey: UserDefaultsKeys.Username.rawValue) ?? "123"
    }
    
    func setUserUserProfilePic(value: String){
        set(value, forKey: UserDefaultsKeys.UserProfilePic.rawValue)
    }
    func getUserProfilePic() -> String{
        return string(forKey: UserDefaultsKeys.UserProfilePic.rawValue) ?? "null"
    }
    
}


func saveJSON(json: JSON, key:String){
    if let jsonString = json.rawString() {
        UserDefaults.standard.setValue(jsonString, forKey: key)
    }
}

func getJSON(_ key: String)-> JSON? {
    var p = ""
    if let result = UserDefaults.standard.string(forKey: key) {
        p = result
    }
    if p != "" {
        if let json = p.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            do {
                return try JSON(data: json)
            } catch {
                return nil
            }
        } else {
            return nil
        }
    } else {
        return nil
    }
}
