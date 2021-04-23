//
//  CompanyGuideVC.swift
//  Stock Market India
//
//  Created by Junaid Mukadam on 21/04/21.
//

import UIKit

class CompanyGuideVC: UIViewController {
    @IBOutlet weak var viewBut: UIView!
    @IBOutlet weak var viewBut2: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewBut.layer.cornerRadius = 8
        viewBut.shadow2()
        
        viewBut2.layer.cornerRadius = 8
        viewBut2.shadow2()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Company Guide"
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = nil
    }
    
    @IBAction func CGbutton(_ sender: UIButton) {
        if sender.tag == 1 {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "niftyFifty") as? niftyFifty
            self.navigationController?.pushViewController(vc!, animated: true)
        }else  if sender.tag == 2 {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "topWL") as? topWL
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    
}
