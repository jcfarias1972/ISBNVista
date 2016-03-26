//
//  TVCTableViewController.swift
//  ClimaYahoo
//
//  Created by Juan Carlos Farías Arredondo on 14/03/16.
//  Copyright © 2016 Comisión Federal de Electricidad DCS. All rights reserved.
//

import UIKit

class TVCTableViewController: UITableViewController {

    private var libros : Array<Array<String>> = Array<Array<String>>()
    
    @IBOutlet var lista: UITableView!
    @IBOutlet weak var isbn: UIBarButtonItem!
    
    @IBAction func agregar(sender: UIButton) {
        isbn.enabled = true
    }
    @IBAction func agregaLibro(sender: UITextField) {
        print(sender.text!)
        let titulo = sincrono(sender)
        if (titulo != ""){
            libros.append([titulo,sender.text!])
            sender.enabled = false
            lista.reloadData()
        }
        sender.text = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isbn.enabled = false
        
        //Caracas  VEXX0008
        //PAris    FRXX0076
        //Grenoble FRXX0153
        
        self.title = "Busca Libros..... "
        
        
        
        self.libros.append(["Programming Symposium","0387068597"])
        self.libros.append(["The Witching Hour","9781425723705"])
        self.libros.append(["Beginning iOS game development","9781118107324"])
        self.libros.append(["Learning iOS Programming","9781449303778"])
        self.libros.append(["AndroidTM","9780071599894"])
        self.libros.append(["Cien años de soledad","9788437604947"])
        
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
        return self.libros.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Celda", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.text = "\(indexPath.row + 1). " + self.libros[indexPath.row][0]
        
        if (indexPath.row%2)==0{
            cell.backgroundColor = UIColor(red: 240/255, green: 248/255, blue: 255/255, alpha: 1)
        }else{
            cell.backgroundColor = UIColor(red: 255/255, green: 245/255, blue: 238/255, alpha: 1)
        }
        //#F0F8FF  240, 248, 255
        //#FFF5EE  255, 245, 238

        return cell
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let cc = segue.destinationViewController as! ControlCiudad
        
        let ip =  self.tableView.indexPathForSelectedRow
        
        cc.codigo = self.libros[ip!.row][1]
        
    }
    
    func sincrono(textoBuscar: UITextField) -> String{
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(textoBuscar.text!)"
        let url = NSURL(string: urls)
        let datos:NSData? = NSData(contentsOfURL: url!)
        var titulo = ""
        
        if datos == nil {
            
            let alerta = UIAlertController(title: "¡ Error en la red !",
                message: "Verifique su conexión.",
                preferredStyle: UIAlertControllerStyle.Alert)
            let accion2 = UIAlertAction(title: "OK",
                style: UIAlertActionStyle.Cancel) { _ in
            }
            alerta.addAction(accion2)
            self.presentViewController(alerta, animated: true, completion: nil)
            //imgPortada.image = nil
            //lblAutor.text = ""
            //lblTitulo.text = ""
            
        }else{
            let texto = NSString(data:datos!, encoding:NSUTF8StringEncoding)
            if texto == "{}"{
                let alerta = UIAlertController(title: "¡ Inexistente !",
                    message: "Verifique su ISBN",
                    preferredStyle: UIAlertControllerStyle.Alert)
                let accion2 = UIAlertAction(title: "OK",
                    style: UIAlertActionStyle.Cancel) { _ in
                }
                alerta.addAction(accion2)
                self.presentViewController(alerta, animated: true, completion: nil)
                //imgPortada.image = nil
                //lblAutor.text = ""
                //lblTitulo.text = ""
                titulo=""
            }else{
                
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                    let dic1 = json as! NSDictionary
                    let dic2 = dic1["ISBN:\(textoBuscar.text!)"] as! NSDictionary
                    //let dic3 = dic2["authors"]
                    
                    //let totAutores = dic3!.count
                    //lblAutor.text = "";
                    //autor=""
                    //for var x=0 ; x<totAutores; ++x{
                      //  lblAutor.text = lblAutor.text! + "\(dic3![0]["name"] as! String); "
                    //}
                    
                    //let dic4 = dic2["publishers"]
                    //lblTitulo.text = dic2["title"] as! NSString as String
                    titulo = dic2["title"] as! NSString as String
                    
                    /*let dic4 = dic2["cover"]
                    if dic4 != nil {
                        let cover : String? = dic4!["medium"] as! NSString as String
                        
                        if cover != nil{
                            let urls2 = cover
                            let url2 = NSURL(string: urls2!)
                            let datos2:NSData? = NSData(contentsOfURL: url2!)
                            //imgPortada.image = UIImage(data: datos2!)
                            //disolver()
                        }else{
                            //imgPortada.image = UIImage(contentsOfFile: "sin-imagen.jpg")
                            print("Sin portada 1")
                        }
                    }else{
                        //imgPortada.image = UIImage(named: "sin-imagen.jpg")
                        //disolver()
                        
                        print("Sin portada 2")
                    }*/
                }catch _ {
                    
                }
            }
            
        }
        return titulo
        /*
        //9780071599894         con portada
        //978-84-376-0494-7     sin portada
        */
    }

}
