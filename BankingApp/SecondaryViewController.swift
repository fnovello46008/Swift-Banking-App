//
//  SecondaryViewController.swift
//  BankingApp
//
//  Created by Frank Novello on 9/4/20.
//  Copyright © 2020 Frank Novello. All rights reserved.
//

import UIKit
import Charts



class SecondaryViewController: UIViewController, ChartViewDelegate, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var PieChartView: PieChartView!
    
    var names:[String]   = ["Pizza","Fish","Chips","Ice Cream"]
    var amounts:[Double] = [25,25,25,25]
    var categories:[String] = []
    
    var animationSpeed = 3.5;
    

    var transactions:[Transaction] = []
    var categoriesAndAmounts:[String:Double] = [ " " : 0.0]
    
    var transactionCategories:[String] = []
    var transactionAmounts:[Double] = []
    var dataEntries:[ChartDataEntry] = []
    
    
    var transactionCount = 0
    var transactionsPerCategory:[Transaction] = []
    var totalAmountPerCategory = 0.00
    var totalAmount = 0.00
    
    var selectedCategory = ""
    
    var isLoadedFirst = true
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var categories:[String] = []
        var names:[String] = []
        var amounts:[Double] = []
        
        
        self.PieChartView.delegate = self
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        
        for (index, value) in categoriesAndAmounts
         {
            transactionCategories.append(index)
            transactionAmounts.append(value)
         }
        
        
        for i in 0..<transactions.count
        {
            categories.append(transactions[i].category)
            names.append(transactions[i].name)
            amounts.append(transactions[i].amount)
             totalAmount += transactions[i].amount
        }
        
        
      //print(transactionCategories)
        
      SetChart(dataPoints: transactionCategories, values: transactionAmounts)
        

    }
    
    func SetChart(dataPoints: [String], values: [Double])
    {
         //dataEntries: [ChartDataEntry] = []

        for i in 0..<dataPoints.count {

           // let dataEntry = PieChartDataEntry(value: values[i], label: names[i] + ": $" + String(amounts[i]))


            let dataEntry = PieChartDataEntry(value: values[i], label: transactionCategories[i])
            
            dataEntries.append(dataEntry)
        }


        let pieChartDataSet = PieChartDataSet(dataEntries)

        pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
        let pieChartData = PieChartData(dataSet: pieChartDataSet)

        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        // 4. Assign it to the chart’s data
        PieChartView.data = pieChartData

        PieChartView.animate(xAxisDuration: animationSpeed)
        PieChartView.animate(yAxisDuration: animationSpeed)

        pieChartDataSet.drawValuesEnabled = false
//      PieChartView.drawEntryLabelsEnabled = false



        PieChartView.entryLabelColor = UIColor.white

        //PieChartView.holeColor = UIColor.systemGreen

        PieChartView.centerText = "$1000"

        PieChartView.drawCenterTextEnabled = false
        
        PieChartView.legend.font = UIFont(name: "Helvetica", size: 30)!;
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
//        print("chartview \(chartView)")
//        print("entry \(entry)")
//        print("highlight \(highlight)")
        
        
        
        let index:Int = Int(highlight.x)
        
        var transactionType:String = (dataEntries[index] as! PieChartDataEntry).label as! String
   
   
        
        var transactionCategory = transactionType.components(separatedBy: CharacterSet.decimalDigits).joined(separator: "")
        
        selectedCategory = transactionCategory
//        if let transactionCateogry = transactionType.range(of: " $")
//           {
//               transactionCategoryRemoveNumbers.removeSubrange(transactionCateogry.lowerBound..<transactionType.endIndex)
//
//               print(transactionCateogry)
//
//           }
        
        transactionCategory = transactionCategory.components(separatedBy: " $")[0]
        
       // print(transactionCategory)
        
        //print("transactionType: \(transactionType)")
        //print("cateogry: \(transactionCateogry)")

            transactionsPerCategory = []
            totalAmountPerCategory = 0.00
        
            isLoadedFirst = false
            
            totalAmount = 0.00
        
          for i in 0..<transactions.count
          {
              if(transactions[i].category == transactionCategory)
              {
                
                transactionsPerCategory.append(transactions[i])
                
                totalAmountPerCategory += transactions[i].amount
                
              }
            
          }
        
        
        
        self.tableView.reloadData()
        
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return transactionsPerCategory.count
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        
        if(isLoadedFirst)
        {
            return transactions.count
        }else {
            return transactionsPerCategory.count;
        }
        
     
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CustomCellTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! CustomCellTableViewCell
            cell.backgroundColor = UIColor.white
//        cell.textLabel?.text = transactionsPerCategory[indexPath.row].name
//
//
//        cell.detailTextLabel?.text =  " $" + String(transactionsPerCategory[indexPath.row].amount)
            

        
        if(isLoadedFirst)
        {
            cell.label.text = transactions[indexPath.row].name
            cell.amount.text = "$ \(transactions[indexPath.row].amount)"
        }
        else {
            cell.label.text = transactionsPerCategory[indexPath.row].name
            cell.amount.text = "$ \(transactionsPerCategory[indexPath.row].amount)"
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       
        
        if(isLoadedFirst)
        {
             return "Total Amount $\(totalAmount)"
        }
        else
        {
             return "Category: \(selectedCategory) - Total Amount $\(totalAmountPerCategory)"
        }
    }

}


private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
  var colors: [UIColor] = []
  for _ in 0..<numbersOfColor {
    let red = Double(arc4random_uniform(256))
    let green = Double(arc4random_uniform(256))
    let blue = Double(arc4random_uniform(256))
    let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
    colors.append(color)
  }
  return colors
}

















        
//        for(index, _ ) in names.enumerated()
//        {
//            print(names[index] + " Amount: $" + String(amounts[index]))
//        }
