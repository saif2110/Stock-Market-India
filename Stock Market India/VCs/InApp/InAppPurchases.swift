//
//  InAppPurchases.swift
//  Blood Oxygen Level App
//
//  Created by Junaid Mukadam on 19/06/21.
//

import UIKit
import Purchases
import InAppPurchase
import SafariServices

enum IPA:String {
    case OneMonthPro = "OneMonthPro"
    case OneYearPro = "OneYearPro"
    case StockMarketPro = "StockMarketPro"
}

class InAppPurchases: UIViewController {
    
    var selectedIPA = 0
    
    var AllPackage = [Purchases.Package]()
    
    
    @IBOutlet weak var continueOutlet: UIButton!{
        didSet{
            continueOutlet.clipsToBounds = true
            continueOutlet.layer.cornerRadius = continueOutlet.bounds.height/2
        }
    }
    
    @IBOutlet weak var WeekUpperLabel: UILabel!
    @IBOutlet weak var WeekUpperView: UIView!
    @IBOutlet weak var labelBannerWeek: UILabel!
    @IBOutlet weak var WeekLowerLabel: UILabel!
    
    @IBOutlet weak var YearUpperLabel: UILabel!
    @IBOutlet weak var YearUpperView: UIView!
    @IBOutlet weak var labelBannerYear: UILabel!
    @IBOutlet weak var YearLowerLabel: UILabel!
    
    @IBOutlet weak var weekView: UIView!
    @IBOutlet weak var yearView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView(vw: weekView)
        customView(vw: yearView)
        
