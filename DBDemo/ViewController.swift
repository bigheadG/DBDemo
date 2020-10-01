//
//  ViewController.swift
//  DBDemo
//
//  Created by 陳志宏 on 2020/10/2.
//  Copyright © 2020 Joybien Technologies. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    @IBOutlet weak var pTV: UITableView!
    
    let cellReuseIdentifier = "cell"
    
    var db:DB = DB()
    
    var persons:[Person] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pTV.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        persons = db.read()
    }
    var cnt = 0
    @IBAction func btnAction(_ sender: Any) {
        let nameA = ["Jack","John","Lily","Jack","Edward","Grace","Jack"]
        let ageA =  [  23,    24,    25,    23,    22,     23,   23]
        let dataA = [  "t0",  "t1",  "t2",  "t00",  "t2", "t2", "t000"]
        
        if cnt < nameA.count {
           db.insert(id: 0, name: nameA[cnt], age: ageA[cnt],data:dataA[cnt])
        }
        cnt += 1
        persons = db.read()
        self.pTV.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let r = indexPath.row
        cell.textLabel?.text = "id:" +  String(persons[r].id)  +   " name:" + persons[r].name + " age:" + String(persons[r].age) + " data:" + String(persons[r].data)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        
        return cell
    }
   
    
}

