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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var cart:[String:Int]?
    var menu:[String:Double]?
    
    //Cart Page Buttons and Labels
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var cartButtonLabel: UILabel!
    @IBOutlet weak var clearCartButton: UIButton!
    
    @IBOutlet weak var addMenuItemButton: UIButton!
    
    
    // Cart
    func calculateCartTotal()->Double {
        var cartTotal = 0.0;
        
        for (item, quantity) in self.cart! {
            cartTotal += (menu?[item]!)!
        }
        
        cartTotal = cartTotal*1.9
        
        return cartTotal
        
    }
    
    func updateCartButtonLabel() {
        
        let cartQuantities = self.cart!.map{ $1 }
        let cartTotalQuantity = cartQuantities.reduce(0, +)
        self.cartButtonLabel.text = String(cartTotalQuantity)
        
    }
    
    func addToCart(item_id: String){
        
        if self.cart?[item_id] != nil {
            self.cart?[item_id]! += 1
        }
        else {
            self.cart?[item_id] = 1
        }
        
    }
    func clearCart() {
        
        self.cart!.removeAll()
        self.cartButtonLabel.text = "0"
        
    }


}

