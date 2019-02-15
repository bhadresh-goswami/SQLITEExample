//
//  ViewController.swift
//  SQLITEExample
//
//  Created by Mac on 15/02/19.
//  Copyright © 2019 bhadresh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var dbHelperObj:dbHelper!
    var infoList = [[String:Any]]()
    
    @IBOutlet weak var tableInfo: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbHelperObj = dbHelper()
        infoList = dbHelperObj.Execute(SQLQuery: "Select * from tblInfo")
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtId: UITextField!
    var EditData = [String:Any]()

    @IBAction func SaveData(_ sender: UIButton) {
        var cmd = ""
        if(EditData.keys.count == 0)
        {
            //insert
            cmd = "insert into tblInfo(id,name) values(\(txtId.text!),'\(txtName.text!)')"
            
        }
        else{
            //update
            cmd = "update tblInfo set name = '\(txtName.text!)' where id = \(txtId.text!)"
            txtId.text = ""
            txtName.text = ""
            EditData = [String:Any]()
        }
        
        if dbHelperObj.Execute(SQLCommnad: cmd)
        {
            print("Inserted!")
        }
        else{
            print("Not Inserted!")
        }
        
        infoList = dbHelperObj.Execute(SQLQuery: "Select * from tblInfo")
        
        tableInfo.reloadData()
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "\(infoList[indexPath.row]["id"]!)"
        cell.detailTextLabel?.text = "\(infoList[indexPath.row]["name"]!)"
        
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if dbHelperObj.Execute(SQLCommnad: "delete from tblInfo where id = \(infoList[indexPath.row]["id"]!)")
            {
                print("deleted!")
            }
            else{
                print("Not delete!")
            }
            
            infoList = dbHelperObj.Execute(SQLQuery: "Select * from tblInfo")
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        EditData = infoList[indexPath.row]
        txtName.text = "\(EditData["name"]!)"
        txtId.text = "\(EditData["id"]!)"
        
    }
}

