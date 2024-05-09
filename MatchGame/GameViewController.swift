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
    var previousCard : (Int, String)? = (1, "")
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
                score += 1
                disableButton(withTag: previous.0)
                disableButton(withTag: cardIndex)
                previousCard = nil
                checkWin()
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
        for index in 1..<17 {
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
        for index in 1..<17 {
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
            states[index+1] = cardPool[index]
        }
        print(states)
    }
    
    func turnGridToAllBlue() {
        for tag in 1...16{
            if let button = view.viewWithTag(tag) as? UIButton {
                button.setBackgroundImage(UIImage(named: "blue"), for: .disabled)
            }
        }
    }
    
    func disableAllGridButtons(){
        for tag in 1...16{
            if let button = view.viewWithTag(tag) as? UIButton {
                button.isEnabled = false
            }
        }
    }
    
    func enableAllGridButtons(){
        for tag in 1...16{
            if let button = view.viewWithTag(tag) as? UIButton {
                button.isEnabled = true
            }
        }
    }
    
    func checkWin(){
        if allCardsMatched(){
            stopTimer()
            print("score \(score)")
            showAlert()
        }
    }
    
    func allCardsMatched() -> Bool {
        for buttonIndex in 0..<16 {
            if let button = view.viewWithTag(buttonIndex) as? UIButton {
                if button.isEnabled {
                    return false
                }
            }
        }
        return true
    }
    
    func showAlert(){
        let alertController = UIAlertController(title: "Game Over", message: "Your finished matching cards in: \(self.secondsElapsed) sec", preferredStyle: .alert)
        alertController.addTextField(){textfield in
            textfield.placeholder = "Enter your name"
            
        }
        
        let saveName = UIAlertAction(title: "Save", style: .default) {_ in
            guard let textField1 = alertController.textFields?.first else {
                print("Textfield does not exist")
                return
            }
            guard let name = textField1.text, !name.isEmpty else{
                print("Name field is empty")
                return
            }
            print(name)
            self.saveUserScoreAsStruct(name: name)
        }
        alertController.addAction(saveName)
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive){_ in
            print("cancelled")
        }
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
    
    func saveUserScoreAsStruct(name: String){
        let userScore = Score(userName: name, seconds: secondsElapsed)
        ScoresTableViewController.saveScore(score: userScore)
    }

}
