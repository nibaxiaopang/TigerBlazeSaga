//
//  SettingViewController.swift
//  TigerBlazeSaga
//
//  Created by jin fu on 2024/12/30.
//

import UIKit

class TigerSettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func back(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}
