//
//  GameViewController.swift
//  MatchGame
//
//  Created by Томирис Рахымжан on 07/05/2024.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var movesLabel: UILabel!
    
    @IBOutlet weak var mistakesLabel: UILabel!
    
    @IBOutlet weak var playBtn: UIButton!
    
    var timer : Timer?
    var score = 0
    var secondsElapsed = 0
    var countMoves = 0
    var countMistakes = 0
    var isPlaying = false
    var previousCard : (Int, String)? = (0, "")
    var states = Dictionary<Int, String>()
    
    let formulaOneCars = ["ferrari", "mercedes", "redbull", "maclaren", "alpine", "astonmartin", "haas", "sauber"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func playPressed(_ sender: UIButton) {
        startGame()
    }
    
    func startGame() {
        resetGame()
        setupNewGame()
        isPlaying = true
        playBtn.isHidden = true
        
        // Start timer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    @objc func updateTimer() {
        secondsElapsed += 1
        timerLabel.text = "\(secondsElapsed) sec"
    }
    func setupNewGame() {
        generateRandomCards()
        enableAllButtons()
        turnAllCardsBlue()
    }
    
    func resetGame() {
        stopTimer()
        secondsElapsed = 0
        countMoves = 0
        countMistakes = 0
        previousCard = nil
        states = [:]
        
        playBtn.isHidden = false
        
        // Reset UI elements
        timerLabel.text = "0 sec"
        movesLabel.text = "Moves: 0"
        mistakesLabel.text = "Mistakes: 0"
        turnAllCardsBlue()
        disableAllButtons()
    }
    
    func stopTimer(){
        timer?.invalidate()
        timer = nil
    }
    deinit {
        stopTimer()
    }
    
    
    @IBAction func cardPressed(_ sender: UIButton) {
        guard isPlaying else { return }
        let cardIndex = sender.tag
        guard let cardImage = states[cardIndex] else { return }
             
        sender.setBackgroundImage(UIImage(named: cardImage), for: .normal)

        if let previous = previousCard {
            countMoves += 1
            movesLabel.text = "Moves: \(countMoves)"
            
            if previous.1 == cardImage {
                // Cards match
                disableButton(withTag: previous.0)
                disableButton(withTag: cardIndex)
                previousCard = nil
            } else {
                // No match, increment mistakes count
                countMistakes += 1
                mistakesLabel.text = "Mistakes: \(countMistakes)"
                
                // Delay to flip the cards back
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    sender.setBackgroundImage(UIImage(named: "blue"), for: .normal)
                    self.flipButton(withTag: previous.0)
                    self.previousCard = nil
                }
            }
        } else {
            // Store the previous card for future comparison
            previousCard = (cardIndex, cardImage)
        }
        
    }
    
    func turnAllCardsBlue() {
        for index in 0..<16 {
            flipButton(withTag: index)
        }
    }
    
    func flipButton(withTag tag: Int) {
        if let button = view.viewWithTag(tag) as? UIButton {
            button.setBackgroundImage(UIImage(named: "blue"), for: .normal)
        }
    }
    
    func disableAllButtons() {
        setAllButtonsEnabled(false)
    }
    
    func enableAllButtons() {
        setAllButtonsEnabled(true)
    }
    
    func setAllButtonsEnabled(_ isEnabled: Bool) {
        for index in 0..<16 {
            if let button = view.viewWithTag(index) as? UIButton {
                button.isEnabled = isEnabled
            }
        }
    }
    
    func disableButton(withTag tag: Int) {
        if let button = view.viewWithTag(tag) as? UIButton {
            button.isEnabled = false
        }
    }
    
    @IBAction func resetPressed(_ sender: Any) {
        resetGame()
    }
    
    func generateRandomCards() {
        // Create a pool of images and shuffle it
        var cardPool = formulaOneCars + formulaOneCars
        cardPool.shuffle()
        
        // Assign images to card indices
        for index in 0..<16 {
            states[index] = cardPool[index]
        }
        print(states)
    }
    
    func turnGridToAllBlue() {
        for tag in 0...15{
            if let button = view.viewWithTag(tag) as? UIButton {
                button.setBackgroundImage(UIImage(named: "blue"), for: .disabled)
            }
        }
    }
    
    func disableAllGridButtons(){
        for tag in 0...15{
            if let button = view.viewWithTag(tag) as? UIButton {
                button.isEnabled = false
            }
        }
    }
    
    func enableAllGridButtons(){
        for tag in 0...15{
            if let button = view.viewWithTag(tag) as? UIButton {
                button.isEnabled = true
            }
        }
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
