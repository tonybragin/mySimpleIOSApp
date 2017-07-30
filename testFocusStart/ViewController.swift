//
//  ViewController.swift
//  testFocusStart
//
//  Created by TONY on 24/07/2017.
//  Copyright © 2017 TONY COMPANY. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableItem: UITableView!
    
    var messagesArray: NSArray = []
    
    enum socialEnum: String {
        case twitter = "https://upload.wikimedia.org/wikipedia/en/thumb/9/9f/Twitter_bird_logo_2012.svg/1259px-Twitter_bird_logo_2012.svg.png"
        case facebook = "https://facebookbrand.com/wp-content/themes/fb-branding/prj-fb-branding/assets/images/fb-art.png"
        case vkontakte = "https://upload.wikimedia.org/wikipedia/commons/thumb/2/21/VK.com-logo.svg/1024px-VK.com-logo.svg.png"
    }
    
    func getPathOfLogo(withNameOfSocial name: String) -> String {
        switch name {
        case "twitter":
            return socialEnum.twitter.rawValue
        case "facebook":
            return socialEnum.facebook.rawValue
        case "vkontakte":
            return socialEnum.vkontakte.rawValue
        
            
        default:
            return ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableItem.delegate = self
        tableItem.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        messagesArray = loadJson()!
        
        let dateSortDescriptor = NSSortDescriptor(key: "date", ascending: false, selector: #selector(NSString.localizedStandardCompare(_:)))
        messagesArray = (messagesArray as NSArray).sortedArray(using: [dateSortDescriptor]) as NSArray

    }
    
    //MARK: jsonHelper
    
    func loadJson() -> NSArray? {
        
        if let path = Bundle.main.path(forResource: "messages", ofType: "json") {
            do {
                let jsonData = try NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe)
                do {
                    let jsonResult: NSArray = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                    
                    return jsonResult
                    
                } catch {}
            } catch {}
        }
        
        return nil
    }
    
    
    //MARK: UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! itemCell
        
        cell.itemImg.isHidden = true
        cell.itemText.isHidden = true
        
        cell.itemDate.text = ((messagesArray.value(forKey: "date") as! NSArray).object(at: indexPath.row) as! String)
        cell.itemTitle.text = ((messagesArray.value(forKey: "title") as! NSArray).object(at: indexPath.row) as! String)
        
        let type = (messagesArray.value(forKey: "type") as! NSArray).object(at: indexPath.row) as! String
        
        if type == "text" {
            
            cell.itemText.isHidden = false
            cell.itemText.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.itemText.text = ((messagesArray.value(forKey: "content") as! NSArray).object(at: indexPath.row) as! String)
            
        } else if type == "image" {
            
            cell.itemImg.isHidden = false
            let url = URL(string: ((messagesArray.value(forKey: "source") as! NSArray).object(at: indexPath.row) as! String))
            
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    cell.itemImg.image = UIImage(data: data!)
                }
            }
            
        } else if type == "social" {
            
            cell.itemImg.isHidden = false
            let net = ((messagesArray.value(forKey: "network") as! NSArray).object(at: indexPath.row) as! String)
            let url = URL(string: getPathOfLogo(withNameOfSocial: net))
            
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    cell.itemImg.image = UIImage(data: data!)
                }
            }
        }
        
        return cell
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "cellToWeb", sender: indexPath.row)
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    //MARK: Data send

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let controller = segue.destination as? WebViewController {
            controller.typeWeb = ((messagesArray.value(forKey: "type") as! NSArray).object(at: sender! as! Int) as! String)
            if (controller.typeWeb != nil) {
                if (controller.typeWeb == "text") {
                    controller.contentWeb = ((messagesArray.value(forKey: "content") as! NSArray).object(at: sender! as! Int) as! String)
                } else {
                    controller.contentWeb = ((messagesArray.value(forKey: "source") as! NSArray).object(at: sender! as! Int) as! String)
                }
            }
        }
    }
    
}

