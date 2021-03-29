//
//  Ads.swift
//  List View 2
//
//  Created by Junaid Mukadam on 19/10/19.
//  Copyright © 2019 Junaid Mukadam. All rights reserved.
//

import Foundation
import AppTrackingTransparency
import AdSupport
import GoogleMobileAds
import UIKit
import StoreKit

//let testIntrest = "ca-app-pub-3940256099942544/1033173712"      //Test
let testIntrest = "ca-app-pub-2710347124980493/4230520325"    //Mine

//let videoads = "ca-app-pub-3940256099942544/5224354917" // Test
let videoads = "ca-app-pub-2710347124980493/2912232437" // Main //


//first Add
//<key>NSUserTrackingUsageDescription</key>
//<string>This identifier will be used to deliver personalized ads to you.</string>

private var interstitial: GADInterstitialAd?

func LoadIntrest(Myself:UIViewController) {
    let request = GADRequest()
    GADInterstitialAd.load(withAdUnitID:testIntrest,
                           request: request,
                           completionHandler: { [Myself] ad, error in
                            if let error = error {
                                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                                return
                            }
                            interstitial = ad
                           })
}



func showIntrest(Myself:UIViewController,Wait:Double) {
    DispatchQueue.main.asyncAfter(deadline: .now() + Wait) {
        if interstitial != nil {
            interstitial?.present(fromRootViewController: Myself)
        } else {
            print("Ad wasn't ready")
        }
    }
}



func requestToRate() {
    SKStoreReviewController.requestReview()
}


func requestPermission() {
    if #available(iOS 14, *) {
        ATTrackingManager.requestTrackingAuthorization(completionHandler: { (status) in
            switch status {
            case .authorized:
                print(ASIdentifierManager.shared().advertisingIdentifier)
            case .denied:
                print(ASIdentifierManager.shared().advertisingIdentifier)
                print("Denied")
                break
            case .notDetermined:
                print("Not Determined")
            case .restricted:
                print("Restricted")
            @unknown default:
                print("Unknown")
            }
        })
    }
}

