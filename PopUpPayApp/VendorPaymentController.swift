//
//  FirstViewController.swift
//  PopUpPayApp
//
//  Created by Meghana Valluri on 7/13/17.
//  Copyright © 2017 Meghana Valluri. All rights reserved.
//

import UIKit

class VendorPaymentController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        button.center = self.view.center
        
        button.setTitle("QR CODE", for: UIControlState.normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(self.displayQRCode), for: .touchUpInside)
        
        self.view.addSubview(button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func displayQRCode(_ sender : Any) {
        // Create modal
        
        if let qrImage = generateQRCode() {
            let imageView = UIImageView()
            imageView.frame = CGRect(x : 100, y: self.view.frame.height / 2, width: 200, height: 200)
            
            imageView.image = UIImage(ciImage: qrImage)
            self.view.addSubview(imageView)
        } else {
            // TODO: Alert to try again
        }
        
        
        
    }
    
    func generateQRCode() -> CIImage? {
        if let requestString =  cartToRequestString() {
            let data = requestString.data(using: String.Encoding.ascii)
            
            if let filter = CIFilter(name: "CIQRCodeGenerator") {
                filter.setValue(data, forKey: "inputMessage")
                filter.setValue("Q", forKey: "inputCorrectionLevel")
                
                let qrCodeImage = filter.outputImage
                return qrCodeImage
                
            }
            
            return nil
        }
        
        return nil
        
    }
    
    func cartToRequestString() -> String? {
        do {
            let cartData = try JSONSerialization.data(withJSONObject: getCart(), options: [])
            
            if let cartJson = String(data: cartData, encoding: .ascii) {
                return cartJson
            } else {
                return nil
            }
            
        } catch {
            return nil
        }
    }
    
    func getCart() -> [String : Int] {
        //TODO: Replace
        return ["lemonade" : 1, "cookies" : 2]
    }
    
    

}

