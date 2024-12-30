//
//  AboutViewController.swift
//  TigerBlazeSaga
//
//  Created by jin fu on 2024/12/30.
//


import UIKit

class TigerBlazeAboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func back(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}
