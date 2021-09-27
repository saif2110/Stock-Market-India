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
    var sysmbol = ""
    var myprice = 0.0
    
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var imageLotti: UIImageView!
    
    let IAPid = "StockMarketPro"
    
    override func viewDidAppear(_ animated: Bool) {
        jumpButtonAnimation(sender: buyButton)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let LottiV = AnimationView()
        LottiV.frame = self.imageLotti.bounds
        LottiV.backgroundColor = .clear
        LottiV.animation = Animation.named("pro")
        LottiV.contentMode = .scaleAspectFit
        LottiV.loopMode = .repeat(0)
        LottiV.play()
        
        DispatchQueue.main.async {
            self.imageLotti.addSubview(LottiV)
        }
        
        let iap = InAppPurchase.default
        iap.fetchProduct(productIdentifiers: [IAPid], handler: { (result) in
            switch result {
            case .success(let products):
                self.buyButton.setTitle((products[0].priceLocale.currencySymbol ?? "$") + String(products[0].price.description + " (Lifetime)"), for: .normal)
            case .failure(let error):
                print(error)
            }
        })
        
        
    }
    
    
    func jumpButtonAnimation(sender: UIButton) {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = NSNumber(value: 1.1)
        animation.duration = 0.24
        animation.repeatCount = 100000
        animation.autoreverses = true
        sender.layer.add(animation, forKey: nil)
    }
    
    
    @IBAction func restore(_ sender: Any) {
        let iap = InAppPurchase.default
        iap.restore(handler: { (result) in
            print(result)
            switch result {
            case .success(let products):
                if !products.isEmpty{
                    self.PerchesedComplte()
                }
            case .failure(let error):
                print("error")
                print(error)
            }
        })
    }
    
    @IBAction func buyPro(_ sender: Any) {
        startIndicator(selfo: self)
        
        let iap = InAppPurchase.default
        iap.purchase(productIdentifier: IAPid, handler: { (result) in
            stopIndicator()
            switch result {
            case .success( _):
                self.PerchesedComplte()
            case .failure( _):
                self.present(myAlt(titel:"Failure",message:"Something went wrong. Please try again"), animated: true, completion: nil)
            }
        })
        
    }
    
    func PerchesedComplte(){
        UserDefaults.standard.setisProMember(value: true)
        self.present(myAlt(titel:"Congratulations !",message:"You are a pro member now. Enjoy seamless experience with all features unlock."), animated: true, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if UserDefaults.standard.getnumberOftimeAppOpen() > 1 {
            requestToRate()
        }
    }
    
}


