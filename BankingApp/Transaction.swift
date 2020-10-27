//
//  Transaction.swift
//  BankingApp
//
//  Created by Frank Novello on 9/5/20.
//  Copyright © 2020 Frank Novello. All rights reserved.
//

import UIKit

class Transaction {
    
    var name:String
    var amount:Double
    var category:String
    
    init(initWithName name:String, amount:Double, category:String) {
        self.name = name
        self.amount = amount
        self.category = category
        
    }
    
    func printTransaction()
    {
        print(self.name + " " + String(self.amount) + " " + self.category)
    }

}
