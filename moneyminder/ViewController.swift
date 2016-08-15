//
//  ViewController.swift
//  moneyminder
//
//  Created by Martin Graham on 8/9/16.
//  Copyright © 2016 MeG Studios. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    
    @IBAction func addTransaction(sender: AnyObject) {
        self.performSegueWithIdentifier("segueToTransactions", sender: sender)
    }
    
    @IBAction func openSettings(sender: AnyObject) {
        self.performSegueWithIdentifier("segueToSettings", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        updateDisplay()
        
    }
    override func viewDidAppear(animated: Bool) {
        self.navigationController!.setNavigationBarHidden(true, animated: false)
        updateDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateDisplay() {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        
        
        let request = NSFetchRequest(entityName: "Users")
        request.returnsObjectsAsFaults = false
        var count = 0
        do{
            let results = try context.executeFetchRequest(request)
            count = results.count
            if count > 0 { // user exists
                for result in results as! [NSManagedObject] {
                    nameLabel.text = result.valueForKey("name") as? String
                    mainImageView.image = UIImage(data: (result.valueForKey("userPhoto") as? NSData)!, scale: 1.0)
                    balanceLabel.text = String(format: "$ %.2f", (result.valueForKey("balance")?.floatValue)!)
                }
            } else { // new app
                
//                let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
//                let plistFile = documentsPath.stringByAppendingString("main.plist")
//                var fileExists:Bool = NSFileManager.defaultManager().fileExistsAtPath(plistFile)
                let newUser = NSEntityDescription.insertNewObjectForEntityForName("Users", inManagedObjectContext: context)
                
//                if fileExists {
//                    let pngPath = NSHomeDirectory().stringByAppendingString("Documents/UserImage.png")
//                    
//                    let userImage = UIImage(contentsOfFile: pngPath)
//                    let dataDict = NSDictionary.init(contentsOfFile: plistFile)
//                    let userName = dataDict?.objectForKey("UserName")
//                    let oldBalance = dataDict?.objectForKey("Balance")
//                    print(userImage.debugDescription)
//                    print((userName?.string)!)
//                    print(oldBalance?.string)
//                    
//                    newUser.setValue(userName, forKey: "name")
//                    newUser.setValue(oldBalance as! NSDecimalNumber, forKey: "balance")
//                    newUser.setValue(NSDate(), forKey: "createdDate")
//                    newUser.setValue(NSDate(), forKey: "updatedDate")
//                    let imageData = NSData(data: UIImagePNGRepresentation(userImage!)!)
//                    newUser.setValue(imageData, forKey: "userPhoto")
//                    
//                } else {
                    newUser.setValue("Money Minder", forKey: "name")
                    newUser.setValue(0.00, forKey: "balance")
                    newUser.setValue(NSDate(), forKey: "createdDate")
                    newUser.setValue(NSDate(), forKey: "updatedDate")
                    let imageData = NSData(data: UIImageJPEGRepresentation(UIImage(named: ("meg-logo-bg"))!, 1.0)!)
                    newUser.setValue(imageData, forKey: "userPhoto")
//                }

                do {
                    try context.save()
                } catch {
                    print("error on saving user")
                }
                nameLabel.text = newUser.valueForKey("name") as! String
                balanceLabel.text = String(format: "$ %.2f", (newUser.valueForKey("balance")?.floatValue)!)
            }
        } catch {
            print("unable to get database user")
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if sender?.tag == 1 {
            let destVC = segue.destinationViewController as! TransactionViewController
            destVC.transType = "sub"
            destVC.title = "Spent Money"
        } else if sender?.tag == 2 {
            let destVC = segue.destinationViewController as! TransactionViewController
            destVC.transType = "add"
            destVC.title = "Made Money"
        }
    }

}

