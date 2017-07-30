//
//  WebViewController.swift
//  testFocusStart
//
//  Created by TONY on 24/07/2017.
//  Copyright © 2017 TONY COMPANY. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var lableWeb: UILabel!
    @IBOutlet weak var imageViewWeb: UIImageView!
    
    
    var typeWeb: String?
    var contentWeb: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.isHidden = true
        imageViewWeb.isHidden = true
        lableWeb.isHidden = true

        lableWeb.lineBreakMode = NSLineBreakMode.byWordWrapping

        
        if typeWeb == "text" {
            
            self.lableWeb.text = self.contentWeb!
            lableWeb.isHidden = false
            
        } else if typeWeb == "image" {
            
            let url = URL(string: contentWeb!)
            
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    self.imageViewWeb.image = UIImage(data: data!)
                }
            }
            imageViewWeb.isHidden = false
            
        } else if typeWeb == "social" {
            
            let url = URL(string: contentWeb!)
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    self.webView.loadRequest(URLRequest(url: url!))
                }
            }
            webView.isHidden = false
        }

    }
}
