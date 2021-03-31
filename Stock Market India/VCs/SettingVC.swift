//
//  SettingVC.swift
//  Stock Market India
//
//  Created by Junaid Mukadam on 12/12/20.
//

import UIKit

class SettingVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    let titels1 = ["Privacy Policy","Rate Us"]
    let titels2 = ["Follow Developer"]
    let titels3 = ["Share App","Bug / Feedback"]
    let myMail = "feedback@safeapps.online"
    
    let titelsImage1:[UIImage] = [#imageLiteral(resourceName: "Privacy"),#imageLiteral(resourceName: "Rate Us")]
    let titelsImage2:[UIImage]  = [#imageLiteral(resourceName: "dev")]
    let titelsImage3:[UIImage] = [#imageLiteral(resourceName: "feedback"),#imageLiteral(resourceName: "bug")]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1 {
            return 2
        }else if section == 2 {
            return 1
        }else{
            return 2
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0 {
            return 40
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingMain", for: indexPath) as! SettingMain
            cell.separatorInset.right = cell.bounds.size.width
            cell.postStockTip.addTarget(self, action: #selector(posttips), for: .touchUpInside)
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
            if indexPath.section == 1 {
                cell.textLabel?.text = titels1[indexPath.row]
                cell.imageView?.image = titelsImage1[indexPath.row]
            }else if indexPath.section == 2{
                cell.textLabel?.text = titels2[indexPath.row]
                cell.imageView?.image = titelsImage2[indexPath.row]
            }else{
                cell.textLabel?.text = titels3[indexPath.row]
                cell.imageView?.image = titelsImage3[indexPath.row]
                if indexPath.row == 1{
                    cell.separatorInset.right = cell.bounds.size.width
                }
            }
            
            cell.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 0.3)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 150
        }else{
            return 50
        }
        
    }
    
    @objc func posttips(){
        if UserDefaults.standard.getFullAccess() == "true"{
            
            let MainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = MainStoryboard.instantiateViewController(withIdentifier: "PostStock") as? PostStock
            self.present(controller!, animated: true, completion: nil)
            
        }else{
            self.present(myAlt(titel: "Limited Access", message: "You don't have permission to post stock tip.\nEmail us if you want permission"),animated: true,completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myView.delegate = self
        self.myView.dataSource = self
        self.myView.reloadData()
        self.myView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    @IBOutlet weak var myView: UITableView!
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.view.setNeedsLayout()
        self.navigationController?.view.layoutIfNeeded()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                UIApplication.shared.open(URL(string:"https://safeapps.online/privacy.html")!)
            }else{
                UIApplication.shared.open(URL(string:"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1546123296&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software")!)
                
            }
        }else  if indexPath.section == 2 {
            UIApplication.shared.open(URL(string: "https://www.instagram.com/thisis_saif/")!)
            
        }else if indexPath.section == 3 {
            if indexPath.row == 0 {
                let text = "*Stock Market India*\n \nDownload this app get best stock tips and suggestions from experts.\n \n Link to download - https://apps.apple.com/in/app/stock-market-india/id1546123296"
                let textShare = [ text ]
                let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
                
            }else{
                UIApplication.shared.open(createEmailUrl(to:myMail, subject: "Bug / Feedback", body: "")!)
            }
        }
    }
    
}


extension UITableViewCell {
    func separator(hide: Bool) {
        separatorInset.left = hide ? bounds.size.width : 0
    }
}
