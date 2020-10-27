//
//  ViewController.swift
//  BankingApp
//
//  Created by Frank Novello on 9/2/20.4
//  Copyright © 2020 Frank Novello. All5 rights reserved.
//

import UIKit
import LinkKit

class ViewController: UIViewController, PLKPlaidLinkViewDelegate {
    
    
    let link_token = "link-sandbox-98595c42-ad9b-4b39-9ecd-ea37d4aa4167"
    var names:[String] = []
    var amounts:[Double] = []
    var categories: [String] = []
    
    var namesAndCategories: [String: String] = ["":""]
    var isLoggedIn = false;
    

    var uniqueCategories:[String] = []
    
    var transactions:[Transaction] = []
    
    var TravelAmount:Double = 0.0;
    
    var categoriesAndAmounts:[String:Double] = [ " " : 0.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Do any additional setup after loading the view.

        
        // With custom configuration
        
        if(isLoggedIn)
        {
            performSegue(withIdentifier: "testId", sender: self)
            
        }else {
            let linkConfiguration = PLKConfiguration(linkToken: link_token)
            let linkViewDeletgate = self
            let linkViewController = PLKPlaidLinkViewController(
              linkToken: link_token,
              configuration: linkConfiguration,
              delegate: linkViewDeletgate)

            
            linkViewController.modalPresentationStyle = .fullScreen
            present(linkViewController, animated: true)
            
            isLoggedIn = true
        }
    }
    
    
    
    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didSucceedWithPublicToken publicToken: String, metadata: [String : Any]?) {
        
        
        if let url = URL(string: "http://192.168.1.186:8000/api/transactions")
        {
                do {
                    let data = try Data(contentsOf: url)
                    
                    do {
                        // make sure this JSON is in the format, we expect
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {

                            
                            names = (json as NSDictionary).value(forKeyPath: "transactions.name") as! [String]
                            amounts = (json as NSDictionary).value(forKeyPath: "transactions.amount") as! [Double]
                            let Jsoncategories = (json as NSDictionary).value(forKeyPath: "transactions.category") as! [NSArray]
                                                         
                    
                            //print("\n\n\n")
                            
                            
                    
                            for i in 0..<names.count
                            {
                                categories.append( Jsoncategories[i][0] as! String )
                                
                                //namesAndCategories[names[i]] = categories[i]
                                
                                transactions.append(Transaction(initWithName: names[i], amount: amounts[i], category: categories[i]))
                                
                                
                            }
                            
                            for i in 0..<categories.count
                            {
                                if(!uniqueCategories.contains(categories[i]))
                                {
                                    uniqueCategories.append(categories[i])
                                }
                        
                            }
                            
                            for i in 0..<uniqueCategories.count
                            {
                                categoriesAndAmounts[uniqueCategories[i]] = 0
                            }
                            
                            for i in 0..<transactions.count
                            {
                                for j in 0..<uniqueCategories.count
                                {
                                    if(transactions[i].category == Array(categoriesAndAmounts.keys)[j])
                                    {
                                        //print(transactions[i].category)
                                        
                                        categoriesAndAmounts[transactions[i].category]! += transactions[i].amount
                                    }
                                }
                            }
                            
                            for (index, value) in categoriesAndAmounts
                            {
                                if(index == " ")
                                {
                                    categoriesAndAmounts.removeValue(forKey: index)
                                }
                                if(value == 0.0)
                                {
                                    categoriesAndAmounts.removeValue(forKey: index)
                                }
                            }
                            
                            
                            
                            //print(categoriesAndAmounts)
                            
                           // print(categories)
                            //print(namesAndCategories)
                            
                            dismiss(animated: true)
                            
                        
                        }
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                    }
                    
                } catch {
                    print(error.localizedDescription)
                }
            

        }
    }
    
    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didExitWithError error: Error?, metadata: [String : Any]?) {
    
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "testId" {
            let vc = segue.destination as! SecondaryViewController
            
//            vc.amounts = amounts
//            vc.names = names
//            vc.categories = categories
            
            vc.transactions = transactions
            vc.categoriesAndAmounts = categoriesAndAmounts
            vc.modalPresentationStyle = .fullScreen
            
        }
        
    }
    
    
}
