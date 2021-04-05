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

let videoads = "ca-app-pub-2710347124980493/2912232437" // Main //

//first Add
//<key>NSUserTrackingUsageDescription</key>
//<string>This identifier will be used to deliver personalized ads to you.</string>

private var interstitial: GADInterstitialAd?

func showIntrest(Myself:UIViewController,Wait:Double) {
    if !UserDefaults.standard.isProMember() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { (status) in
                let request = GADRequest()
                GADInterstitialAd.load(withAdUnitID:"ca-app-pub-2710347124980493/4230520325",
                                       request: request,
                                       completionHandler: { [Myself] ad, error in
                                        if let error = error {
                                            print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                                            return
                                        }
                                        interstitial = ad
                                        DispatchQueue.main.asyncAfter(deadline: .now() + Wait) {
                                            
                                            if interstitial != nil {
                                                interstitial?.present(fromRootViewController: Myself)
                                            } else {
                                                print("Ad wasn't ready")
                                            }
                                        }
                                       })
            })
        }else{
            let request = GADRequest()
            GADInterstitialAd.load(withAdUnitID:"ca-app-pub-2710347124980493/4230520325",
                                   request: request,
                                   completionHandler: { [Myself] ad, error in
                                    if let error = error {
                                        print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                                        return
                                    }
                                    interstitial = ad
                                    DispatchQueue.main.asyncAfter(deadline: .now() + Wait) {
                                        if interstitial != nil {
                                            interstitial?.present(fromRootViewController: Myself)
                                        } else {
                                            print("Ad wasn't ready")
                                        }
                                    }
                                   })
            
        }
    }
}



func requestToRate() {
    SKStoreReviewController.requestReview()
}
