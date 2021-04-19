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

let videoads = "ca-app-pub-2710347124980493/2912232437"

//first Add
//<key>NSUserTrackingUsageDescription</key>
//<string>This identifier will be used to deliver personalized ads to you.</string>


func showIntrest(Myself:UIViewController) {
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
                                        if ad != nil {
                                            ad?.present(fromRootViewController: Myself)
                                        } else {
                                            print("Ad wasn't ready")
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
                                    if ad != nil {
                                        ad?.present(fromRootViewController: Myself)
                                    } else {
                                        print("Ad wasn't ready")
                                    }
                                    
                                   })
            
        }
    }
}

func requestToRate() {
    SKStoreReviewController.requestReview()
}

var indicator = UIActivityIndicatorView()

func startIndicator(selfo:UIViewController) {
    indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    indicator.color = .systemRed
    indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
    indicator.center = selfo.view.center
    selfo.view.addSubview(indicator)
    selfo.view.bringSubviewToFront(indicator)
    indicator.startAnimating()
}

func stopIndicator() {
    indicator.stopAnimating()
}
