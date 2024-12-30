//
//  TigerDashVC.swift
//  TigerBlazeSaga
//
//  Created by TigerBlazeSaga on 2024/12/30.
//


import UIKit

class TigerDashViewController: UIViewController {

    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var movesLbl: UILabel!
    @IBOutlet weak var GameView: UIView!

    // Game Elements
    var tiger: UIImageView!
    var gridTiles: [[UIImageView?]] = []
    var gridSize = 5
    var tileSize: CGFloat = 0
    var score = 0
    var moves = 20
    var level = 1
    var currentTigerPosition = (x: 0, y: 0)
    var previousScore: Int = UserDefaults.standard.integer(forKey: "totalScore")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showGameRules()
        setupGame()
        
    }
    
    func showGameRules() {
        let rules = """
        🐯 Tiger Dash Rules 🐯
        
        1. Swipe to move the tiger across the grid.
        2. Collect food (+10 points).
        3. Avoid rocks (Game Over).
        4. Beware of predators (-3 moves).
        5. Step on traps to lose points.
        6. Use health boosts (+5 moves) and speed boosts (+1 move) wisely.
        7. Complete the level by collecting all the food.
        """
        
        let alert = UIAlertController(title: "Game Rules", message: rules, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Got It!", style: .default, handler: nil))
        present(alert, animated: true)
    }


    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupGame() {
        // Calculate tile size based on GameView dimensions
        tileSize = GameView.bounds.width / CGFloat(gridSize)

        // Clear previous grid
        gridTiles.forEach { row in
            row.forEach { $0?.removeFromSuperview() }
        }
        gridTiles.removeAll()

        // Generate the grid in GameView
        for row in 0..<gridSize {
            var tileRow: [UIImageView?] = []
            for col in 0..<gridSize {
                let tile = UIImageView(frame: CGRect(x: CGFloat(col) * tileSize, y: CGFloat(row) * tileSize, width: tileSize, height: tileSize))
                tile.layer.borderWidth = 1
                tile.layer.borderColor = UIColor.darkGray.cgColor
                tileRow.append(tile)
                GameView.addSubview(tile)
            }
            gridTiles.append(tileRow)
        }

        // Add the tiger to the GameView
        tiger = UIImageView(image: UIImage(named: "tiger"))
        tiger.frame = CGRect(x: 0, y: 0, width: tileSize, height: tileSize)
        tiger.contentMode = .scaleAspectFit
        GameView.addSubview(tiger)

        // Set initial labels
        scoreLbl.text = "Score: \(score)"
        movesLbl.text = "Moves: \(moves)"

        // Populate grid with objects
        populateGrid()

        // Add swipe gestures
        addSwipeGestures()
    }

    func populateGrid() {
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                // Skip the tiger's initial position
                if row == 0 && col == 0 { continue }

                // Randomly assign objects to the grid
                let random = Int.random(in: 1...10)
                if random <= 3 {
                    gridTiles[row][col]?.image = UIImage(named: "rock") // Obstacle
                } else if random <= 5 {
                    gridTiles[row][col]?.image = UIImage(named: "food") // Food
                } else if random == 6 {
                    gridTiles[row][col]?.image = UIImage(named: "predator") // Predator
                } else if random == 7 {
                    gridTiles[row][col]?.image = UIImage(named: "trap") // Trap
                } else if random == 8 {
                    gridTiles[row][col]?.image = UIImage(named: "health_boost") // Health Boost
                } else if random == 9 {
                    gridTiles[row][col]?.image = UIImage(named: "speed_boost") // Speed Boost
                }
            }
        }
    }

    func addSwipeGestures() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeLeft.direction = .left
        GameView.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRight.direction = .right
        GameView.addGestureRecognizer(swipeRight)

        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeUp.direction = .up
        GameView.addGestureRecognizer(swipeUp)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeDown.direction = .down
        GameView.addGestureRecognizer(swipeDown)
    }

    @objc func handleSwipe(gesture: UISwipeGestureRecognizer) {
        let (x, y) = currentTigerPosition
        var newX = x
        var newY = y

        // Determine new position based on swipe direction
        switch gesture.direction {
        case .left: newX = max(x - 1, 0)
        case .right: newX = min(x + 1, gridSize - 1)
        case .up: newY = max(y - 1, 0)
        case .down: newY = min(y + 1, gridSize - 1)
        default: break
        }

        // Check the target tile
        if let tile = gridTiles[newY][newX] {
            if tile.image == UIImage(named: "rock") {
                // Trigger game over if the tiger swipes towards a rock
                gameOver(reason: "You hit a rock!")
                return
            }

            // Update tiger's position
            tiger.frame.origin = tile.frame.origin
            currentTigerPosition = (newX, newY)

            // Check tile interaction
            if tile.image == UIImage(named: "food") {
                score += 10
                tile.image = nil
            } else if tile.image == UIImage(named: "predator") {
                moves -= 3
                tile.image = nil
            } else if tile.image == UIImage(named: "trap") {
                score = max(score - 5, 0)
                tile.image = nil
            } else if tile.image == UIImage(named: "health_boost") {
                moves += 5
                tile.image = nil
            } else if tile.image == UIImage(named: "speed_boost") {
                moves += 1
                tile.image = nil
            }

            // Update labels
            scoreLbl.text = "Score: \(score)"
            moves -= 1
            movesLbl.text = "Moves: \(moves)"

            // Check for game over or level completion
            if moves <= 0 {
                gameOver(reason: "Out of moves!")
            } else if isLevelComplete() {
                nextLevel()
            }
        }
    }

    func isLevelComplete() -> Bool {
        return gridTiles.flatMap { $0 }.allSatisfy { $0?.image != UIImage(named: "food") }
    }

    func nextLevel() {
        level += 1
        moves += 10
        setupGame()
    }

    func gameOver(reason: String) {
        // Get previous total score and print it
        let previousScore = UserDefaults.standard.integer(forKey: "totalScore")
        print("Previous total score: \(previousScore)")
        
        // Add current game score to total score
        let newTotalScore = previousScore + score
        print("Current game score: \(score)")
        print("New total score: \(newTotalScore)")
        
        // Save new total score
        UserDefaults.standard.setValue(newTotalScore, forKey: "totalScore")
        UserDefaults.standard.synchronize()
        
        // Verify the save
        let savedScore = UserDefaults.standard.integer(forKey: "totalScore")
        print("Verified saved score: \(savedScore)")
        
        let alert = UIAlertController(title: "Game Over", 
                                    message: "\(reason)\nGame Score: \(score)\nTotal Score: \(newTotalScore)", 
                                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Play Again", style: .default, handler: { _ in
            self.resetGame()
        }))
        present(alert, animated: true)
    }

    func resetGame() {
        score = 0
        moves = 20
        level = 1
        currentTigerPosition = (x: 0, y: 0)
        scoreLbl.text = "Score: \(score)"
        movesLbl.text = "Moves: \(moves)"
        setupGame()
    }
}
