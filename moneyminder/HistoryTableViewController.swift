//
//  HistoryTableViewController.swift
//  moneyminder
//
//  Created by Martin Graham on 8/11/16.
//  Copyright © 2016 MeG Studios. All rights reserved.
//

import UIKit
import CoreData

class HistoryTableViewController: UITableViewController {
    
    var transactions = [Transactions]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.setNavigationBarHidden(false, animated: false)
        getData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return transactions.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:HistoryTableViewCell = tableView.dequeueReusableCellWithIdentifier("cellId", forIndexPath: indexPath) as! HistoryTableViewCell
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        cell.amountLabel.text = String(format: "$%.2f", (transactions[indexPath.row].amount?.floatValue)!)
        cell.dateLabel.text = formatter.stringFromDate(transactions[indexPath.row].updatedDate!)
        cell.notesLabel.text = transactions[indexPath.row].note! as String
        return cell
    }
    
    func getData() {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        
        let request = NSFetchRequest(entityName: "Transactions")
        request.returnsObjectsAsFaults = false
        
        do{
            transactions = try context.executeFetchRequest(request) as! [Transactions]
            if transactions.count > 0 {
       
//                var newTrans = NSEntityDescription.insertNewObjectForEntityForName("Transactions", inManagedObjectContext: context)
//                if transType == "add" {
//                    transAmount = decimalWithString(amountTextField.text!)
//                } else {
//                    transAmount = decimalWithString(amountTextField.text!).decimalNumberByMultiplyingBy(NSDecimalNumber(int:-1))
//                }

//                do {
//                    try context.save()
//                } catch {
//                    print("error on saving transaction")
//                }
//                
//                let newBalance = transAmount.decimalNumberByAdding(results[0].valueForKey("balance") as! NSDecimalNumber)
//                print("\(transAmount)")
//                results[0].setValue(NSSet(object: newTrans), forKey: "transactions")
//                results[0].setValue(newBalance, forKey: "balance")
//                
//                do {
//                    try results[0].managedObjectContext?.save()
//                    print("saved")
//                    navigationController?.popViewControllerAnimated(true)
//                } catch {
//                    print("error on saving new transaction")
//                }
                
            } else {
            }
        } catch {
            print("unable to get database user")
        }
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
