//
//  SettingsViewController.swift
//  moneyminder
//
//  Created by Martin Graham on 8/10/16.
//  Copyright © 2016 MeG Studios. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var userImageView: UIImageView!
    
    
    @IBAction func chooseImage(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        userImageView.image = image
        updateInfo()
    }
    
    func textFieldDidChange(textField: UITextField) {
        updateInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameLabel.addTarget(self, action: #selector(SettingsViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.setNavigationBarHidden(false, animated: false)
        self.nameLabel.delegate = self
        updateDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func updateInfo() {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        let request = NSFetchRequest(entityName: "Users")
        request.returnsObjectsAsFaults = false
        do{
            let results = try context.executeFetchRequest(request)
            if results.count > 0 {
                results[0].setValue(nameLabel.text, forKey: "name")
                let imageData = NSData(data: UIImageJPEGRepresentation(userImageView.image!, 1.0)!)
                results[0].setValue(imageData, forKey: "userPhoto")
                do {
                    try results[0].managedObjectContext?.save()
                } catch {
                    print("error on saving user info")
                }
                
            } else {
            }
        } catch {
            print("unable to get database user")
        }
    }
    
    func updateDisplay() {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        let request = NSFetchRequest(entityName: "Users")
        request.returnsObjectsAsFaults = false
        do{
            let results = try context.executeFetchRequest(request)
            if results.count > 0 {
                nameLabel.text = results[0].valueForKey("name") as? String
                userImageView.image = UIImage(data: (results[0].valueForKey("userPhoto") as? NSData)!, scale: 1.0)
            } else {
            }
        } catch {
            print("unable to get database user")
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
