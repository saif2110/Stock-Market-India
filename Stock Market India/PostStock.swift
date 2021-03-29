//
//  PostStock.swift
//  Stock Market India
//
//  Created by Junaid Mukadam on 18/12/20.
//

import UIKit
import DropDown
import SkyFloatingLabelTextField
import Alamofire
import SwiftyJSON

class PostStock: UIViewController,UITextFieldDelegate{
    
    @IBOutlet weak var StockName: UITextField!
    @IBOutlet weak var currentPrice: UITextField!
    @IBOutlet weak var target: UITextField!
    @IBOutlet weak var StopLoss: UITextField!
    @IBOutlet weak var Peridos: UITextField!
    
    
    let dropDown = DropDown()
    let dropDownPeriod = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StockName.layer.borderColor = UIColor.systemRed.cgColor
        StockName.layer.borderWidth = 0.5
        StockName.layer.cornerRadius = 5
        StockName.delegate = self
        
        currentPrice.layer.borderColor = UIColor.systemRed.cgColor
        currentPrice.layer.borderWidth = 0.5
        currentPrice.layer.cornerRadius = 5
        
        target.layer.borderColor = UIColor.systemRed.cgColor
        target.layer.borderWidth = 0.5
        target.layer.cornerRadius = 5
        
        StopLoss.layer.borderColor = UIColor.systemRed.cgColor
        StopLoss.layer.borderWidth = 0.5
        StopLoss.layer.cornerRadius = 5
        
        Peridos.layer.borderColor = UIColor.systemRed.cgColor
        Peridos.layer.borderWidth = 0.5
        Peridos.layer.cornerRadius = 5
        Peridos.placeholder = "Intraday"
        Peridos.delegate = self
        
        dropDownPeriod.anchorView = Peridos
        dropDownPeriod.width = Peridos.frame.width
        dropDownPeriod.direction = .bottom
        dropDownPeriod.dataSource = ["Intraday","2-3 Days","1 Week","2 Weeks","1 Month","6 Months","Long term"]
        dropDownPeriod.selectionAction = { [unowned self] (index: Int, item: String) in
            itemPeriod = item
            Peridos.text = itemPeriod
        }
    }
    
    @IBAction func SubmitAction(_ sender: Any) {
        if item != "" {
            if currentPrice.text?.count == 0 || target.text?.count == 0 || StopLoss.text?.count == 0 {
                self.present(myAlt(titel: "Error", message: "Please make sure all fields are filled in correctly"),animated: true,completion: nil)
            }else{
                
                let parm:Parameters = [
                    "userID" : UserDefaults.standard.getid(),
                    "stock_name" : item,
                    "current_price" : currentPrice.text ?? "Null",
                    "loss" : StopLoss.text ?? "Null",
                    "target" : target.text ?? "Null",
                    "SourceName": UserDefaults.standard.getUsername(),
                    "period" : itemPeriod,
                    "type" : "Buy"
                ]
                
                postWithParameter(Url: "addStockbyUser.php", parameters: parm) { (JSON, Error) in
                    self.present(myAlt(titel: "Message", message: JSON["message"].string ?? "Something went wrong.Please try again later"),animated: true,completion: nil)
                    self.item = ""
                    self.itemPeriod = ""
                    self.StockName.text = ""
                    self.currentPrice.text = ""
                    self.target.text = ""
                    self.Peridos.text = ""
                    self.StopLoss.text = ""
                    self.dropDownPeriod.hide()
                }
                
            }
        }else{
            self.present(myAlt(titel: "Error", message: "Please select stock name from list to continue"),animated: true,completion: nil)
        }
    }
    
    var StockNameAraay = [String]()
    var item = ""
    var itemPeriod = "Intraday"
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == Peridos {
            dropDownPeriod.show()
        }else if textField == StockName {
            StockName.text = ""
            item = ""
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let query = String(describing: StockName.text!)
        getWithParameter(Url: "https://www.screener.in/api/company/search/?q=\(query)") { (json, Err) in
            self.StockNameAraay.removeAll()
            for(_,subJson) in json {
                self.StockNameAraay.append(subJson["name"].string ?? "")
            }
            self.dropDown.anchorView = self.currentPrice
            self.dropDown.width = self.StockName.frame.width
            self.dropDown.dataSource = self.StockNameAraay
            self.dropDown.direction = .bottom
            
            self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                self.item = item
                self.StockName.text = self.item
                self.currentPrice.becomeFirstResponder()
            }
            self.dropDown.show()
        }
    }
}
