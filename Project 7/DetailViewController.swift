//
//  DetailViewController.swift
//  Project 7
//
//  Created by Андрей Бучевский on 06.09.2021.
//

import UIKit
import WebKit
class DetailViewController: UIViewController {
    
    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "credit", style: .done, target: self, action: #selector(buttonTapped))
        

        guard let detailItem = detailItem else { return }
        
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 150%; } </style>
        </head>
        <body>
        \(detailItem.body)
        </body>
        </html>
        """

        webView.loadHTMLString(html, baseURL: nil)
        
    }
    
    @objc func buttonTapped() {
        let alert = UIAlertController(title: "Data is valid", message: "The data comes from the We The People API of the Whitehouse.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }

}
