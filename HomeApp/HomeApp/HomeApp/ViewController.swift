//
//  ViewController.swift
//  HomeApp
//
//  Created by Shubham kumar on 06/06/19.
//  Copyright © 2019 Shubham. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    //var names: [String] = []
    var appliances: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Home Appliances!!"
        
        
        
        
        
        let backgroundImage = UIImage(named: "image.jpg")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        imageView.contentMode = .scaleAspectFill
        //tableView.backgroundColor = UIColor(displayP3Red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
        
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "Cell")
        
        
        
    // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        

        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Appliances")
        
        //3
        do {
            appliances = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    

    @IBAction func addData(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Enter Product Details", message: " ", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            
            //getting the input values from user
            let name = alertController.textFields?[0].text
            let brand = alertController.textFields?[1].text
            let amount = alertController.textFields?[2].text
            let purchaseDate = alertController.textFields?[3].text
            let billNumber = alertController.textFields?[4].text
            let warrantyExpiry = alertController.textFields?[5].text
            
            
            
            let nameToSave : String = "Product Name: " + "  " + name! + "\nBrand: " + "  " + brand! + "\nAmount:" + "  " + amount! + "\nPurchase Date:" + "  " + purchaseDate!  + "\nBill Number:" + "  " + billNumber! + "\nWarranty Expiry Date:" + "  " + warrantyExpiry!
            
            //self.names.append(nameToSave)
            self.save(name: nameToSave)
            self.tableView.reloadData()
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Product Name"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Brand Name"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Amount"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Purchase Date"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Bill Number"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Expiry of Warranty"
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        
        self.present(alertController, animated: true, completion: nil)
        
        
        }
    
     func save(name: String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "Appliances",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3
        person.setValue(name, forKeyPath: "name")
        
        // 4
        do {
            try managedContext.save()
         appliances.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

}




extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return appliances.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            let person = appliances[indexPath.row]
            let cell =
                tableView.dequeueReusableCell(withIdentifier: "Cell",
                                              for: indexPath)
            
            cell.textLabel?.numberOfLines = 0;
            cell.layer.borderWidth = 1.0
            cell.layer.borderColor = UIColor.green.cgColor
            cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
            
            cell.textLabel?.text =
                person.value(forKeyPath: "name") as? String
            return cell
    }
}

