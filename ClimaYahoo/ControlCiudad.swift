//
//  ControlCiudad.swift
//  ClimaYahoo
//
//  Created by Juan Carlos Farías Arredondo on 22/03/16.
//  Copyright © 2016 Comisión Federal de Electricidad DCS. All rights reserved.
//

import UIKit

class ControlCiudad: UIViewController {

    var codigo = ""
    
    @IBOutlet weak var lblTitulo: UITextField!
    @IBOutlet weak var lblAutor: UITextField!
    @IBOutlet weak var imgPortada: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sincrono(codigo)
        
        // Do any additional setup after loading the view.
    }
    
    func sincrono(textoBuscar: String){
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(textoBuscar)"
        let url = NSURL(string: urls)
        let datos:NSData? = NSData(contentsOfURL: url!)
        
        if datos == nil {
            
            let alerta = UIAlertController(title: "¡ Error en la red !",
                message: "Verifique su conexión.",
                preferredStyle: UIAlertControllerStyle.Alert)
            let accion2 = UIAlertAction(title: "OK",
                style: UIAlertActionStyle.Cancel) { _ in
            }
            alerta.addAction(accion2)
            self.presentViewController(alerta, animated: true, completion: nil)
            imgPortada.image = nil
            lblAutor.text = ""
            lblTitulo.text = ""
            
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
                imgPortada.image = nil
                lblAutor.text = ""
                lblTitulo.text = ""
            }else{
                
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                    let dic1 = json as! NSDictionary
                    let dic2 = dic1["ISBN:\(textoBuscar)"] as! NSDictionary
                    let dic3 = dic2["authors"]
                    
                    let totAutores = dic3!.count
                    lblAutor.text = "";
                    
                    for var x=0 ; x<totAutores; ++x{
                      lblAutor.text = lblAutor.text! + "\(dic3![0]["name"] as! String); "
                    }
                    
                    //let dic4 = dic2["publishers"]
                    lblTitulo.text = dic2["title"] as! NSString as String
                    
                    let dic4 = dic2["cover"]
                    if dic4 != nil {
                    let cover : String? = dic4!["medium"] as! NSString as String
                    
                    if cover != nil{
                    let urls2 = cover
                    let url2 = NSURL(string: urls2!)
                    let datos2:NSData? = NSData(contentsOfURL: url2!)
                    imgPortada.image = UIImage(data: datos2!)
                    //disolver()
                    }else{
                    imgPortada.image = UIImage(contentsOfFile: "sin-imagen.jpg")
                    print("Sin portada 1")
                    }
                    }else{
                    imgPortada.image = UIImage(named: "sin-imagen.jpg")
                    //disolver()
                    
                    print("Sin portada 2")
                    }
                }catch _ {
                    
                }
            }
            
        }
        /*
        //9780071599894         con portada
        //978-84-376-0494-7     sin portada
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
