//
//  CustomerPaymentViewController.swift
//  PopUpPayApp
//
//  Created by Steven Chen on 7/13/17.
//  Copyright © 2017 Meghana Valluri. All rights reserved.
//

import UIKit
import PassKit

class CustomerPaymentViewController: QRScanViewController {

    var paymentData : [String : AnyObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        button.center = self.view.center
        self.view.addSubview(button)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.setTitle("Click to pay", for: .normal)
        
        button.addTarget(self, action: #selector(testButtonClicked), for: .touchUpInside)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func makePayment() {
        
    }
    
    func testButtonClicked(_ sender : Any) {
        // applePay(merchant_id: "merchant.popuppay", description: [:])
        
    }
    
    override func scanCallback(qrvalue: String) {
        do {
            let data = try JSONSerialization.jsonObject(with: qrvalue.data(using: .utf8)!, options: []) as! [String : AnyObject]
            applePay(merchant_id: "merchant.popuppay", paymentData: data)
        } catch {
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func applePay(merchant_id: String, paymentData: [String : AnyObject]) {
        self.paymentData = paymentData
        
        let request = PKPaymentRequest()
        request.merchantIdentifier = merchant_id
        request.supportedNetworks = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard]
        request.merchantCapabilities = PKMerchantCapability.capability3DS
        request.countryCode = "US"
        request.currencyCode = "USD"
        
        // add summary items for transaction here
        var summaryItems = [PKPaymentSummaryItem]()
        
        let total = paymentData["total"] as! Double
        let items = paymentData["items"] as! [String : Int]
        
        for (item, quantity) in items {
            var summaryItem = PKPaymentSummaryItem(label: item, amount: NSDecimalNumber(value: quantity))
            summaryItems.append(summaryItem)
        }

        let item = PKPaymentSummaryItem(label: "Sally's Lemonade Stand", amount: NSDecimalNumber(value: total))
        summaryItems.append(item)
        request.paymentSummaryItems = summaryItems

        // create the view controller for payment
        let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
        applePayController.delegate = self

        // show items
        print("apple pay trigering")
        self.present(applePayController, animated: true, completion: nil)
    }
}

extension CustomerPaymentViewController: PKPaymentAuthorizationViewControllerDelegate {
    @available(iOS 11.0, *)
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        completion(PKPaymentAuthorizationResult.init(status: PKPaymentAuthorizationStatus.success, errors: nil))
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        let client = self.paymentData?["client_id"] as! String
        let merchant = self.paymentData?["merchant_id"] as! String
        let transcation = self.paymentData?["transaction_id"] as! String
        
        let items = self.paymentData?["items"] as! [String : String]
        let itemString = HTTPUtils.encodeData(items)
        
        let url = "http://17.236.37.33:5000/purchase/\(client)/\(merchant)/\(transcation)?\(itemString)"
        HTTPUtils.getRequest(url, success: {
            (data) -> Void in
            print("YAY")
            }, failed: {print($0!)}, badResponse: {print($0)}
        )
        
        controller.dismiss(animated: true, completion: nil)
        
    }
}
