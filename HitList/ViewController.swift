//
//  ViewController.swift
//  HitList
//
//  Created by _m on 10/16/14.
//  Copyright (c) 2014 altolabs. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {
  @IBOutlet weak var tableView: UITableView!

  var people = [NSManagedObject]()

  @IBAction func addName(sender: AnyObject) {
    var alert = UIAlertController(
      title: "New name",
      message: "Add a new name",
      preferredStyle: .Alert
    )

    let saveAction = UIAlertAction(title: "Save", style: .Default) {
      (action: UIAlertAction!) -> Void in

      let textField = alert.textFields![0] as UITextField
      self.saveName(textField.text)
      self.tableView.reloadData()
    }

    let cancelAction = UIAlertAction(title: "Cancel", style: .Default) {
      (action: UIAlertAction!) -> Void in
    }

    alert.addTextFieldWithConfigurationHandler {
      (textField: UITextField!) -> Void in
    }

    alert.addAction(saveAction)
    alert.addAction(cancelAction)

    presentViewController(
      alert,
      animated: true,
      completion: nil
    )
  }

  func saveName(name: String) {
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    let managedContext = appDelegate.managedObjectContext!

    let entity = NSEntityDescription.entityForName(
      "Person",
      inManagedObjectContext: managedContext
    )

    let person = NSManagedObject(
      entity: entity!,
      insertIntoManagedObjectContext: managedContext
    )

    person.setValue(name, forKey: "name")

    var error: NSError?
    if !managedContext.save(&error) {
      println("Could not save \(error), \(error?.userInfo)")
    }

    people.append(person)
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return people.count
  }

  func tableView(tableView: UITableView,
    cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
      as UITableViewCell

    let person = people[indexPath.row]
    cell.textLabel!.text = person.valueForKey("name") as String?

    return cell
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    let managedContext = appDelegate.managedObjectContext!
    let fetchRequest = NSFetchRequest(entityName: "Person")

    var error: NSError?

    let fetchedResults = managedContext.executeFetchRequest(fetchRequest,
      error: &error) as [NSManagedObject]?

    if let results = fetchedResults {
      people = results
    } else {
      println("Could not fetch results \(error), \(error!.userInfo)")
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "\"The List\""
    tableView.registerClass(
      UITableViewCell.self,
      forCellReuseIdentifier: "Cell"
    )
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

