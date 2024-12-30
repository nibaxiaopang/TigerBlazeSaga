//
//  ScoreViewController.swift
//  TigerBlazeSaga
//
//  Created by jin fu on 2024/12/30.
//


import UIKit

class TigerMoreGameViewController: UIViewController {

    
    @IBOutlet weak var highScoreLbl: UILabel!
    
    @IBOutlet weak var highScoreLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
 

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Update high score label whenever view appears
        let highScore = UserDefaults.standard.integer(forKey: "highScore")
        highScoreLbl.text = "High Score: \(highScore)"
        
        let score = UserDefaults.standard.integer(forKey: "HighScore")
        highScoreLable.text = "Score : \(score)"
    }
    
    @IBAction func back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
