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
    
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var imageLotti: UIImageView!
    
    
    override func viewDidAppear(_ animated: Bool) {
        jumpButtonAnimation(sender: buyButton)
        
        startIndicator(selfo: self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            stopIndicator()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        let iap = InAppPurchase.default
        iap.fetchProduct(productIdentifiers: ["StockMarketPro"], handler: { (result) in
            switch result {
            case .success(let products):
                self.buyButton.setTitle("PAY " + (products[0].priceLocale.currencySymbol ?? "$") + String(products[0].price.description + " (Lifetime)"), for: .normal)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    @IBAction func restore(_ sender: Any) {
        let iap = InAppPurchase.default
        iap.restore(handler: { (result) in
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
    
    
    func jumpButtonAnimation(sender: UIButton) {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = NSNumber(value: 1.1)
        animation.duration = 0.24
        animation.repeatCount = 100000
        animation.autoreverses = true
        sender.layer.add(animation, forKey: nil)
    }
    
    
    @IBAction func buyPro(_ sender: Any) {
        startIndicator(selfo: self)
        let iap = InAppPurchase.default
        iap.purchase(productIdentifier: "StockMarketPro", handler: { (result) in
            stopIndicator()
            switch result {
            case .success( _):
                self.PerchesedComplte()
            case .failure( _):
                print("error")
            }
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if UserDefaults.standard.isProMember(){
            requestToRate()
        }
    }
    
    func PerchesedComplte(){
        UserDefaults.standard.setisProMember(value: true)
        self.present(myAlt(titel:"Congratulations !",message:"You are a pro member now. Enjoy seamless experience with all features unlock."), animated: true, completion: nil)
    }
    
}
