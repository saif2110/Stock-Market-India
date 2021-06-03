//
//  topfifty.swift
//  Stock Market India
//
//  Created by Junaid Mukadam on 09/12/20.
//

import UIKit
import GoogleMobileAds
import InAppPurchase
import StoreKit

var Sender = ""
var leftBarButtonItemStored:UIBarButtonItem? = nil

class topfifty: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var nameofStock = [String]()
    var date = [String]()
    var currentPrice = [String]()
    var target = [String]()
    var period = [String]()
    var SL = [String]()
    var Likes = [String]()
    var DisLikes = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            return nameofStock.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section != 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! mainCell
            cell.nameStock.text = nameofStock[indexPath.row].capitalized
            cell.Date.text = date[indexPath.row]
            cell.CurrentPrice.text = "Current Price: " + currentPrice[indexPath.row]
            cell.SellTarget.text = "Sell Target: " + target[indexPath.row]
            cell.Period.text = "Period: " + period[indexPath.row]
            cell.StopLoss.text = "Stop Loss: " + SL[indexPath.row]
            cell.OutsideView.shadow()
            
            cell.Like.tag = indexPath.row
            cell.DisLike.tag = indexPath.row
            cell.Like.addTarget(self, action: #selector(TapLike), for: .touchUpInside)
            cell.DisLike.addTarget(self, action: #selector(TapDisLike), for: .touchUpInside)
            cell.Like.setTitle("+"+Likes[indexPath.row], for: .normal)
            cell.DisLike.setTitle("-"+DisLikes[indexPath.row], for: .normal)
            
            if (indexPath.row == 5 || indexPath.row == 14) && !UserDefaults.standard.isProMember() {
                cell.adView.isHidden = false
                cell.adView.rootViewController = self
                cell.adView.load(GADRequest())
            }else{
                cell.adView.isHidden = true
            }
            
            
            if indexPath.row == 18 {
                showIntrest(Myself: self)
            }
            
            return cell
            
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "famousTableCell", for: indexPath) as! famousTableCell
            
            
            return cell
            
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            
            return 165
        }else{
            
            return 195
        }
    }
    
    func headerView(label:String) -> UIView {
        let sectionHeader = UIView.init(frame: CGRect.init(x: 0, y: 0, width: myView.frame.width, height: 35))
        sectionHeader.backgroundColor = .white
        let sectionText = UILabel()
        sectionText.frame = CGRect.init(x: 15, y: 8, width: sectionHeader.frame.width-10, height: sectionHeader.frame.height-10)
        sectionText.text = label
        sectionText.font = .systemFont(ofSize: 15, weight: .semibold) // my custom font
        sectionText.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        sectionHeader.addSubview(sectionText)
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            
            return headerView(label: "Recommended by Influential Personality")
        }else{
            
            return headerView(label: "Recommended by Users")
        }
    }
    
    @objc func TapLike(sender:UIButton){
        requestToRate()
        if !UserDefaults.standard.isLogin(){
            self.present(myAlt(titel:"You need to Sign In",message:"You need to sign in to Like, Dislike & Post Tips"), animated: true, completion: nil)
        }else{
            let currentTimeInMiliseconds = Date().timeIntervalSince1970 * 1000
            if currentTimeInMiliseconds > UserDefaults.standard.getLikeDisLikeTime() + 3600000 {
                Likes[sender.tag] = String(Int(Likes[sender.tag])! + 1)
                myView.reloadData()
                UserDefaults.standard.setLikeDisLikeTime(value: currentTimeInMiliseconds)
                
            }else{
                
                self.present(myAlt(titel:"Limit Exceeded",message:"You can Like or Dislike only one stock every 1 hour"), animated: true, completion: nil)
            }
        }
    }
    
    @objc func TapDisLike(sender:UIButton){
        if !UserDefaults.standard.isLogin(){
            
            self.present(myAlt(titel:"You need to Sign In",message:"You need to sign in to Like, Dislike & Post Tips"), animated: true, completion: nil)
            
        }else{
            
            let currentTimeInMiliseconds = Date().timeIntervalSince1970 * 1000
            if currentTimeInMiliseconds > UserDefaults.standard.getLikeDisLikeTime() + 3600000 {
                DisLikes[sender.tag] = String(Int(DisLikes[sender.tag])! + 1)
                myView.reloadData()
                UserDefaults.standard.setLikeDisLikeTime(value: currentTimeInMiliseconds)
                
            }else{
                
                self.present(myAlt(titel:"Limit Exceeded",message:"You can Like or Dislike only one stock every 1 hour"), animated: true, completion: nil)
                
            }
        }
    }
    
    @IBOutlet weak var myView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.isProMember(){
            self.navigationController?.navigationBar.topItem?.title = "Live 30 Stocks"
        }else{
            self.navigationController?.navigationBar.topItem?.title = "Live 20 Stocks"
        }
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = leftBarButtonItemStored
    }
    
    var indicator = UIActivityIndicatorView()
    
    @objc func sortData(){
        getStockData(sort: Sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !Connectivity.isConnectedToInternet {
            let alert2 = UIAlertController(title: "Connection Error", message: "The Internet connection appears to be offline.Please connect to Internet and open the app again.", preferredStyle: .alert)
            alert2.addAction(UIAlertAction(title: "EXIT APP", style: .default, handler: { action in
                                            switch action.style{
                                            case .default:
                                                exit(0)
                                            case .cancel:
                                                print("")
                                            case .destructive:
                                                print("")
                                            @unknown default:
                                                fatalError()
                                            }}))
            
            present(alert2, animated: true, completion: nil)
            print("Not Connected")
            
        }
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(sortData),
                                               name: NSNotification.Name("sortData"),
                                               object: nil)
        
        
        showIntrest(Myself: self)
        
        if UserDefaults.standard.getnumberOftimeAppOpen() > 1 {
            requestToRate()
        }
        
        indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        indicator.color = .systemRed
        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicator.center = view.center
        self.view.addSubview(indicator)
        self.view.bringSubviewToFront(indicator)
        indicator.startAnimating()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.tintColor = .red
        
        let search = UIBarButtonItem(image: #imageLiteral(resourceName: "search"), style: .plain, target: self, action: #selector(addTapped))
        
        let pro = UIBarButtonItem(image: #imageLiteral(resourceName: "pro1"), style: .plain, target: self, action: #selector(addPro))
        
        self.navigationController?.navigationBar.topItem?.setRightBarButtonItems([search,pro], animated: true)
        
        if UserDefaults.standard.isProMember() {
            self.navigationController?.navigationBar.topItem?.setRightBarButtonItems([search], animated: true)
        }else{
            self.navigationController?.navigationBar.topItem?.setRightBarButtonItems([search,pro], animated: true)
        }
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.up.arrow.down.circle"), for: .normal)
        button.setTitle(" All Stocks", for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(sort), for: .touchUpInside)
        button.titleLabel?.minimumScaleFactor = 0.5
        button.clipsToBounds = true
        
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(customView: button)
        
        leftBarButtonItemStored = self.navigationController?.navigationBar.topItem?.leftBarButtonItem
        
        getStockData(sort: Sender)
        
        let iap = InAppPurchase.default
        iap.set(shouldAddStorePaymentHandler: { (product) -> Bool in
            return true
        }, handler: { (result) in
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
    
    @objc func addTapped(){
        let MainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = (MainStoryboard.instantiateViewController(withIdentifier: "searchVC") as? searchVC)
        self.present(controller!, animated: true, completion: nil)
    }
    
    @objc func addPro(){
        let vc  = InAppVC()
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func sort(sender:UIButton) {
        
        if sender.currentTitle == " All Stocks" {
            sender.setTitle(" Intraday", for: .normal)
            getStockData(sort: "Intraday")
            Sender = "Intraday"
        }else if sender.currentTitle == " Intraday"{
            sender.setTitle(" 1 Week", for: .normal)
            getStockData(sort: "1 Week")
            Sender = "1 Week"
            showIntrest(Myself: self)
        }else if sender.currentTitle == " 1 Week"{
            sender.setTitle(" 1 Month", for: .normal)
            getStockData(sort: "1 Month")
            Sender = "1 Month"
        }else if sender.currentTitle == " 1 Month"{
            sender.setTitle(" All Stocks", for: .normal)
            getStockData()
            Sender = ""
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("sortData"), object: nil)
    }
    
    func getStockData(sort:String = "") {
        indicator.startAnimating()
        postWithParameter(Url: "getStockdata.php", parameters: ["limit":numberOFStocks,"sort":sort]) { (json, err) in
            if err == nil {
                
                self.nameofStock.removeAll()
                self.date.removeAll()
                self.currentPrice.removeAll()
                self.target.removeAll()
                self.period.removeAll()
                self.SL.removeAll()
                self.Likes.removeAll()
                self.DisLikes.removeAll()
                
                for (_,SubJson) in json {
                    self.nameofStock.append(SubJson["Name"].string ?? "Null")
                    self.date.append(SubJson["PostedTime"].string ?? "Null")
                    self.currentPrice.append(SubJson["Rate"].string ?? "Null")
                    self.target.append(SubJson["Target"].string ?? "Null")
                    self.period.append(SubJson["HoldingTime"].string ?? "Null")
                    self.SL.append(SubJson["SL"].string ?? "Null")
                    
                    self.Likes.append(LikeAlgoritham(Name: SubJson["Name"].string ?? "Null", Date: SubJson["PostedTime"].string ?? "Null"))
                    self.DisLikes.append(DisLikeAlgoritham(Name: SubJson["Name"].string ?? "Null", Date: SubJson["PostedTime"].string ?? "Null"))
                }
                
                self.indicator.stopAnimating()
                self.myView.delegate = self
                self.myView.dataSource = self
                self.myView.reloadData()
            }else{
                self.indicator.stopAnimating()
            }
        }
    }
}
