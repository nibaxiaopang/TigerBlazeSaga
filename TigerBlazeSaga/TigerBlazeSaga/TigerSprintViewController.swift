//
//  TigerSprintVC.swift
//  TigerBlazeSaga
//
//  Created by jin fu on 2024/12/30.
//


import UIKit

class TigerSprintViewController: UIViewController {

    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var livesLbl: UILabel!
    @IBOutlet weak var proView: UIProgressView!
    
    // Game Elements
    var tigerCub: UIImageView!
    var prey: UIImageView!
    var predator: UIImageView!
    var shield: UIImageView!
    var goldenPrey: UIImageView!
    var obstacle: UIImageView!
    var timer: Timer?
    var score = 0
    var lives = 3
    var isShieldActive = false
    var isSpeedBoostActive = false
    var gameOver = false
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        //showGameRules()
        showGameRules()
    }
    
    func showGameRules() {
        let alert = UIAlertController(
            title: "Welcome to Tiger Sprint!",
            message: """
            🐾 Game Rules:
            - Move the tiger cub using touch gestures.
            - Collect prey (+10 points) and golden prey (+50 points).
            - Avoid predators and obstacles to prevent losing lives.
            - Use shields to protect yourself for 5 seconds.
            - The game ends when you lose all 3 lives.

            Good luck and enjoy the sprint! 🐅
            """,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Start Game", style: .default, handler: { _ in
            self.setupGame()
        }))
        self.present(alert, animated: true, completion: nil)
    }

    func setupGame() {
        // Set background
        let backgroundImage = UIImageView(frame: self.view.frame)
        backgroundImage.image = UIImage(named: "jungle_background")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.addSubview(backgroundImage)

        // Add Tiger Cub
        tigerCub = UIImageView(image: UIImage(named: "tiger_cub"))
        tigerCub.frame = CGRect(x: 50, y: self.view.frame.height - 150, width: 100, height: 100)
        tigerCub.contentMode = .scaleAspectFit
        self.view.addSubview(tigerCub)

        // Add Prey
        prey = UIImageView(image: UIImage(named: "prey"))
        prey.frame = CGRect(x: Int.random(in: 50...300), y: 100, width: 80, height: 80)
        prey.contentMode = .scaleAspectFit
        self.view.addSubview(prey)

        // Add Golden Prey
        goldenPrey = UIImageView(image: UIImage(named: "golden_prey"))
        goldenPrey.frame = CGRect(x: Int.random(in: 50...300), y: -200, width: 80, height: 80)
        goldenPrey.contentMode = .scaleAspectFit
        self.view.addSubview(goldenPrey)

        // Add Predator
        predator = UIImageView(image: UIImage(named: "predator"))
        predator.frame = CGRect(x: Int.random(in: 50...300), y: 300, width: 100, height: 100)
        predator.contentMode = .scaleAspectFit
        self.view.addSubview(predator)

        // Add Shield
        shield = UIImageView(image: UIImage(named: "shield"))
        shield.frame = CGRect(x: Int.random(in: 50...300), y: -200, width: 80, height: 80)
        shield.contentMode = .scaleAspectFit
        self.view.addSubview(shield)

        // Add Obstacle
        obstacle = UIImageView(image: UIImage(named: "rock"))
        obstacle.frame = CGRect(x: Int.random(in: 50...300), y: -150, width: 80, height: 80)
        obstacle.contentMode = .scaleAspectFit
        self.view.addSubview(obstacle)

        // Update score and lives
        updateUI()

        // Add Gesture Recognizer for movement
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        self.view.addGestureRecognizer(panGesture)

        // Start Game Timer
        timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(moveElements), userInfo: nil, repeats: true)
    }

    @objc func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        let speedMultiplier: CGFloat = isSpeedBoostActive ? 2.0 : 1.0
        let newX = tigerCub.center.x + translation.x * speedMultiplier
        let newY = tigerCub.center.y + translation.y * speedMultiplier

        if newX > 0 && newX < self.view.frame.width && newY > 0 && newY < self.view.frame.height {
            tigerCub.center = CGPoint(x: newX, y: newY)
        }

        sender.setTranslation(.zero, in: self.view)
    }

    @objc func moveElements() {
        // Move Prey
        prey.center.y += 3
        if prey.center.y > self.view.frame.height {
            prey.center = CGPoint(x: Int.random(in: 50...300), y: 0)
        }

        // Move Golden Prey
        goldenPrey.center.y += 2
        if goldenPrey.center.y > self.view.frame.height {
            goldenPrey.center = CGPoint(x: Int.random(in: 50...300), y: -200)
        }

        // Move Predator
        predator.center.y += 4 + CGFloat(score / 10)
        if predator.center.y > self.view.frame.height {
            predator.center = CGPoint(x: Int.random(in: 50...300), y: 0)
        }

        // Move Shield
        shield.center.y += 3
        if shield.center.y > self.view.frame.height {
            shield.center = CGPoint(x: Int.random(in: 50...300), y: -200)
        }

        // Move Obstacle
        obstacle.center.y += 4
        if obstacle.center.y > self.view.frame.height {
            obstacle.center = CGPoint(x: Int.random(in: 50...300), y: -150)
        }

        checkCollisions()
    }

    func checkCollisions() {
        guard !gameOver else { return }

        // Check collision with prey
        if tigerCub.frame.intersects(prey.frame) {
            score += 10
            prey.center = CGPoint(x: Int.random(in: 50...300), y: 0)
        }

        // Check collision with golden prey
        if tigerCub.frame.intersects(goldenPrey.frame) {
            score += 50
            goldenPrey.center = CGPoint(x: Int.random(in: 50...300), y: -200)
        }

        // Check collision with shield
        if tigerCub.frame.intersects(shield.frame) {
            isShieldActive = true
            shield.center = CGPoint(x: Int.random(in: 50...300), y: -200)
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.isShieldActive = false
            }
        }

        // Check collision with predator
        if tigerCub.frame.intersects(predator.frame) {
            if isShieldActive {
                predator.center = CGPoint(x: Int.random(in: 50...300), y: 0)
            } else {
                lives -= 1
                predator.center = CGPoint(x: Int.random(in: 50...300), y: 0)
                if lives == 0 {
                    gameOver = true
                    showGameOver()
                }
            }
        }

        // Check collision with obstacle
        if tigerCub.frame.intersects(obstacle.frame) {
            lives -= 1
            obstacle.center = CGPoint(x: Int.random(in: 50...300), y: -150)
            if lives == 0 {
                gameOver = true
                showGameOver()
            }
        }

        updateUI()
    }

    func updateUI() {
        scoreLbl.text = "Score: \(score)"
        livesLbl.text = "Lives: \(lives)"
        proView.progress = Float(lives) / 3.0
        proView.tintColor = lives > 1 ? .green : .red
    }

    @IBAction func Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showGameOver() {
        timer?.invalidate()
        timer = nil
        
        // Save score if it's higher than current high score
        let highScore = defaults.integer(forKey: "highScore")
        if score > highScore {
            defaults.set(score, forKey: "highScore")
        }
        
        // Go back to HomeVC
        self.navigationController?.popViewController(animated: true)
    }

    func restartGame() {
        score = 0
        lives = 3
        isShieldActive = false
        isSpeedBoostActive = false
        gameOver = false
        tigerCub.center = CGPoint(x: 50, y: self.view.frame.height - 150)
        prey.center = CGPoint(x: Int.random(in: 50...300), y: 100)
        goldenPrey.center = CGPoint(x: Int.random(in: 50...300), y: -200)
        predator.center = CGPoint(x: Int.random(in: 50...300), y: 300)
        shield.center = CGPoint(x: Int.random(in: 50...300), y: -200)
        obstacle.center = CGPoint(x: Int.random(in: 50...300), y: -150)
        updateUI()
        timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(moveElements), userInfo: nil, repeats: true)
    }
}
