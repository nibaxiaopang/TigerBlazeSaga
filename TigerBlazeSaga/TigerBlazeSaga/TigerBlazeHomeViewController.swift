//
//  HomeVC.swift
//  TigerBlazeSaga
//
//  Created by jin fu on 2024/12/30.
//


import UIKit

class TigerBlazeHomeViewController: UIViewController {
    
    @IBOutlet weak var historyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let totalScore = UserDefaults.standard.integer(forKey: "totalScore")
        historyLabel.text = "Total Score: \(totalScore)"
    }
}
