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
    
    @IBOutlet weak var cardButton: UIButton!
    
    
    @IBOutlet weak var playBtn: UIButton!
    
    var timer : Timer?
    var score = 0
    var countSeconds = 0
    var countMoves = 0
    var countMistakes = 0
    var isPlaying = false
    var carToCompare : (Int, String) = (0, "")
    var states = Dictionary<Int, String>()
    
    let formulaOneCars = ["ferrari", "mercedes", "redbull", "maclaren", "alpine", "astonmartin", "haas", "sauber"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    
    @IBAction func cardPressed(_ sender: UIButton) {
        if isPlaying == true {
            let tag = sender.tag
            let openedCar : (Int, String) = (tag, states[tag]!)
            
            sender.setBackgroundImage(UIImage(named: openedCar.1), for: .normal)
    
            countMoves += 1
            if countMoves % 2 == 0 {
                //check pair
                if carToCompare.1 == openedCar.1 {
                    score += 1
                    //disable opened cards
                    if let curButton = self.cardButton.viewWithTag(carToCompare.0) as? UIButton{
                        curButton.isEnabled = false
                        sender.isEnabled = false
                    }
                } else {
                    countMistakes += 1
                    if let curButton = view.viewWithTag(carToCompare.0) as? UIButton{
                        curButton.setBackgroundImage(UIImage(named: "blue"), for: .normal)
                        sender.setBackgroundImage(UIImage(named: "blue"), for: .normal)
                    }
                    
                }
            } else {
                // save openedCar for future move check
                carToCompare = openedCar
                
            }
        }
        
    }
    
    @IBAction func playPressed(_ sender: UIButton) {
        sender.isEnabled = false
        sender.isHidden = true
        score = 0
        countSeconds = 0
        countMoves = 0
        countMistakes = 0
        isPlaying = true
        //init the grid
        initializeGame()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
            self.countSeconds += 1
            self.timerLabel.text = "\(self.countSeconds) sec"
            self.movesLabel.text = "Moves: \(self.countMoves)"
            self.mistakesLabel.text = "Mistakes: \(self.countMistakes)"


            print("Timer fired \(self.countSeconds)")
        })
    }
    
    
    @IBAction func resetPressed(_ sender: Any) {
        playBtn.isEnabled = true
        playBtn.isHidden = false
        stopTimer()
        score = 0
        countSeconds = 0
        countMoves = 0
        countMistakes = 0
        isPlaying = false
        turnGridToAllBlue()
        disableAllGridButtons()
        print("Reset game")
    }
    
    func stopTimer(){
        timer?.invalidate()
        timer = nil
    }
    deinit {
        stopTimer()
    }
    func generateRandomGridStates() {
        var carPool = [String]()
        for car in formulaOneCars{
            carPool.append(car)
            carPool.append(car)
        }
        carPool.shuffle()
        
        var carPoolIndex = 0
        for i in 0...15 {
            states[i] = carPool[carPoolIndex]
            carPoolIndex += 1
        }
    }
    
    func initializeGame(){
        if isPlaying == false {
            turnGridToAllBlue()
            disableAllGridButtons()
        } else if isPlaying == true {
            generateRandomGridStates()
            enableAllGridButtons()
            turnGridToAllBlue()
        }
    }
    
    func turnGridToAllBlue() {
        for tag in 0...15{
            if let button = view.viewWithTag(tag) as? UIButton {
                button.setBackgroundImage(UIImage(named: "blue"), for: .disabled)
            }
        }
    }
    
    func disableAllGridButtons(){
        var tag = 0
        for _ in 0...16{
            if let button = view.viewWithTag(tag) as? UIButton {
                button.isEnabled = false
                tag += 1
            }
        }
    }
    
    func enableAllGridButtons(){
        var tag = 0
        for _ in 0...16{
            if let button = view.viewWithTag(tag) as? UIButton {
                button.isEnabled = true
                tag += 1
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