        let weekViewGes = UITapGestureRecognizer()
        weekView.addGestureRecognizer(weekViewGes)
        weekViewGes.addTarget(self, action: #selector(weekViewtapped))
        
        let yearViewGes = UITapGestureRecognizer()
        yearView.addGestureRecognizer(yearViewGes)
        yearViewGes.addTarget(self, action: #selector(yearViewtapped))
        
        customLabelBanner(vw: labelBannerWeek)
        upperView(vw: WeekUpperView)
        upperView(vw: WeekUpperLabel)
        
        customLabelBanner(vw: labelBannerYear)
        upperView(vw: YearUpperLabel)
        upperView(vw: YearUpperView)
        select(vw:weekView)
        
        Purchases.shared.offerings { (offerings, error) in
            if let offerings = offerings {
                
                
                guard let package = offerings[IPA.OneMonthPro.rawValue]?.availablePackages.first else {
                    return
                }
                
                guard let package2 = offerings[IPA.OneYearPro.rawValue]?.availablePackages.first else {
                    return
                }
                
                self.AllPackage.append(package)
                self.AllPackage.append(package2)
                
                
                let priceone = offerings[IPA.OneMonthPro.rawValue]?.monthly?.localizedPriceString
                
                let pricetwo = offerings[IPA.OneYearPro.rawValue]?.annual?.localizedPriceString
                
                self.WeekLowerLabel.attributedText = self.PriceMessage(price: priceone ?? "$0.49" , save: "Save 5%")
                
                
                self.YearLowerLabel.attributedText = self.PriceMessage(price: pricetwo ?? "$5.49", save: "Save 26%")
                
            }
        }
        
    }
    
    var weekBool = true
    
    @objc func weekViewtapped(){
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        select(vw: weekView)
        Deselect(vw: yearView)
        selectedIPA = 0
    }
    
    @objc func yearViewtapped(){
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        select(vw: yearView)
        Deselect(vw: weekView)
        selectedIPA = 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        backButtonoutlet.fadeIn()
        continueOutlet.clipsToBounds = true
        continueOutlet.layer.cornerRadius = continueOutlet.bounds.height/2
    }
    
    func PriceMessage(price:String,save:String) -> NSAttributedString {
        let attrString = NSMutableAttributedString(string: price+"\n",
                                                   attributes: [NSAttributedString.Key.font: UIFont(name: "Arial-BoldMT", size: 18)!]);
        
        attrString.append(NSMutableAttributedString(string: save,
                                                    attributes: [NSAttributedString.Key.font: UIFont(name: "ArialMT", size: 10)!]))
        return attrString
    }
    
    func select(vw:UIView){
        vw.layer.borderWidth = 2
        vw.layer.borderColor = #colorLiteral(red: 1, green: 0.2862745098, blue: 0.2352941176, alpha: 1)
    }
    
    func Deselect(vw:UIView){
        vw.layer.borderWidth = 0
        vw.layer.borderColor = UIColor.clear.cgColor
    }
    
    
    func customView(vw:UIView){
        vw.layer.cornerRadius = 10
        vw.shadow2()
    }
    
    func customLabelBanner(vw:UILabel){
        vw.layer.masksToBounds = true
        vw.layer.cornerRadius = 10
        vw.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    func upperView(vw:UIView){
        vw.layer.masksToBounds = true
        vw.layer.cornerRadius = 10
        vw.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    
    @IBAction func continueAction (_ sender: Any) {
        if AllPackage.count > 0 {
            startIndicator(selfo: self)
            Purchases.shared.purchasePackage(AllPackage[selectedIPA]) { (transaction, purchaserInfo, error, userCancelled) in
                if purchaserInfo?.entitlements.all[IPA.OneMonthPro.rawValue]?.isActive == true ||  purchaserInfo?.entitlements.all[IPA.OneYearPro.rawValue]?.isActive == true {
                    
                    self.PerchesedComplte()
                    
                }else{
                    
                    stopIndicator()
                    //print("error")
                }
            }
        }
    }
    
    func PerchesedComplte(){
        stopIndicator()
        UserDefaults.standard.setisProMember(value: true)
        self.present(myAlt(titel:"Congratulations !",message:"You are a pro member now. Enjoy seamless experience with all features unlock."), animated: true, completion: nil)
    }
    
    @IBAction func restore(_ sender: Any) {
        
        Purchases.shared.restoreTransactions { (purchaserInfo, error) in
            
            if purchaserInfo?.entitlements.all[IPA.OneMonthPro.rawValue]?.isActive == true ||  purchaserInfo?.entitlements.all[IPA.OneYearPro.rawValue]?.isActive == true {
                
                self.PerchesedComplte()
                
            }
        }
        
        let iap = InAppPurchase.default
        iap.restore(handler: { (result) in
            switch result {
            
            case .success(let products):
                if products.contains("StockMarketPro"){
                    self.PerchesedComplte()
                    
                    UserDefaults.standard.setislifeTimePro(value: true)
                }
                
            case .failure(let error):
                print("error")
                print(error)
            }
        })
        
    }
    
    @IBOutlet weak var backButtonoutlet:UIButton!
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toc(sender:UIButton){
        let url = URL(string: "https://apps15.com/termsofuse.html")
        let vc = SFSafariViewController(url: url!)
        vc.modalPresentationStyle = .automatic
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func privacyPolicy(sender:UIButton){
        let url = URL(string: "https://apps15.com/privacy.html")
        let vc = SFSafariViewController(url: url!)
        vc.modalPresentationStyle = .automatic
        present(vc, animated: true, completion: nil)
    }
    
}


extension UIView {
    func fadeIn(duration: TimeInterval = 1.4, delay: TimeInterval = 0.5, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
        self.alpha = 0.0
        
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.isHidden = false
            self.alpha = 1.0
        }, completion: completion)
    }
}


//https://fluffy.es/scrollview-storyboard-xcode-11/


//Add a UIScrollView to the view and add top, bottom, leading, and trailing constraints.
//Add a UIView to the scroll view. We will call this the content view.
//Add top, bottom, leading, and trailing constraints from the content view to the scroll view's Content Layout Guide. Set the constraints to 0.
//Add an equal width constraint between the content view and the scroll view's Frame Layout Guide. (Not the scroll view or the main view!)
//Temporarily add a height constraint to the content view so that you can add your content. Make sure that all content has top, bottom, leading, and trailing constraints.
//Delete the height constraint on the content view.
