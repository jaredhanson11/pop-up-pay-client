//
//  CustomerPaymentViewController.swift
//  PopUpPayApp
//
//  Created by Steven Chen on 7/13/17.
//  Copyright © 2017 Meghana Valluri. All rights reserved.
//

import UIKit
import PassKit

class CustomerPaymentViewController: UIViewController {

    
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
        applePay(merchant_id: "whatever", description: NSObject())
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func applePay(merchant_id: String, description: NSObject) {
        let request = PKPaymentRequest()
        request.merchantIdentifier = merchant_id
        request.supportedNetworks = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard]
        request.merchantCapabilities = PKMerchantCapability.capability3DS
        request.countryCode = "US"
        request.currencyCode = "USD"
        
        // add summary items for transaction here
        var summaryItems = [PKPaymentSummaryItem]()
        
        let item = PKPaymentSummaryItem(label: "to whoever", amount: NSDecimalNumber(value: 100))
    
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
        controller.dismiss(animated: true, completion: nil)
    }
}
