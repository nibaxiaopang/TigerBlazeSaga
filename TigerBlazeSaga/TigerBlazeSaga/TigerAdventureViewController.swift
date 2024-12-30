//
//  TigerAdventureVC.swift
//  TigerBlazeSaga
//
//  Created by jin fu on 2024/12/30.
//


import UIKit
import AVFoundation

class TigerAdventureViewController: UIViewController {
    
    // Outlets for score label and health bar
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var proView: UIProgressView!
    
    // UI elements
    var tiger: UIImageView!
    var background: UIImageView!
    var gameTimer: Timer!
    var obstacles: [UIImageView] = []
    var powerUps: [UIImageView] = []
    var score = 0
    var lives = 3
    var gameSpeed: CGFloat = 2.5 // Reduced game speed
    var isInvincible = false
    var backgroundMusicPlayer: AVAudioPlayer?
    var highScore = UserDefaults.standard.integer(forKey: "HighScore")

    override func viewDidLoad() {
        super.viewDidLoad()
        showGameRules()
    }
    
    func showGameRules() {
        let rules = """
        Welcome to Tiger Adventure!

        - Swipe left or right to move the tiger.
        - Avoid obstacles to stay alive.
        - Collect power-ups:
          • Yellow: Score boost
          • Blue: Temporary shield
        - You have 3 lives. Losing all ends the game.
        - The game gets harder as your score increases.

        Good luck and have fun!
        """
        
        let alert = UIAlertController(title: "Game Rules", message: rules, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Start Game", style: .default, handler: { [self] _ in
            setupGame()
            startGame()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func setupGame() {
        // Set up the scrolling background
        background = UIImageView(image: UIImage(named: "background"))
        background.frame = view.bounds
        background.contentMode = .scaleAspectFill
        view.addSubview(background)
        
        // Add the tiger (player)
        tiger = UIImageView(image: UIImage(named: "tiger"))
        tiger.frame = CGRect(x: view.bounds.width / 2 - 75, y: view.bounds.height - 200, width: 150, height: 150)
        tiger.contentMode = .scaleAspectFit
        view.addSubview(tiger)
        
        // Initialize score and health bar
        scoreLbl.text = "Score: \(score)"
        proView.progress = 1.0
        
        // Add swipe gestures
        addSwipeGestures()
        
        // Start background music
        playBackgroundMusic()
    }
    
    func startGame() {
        // Start the timer for game loop
        gameTimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(gameLoop), userInfo: nil, repeats: true)
        
        // Add obstacles and power-ups at intervals
        Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(addObstacle), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(addPowerUp), userInfo: nil, repeats: true)
    }
    
    @objc func gameLoop() {
        moveTiger()
        moveObjects()
        moveBackground()
        detectCollisions()
        increaseDifficulty()
    }
    
    func moveTiger() {
        tiger.frame.origin.y -= 2
        if tiger.frame.origin.y < 0 {
            tiger.frame.origin.y = view.bounds.height - 200
        }
    }
    
    func moveObjects() {
        for obstacle in obstacles {
            obstacle.frame.origin.y += gameSpeed
        }
        
        for powerUp in powerUps {
            powerUp.frame.origin.y += gameSpeed
        }
        
        obstacles.removeAll { $0.frame.origin.y > view.bounds.height }
        powerUps.removeAll { $0.frame.origin.y > view.bounds.height }
    }
    
    func moveBackground() {
        background.frame.origin.y += CGFloat(gameSpeed / 2)
        if background.frame.origin.y >= 0 {
            background.frame.origin.y = -view.bounds.height
        }
    }
    
    func detectCollisions() {
        for obstacle in obstacles {
            if tiger.frame.intersects(obstacle.frame) && !isInvincible {
                loseLife()
                obstacle.removeFromSuperview()
                obstacles.removeAll { $0 == obstacle }
                return
            }
        }
        
        for (index, powerUp) in powerUps.enumerated() {
            if tiger.frame.intersects(powerUp.frame) {
                handlePowerUp(type: powerUp.tag)
                powerUp.removeFromSuperview()
                powerUps.remove(at: index)
            }
        }
    }
    
    func handlePowerUp(type: Int) {
        if type == 1 {
            score += 20
            scoreLbl.text = "Score: \(score)"
        } else if type == 2 {
            activateShield()
        }
    }
    
    func activateShield() {
        isInvincible = true
        tiger.alpha = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.isInvincible = false
            self.tiger.alpha = 1.0
        }
    }
    
    func loseLife() {
        lives -= 1
        proView.progress = Float(lives) / 3.0
        if lives <= 0 {
            gameOver()
        }
    }
    
    func increaseDifficulty() {
        if score % 50 == 0 && gameSpeed < 10.0 {
            gameSpeed += 0.2
        }
    }
    
    func playBackgroundMusic() {
        if let url = Bundle.main.url(forResource: "background_music", withExtension: "mp3") {
            backgroundMusicPlayer = try? AVAudioPlayer(contentsOf: url)
            backgroundMusicPlayer?.numberOfLoops = -1
            backgroundMusicPlayer?.play()
        }
    }
    
    @objc func addObstacle() {
        let obstacle = UIImageView(image: UIImage(named: "obstacle"))
        obstacle.frame = CGRect(x: CGFloat.random(in: 0...(view.bounds.width - 100)), y: -100, width: 100, height: 100)
        obstacle.contentMode = .scaleAspectFit
        view.addSubview(obstacle)
        obstacles.append(obstacle)
    }
    
    @objc func addPowerUp() {
        let powerUp = UIImageView(image: UIImage(named: "powerup"))
        powerUp.tag = Int.random(in: 1...2)
        powerUp.frame = CGRect(x: CGFloat.random(in: 0...(view.bounds.width - 75)), y: -75, width: 75, height: 75)
        powerUp.contentMode = .scaleAspectFit
        view.addSubview(powerUp)
        powerUps.append(powerUp)
    }
    
    func addSwipeGestures() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }
    
    @objc func handleSwipe(gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left && tiger.frame.origin.x > 0 {
            tiger.frame.origin.x -= 75
        } else if gesture.direction == .right && tiger.frame.origin.x < view.bounds.width - tiger.frame.width {
            tiger.frame.origin.x += 75
        }
    }
    
    func gameOver() {
        gameTimer.invalidate()
        backgroundMusicPlayer?.stop()
        
        // Update high score if current score is higher
        if score > highScore {
            highScore = score
            UserDefaults.standard.set(highScore, forKey: "HighScore")
        }
        
        let alert = UIAlertController(
            title: "Game Over",
            message: "Your score: \(score)\nHigh Score: \(highScore)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Play Again", style: .default, handler: { _ in
            self.resetGame()
        }))
        present(alert, animated: true)
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func resetGame() {
        score = 0
        lives = 3
        gameSpeed = 2.5
        scoreLbl.text = "Score: \(score)"
        proView.progress = 1.0
        tiger.frame.origin = CGPoint(x: view.bounds.width / 2 - 75, y: view.bounds.height - 200)
        obstacles.forEach { $0.removeFromSuperview() }
        powerUps.forEach { $0.removeFromSuperview() }
        obstacles.removeAll()
        powerUps.removeAll()
        startGame()
    }
}
