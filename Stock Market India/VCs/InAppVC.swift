//
//  InAppVC.swift
//  Stock Market India
//
//  Created by Junaid Mukadam on 05/04/21.
//

import UIKit
import Lottie
import InAppPurchase
import StoreKit

class InAppVC: UIViewController {
    
    @IBOutlet weak var imageLotti: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let iap = InAppPurchase.default
        iap.addTransactionObserver(fallbackHandler: {_ in
            // Handle the result of payment added by Store
            // See also `InAppPurchase#purchase`
            print("what the hell is this")
        })
        
        let LottiV = AnimationView()
        LottiV.frame = self.imageLotti.bounds
        LottiV.backgroundColor = .white
        LottiV.animation = Animation.named("pro")
        LottiV.contentMode = .scaleAspectFill
        LottiV.loopMode = .repeat(10000000)
        LottiV.play()
        DispatchQueue.main.async {
            self.imageLotti.addSubview(LottiV)
        }
    }
    
    @IBAction func restore(_ sender: Any) {
        let iap = InAppPurchase.default
        iap.restore(handler: { (result) in
            print(result)
            switch result {
            case .success( _):
                self.PerchesedComplte()
            case .failure(let error):
                print("error")
                print(error)
            }
        })
    }
    
    @IBAction func buyPro(_ sender: Any) {
        let iap = InAppPurchase.default
        iap.purchase(productIdentifier: "StockMarketPro", handler: { (result) in
            print(result)
            switch result {
            case .success( _):
                self.PerchesedComplte()
            case .failure( _):
                print("error")
            }
        })
    }
    
    func PerchesedComplte(){
        UserDefaults.standard.setisProMember(value: true)
        self.present(myAlt(titel:"Congratulations !",message:"You are a pro member now. Enjoy seamless experience without the Ads."), animated: true, completion: nil)
    }
    
}
