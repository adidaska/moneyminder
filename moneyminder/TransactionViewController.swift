//
//  TransactionViewController.swift
//  moneyminder
//
//  Created by Martin Graham on 8/10/16.
//  Copyright © 2016 MeG Studios. All rights reserved.
//

import UIKit
import CoreData

class TransactionViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    // need to use the sender to determine if adding or subtracting amount
    // on save need to create a new entry in the transactions table, get new balance, update user table

    @IBOutlet weak var moneyTitleLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var notesTextField: UITextField!
    var transType: String = "add"
    var transAmount: NSDecimalNumber = 0.00
    

    @IBAction func saveTransaction(sender: AnyObject) {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        let request = NSFetchRequest(entityName: "Users")
        request.returnsObjectsAsFaults = false
        do{
            let results = try context.executeFetchRequest(request)
            if results.count > 0 {
                var newTrans = NSEntityDescription.insertNewObjectForEntityForName("Transactions", inManagedObjectContext: context)
                if transType == "add" {
                    transAmount = decimalWithString(amountTextField.text!)
                } else {
                    transAmount = decimalWithString(amountTextField.text!).decimalNumberByMultiplyingBy(NSDecimalNumber(int:-1))
                }
                newTrans.setValue(transAmount, forKey: "amount")
                newTrans.setValue(NSDate(), forKey: "createdDate")
                newTrans.setValue(NSDate(), forKey: "updatedDate")
                newTrans.setValue(notesTextField.text, forKey: "note")
                do {
                    try context.save()
                } catch {
                    print("error on saving transaction")
                }
                
                let newBalance = transAmount.decimalNumberByAdding(results[0].valueForKey("balance") as! NSDecimalNumber)
                results[0].setValue(NSSet(object: newTrans), forKey: "transactions")
                results[0].setValue(newBalance, forKey: "balance")
                
                do {
                    try results[0].managedObjectContext?.save()
                    navigationController?.popViewControllerAnimated(true)
                } catch {
                    print("error on saving new transaction")
                }
                
            } else {
            }
        } catch {
            print("unable to get database user")
        }
        
        
    }
        
        
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        //saveTransaction(notesTextField)
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
//        if textField == amountTextField {
//            self.amountTextField.delegate = self
//        } else if textField == notesTextField {
//            self.notesTextField.delegate = self
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController!.setNavigationBarHidden(false, animated: false)
        amountTextField.becomeFirstResponder()
        self.notesTextField.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func decimalWithString(string: String) -> NSDecimalNumber {
        let formatter = NSNumberFormatter()
        formatter.generatesDecimalNumbers = true
        return formatter.numberFromString(string) as? NSDecimalNumber ?? 0
    }
    
    override func viewWillAppear(animated: Bool) {
        if transType == "add" {
            moneyTitleLabel.text = "How much did you make?"
            notesTextField.placeholder = "Where did the money come from?"
        } else {
            moneyTitleLabel.text = "How much did you spend?"
            notesTextField.placeholder = "What did you spend it on?"
        }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
