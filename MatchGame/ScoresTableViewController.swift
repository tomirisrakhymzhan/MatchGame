//
//  ScoresTableViewController.swift
//  MatchGame
//
//  Created by Томирис Рахымжан on 07/05/2024.
//

import UIKit

class ScoresTableViewController: UITableViewController {
    
    var dataSource : [Score] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Enable automatic row height
        tableView.rowHeight = 30.0
        dataSource = ScoresTableViewController.getAllScores()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScoresTableViewCell.reuseIdentifier, for: indexPath) as! ScoresTableViewCell

        // Configure the cell...
        let score = dataSource[indexPath.row]
        cell.configure(with: score.userName, seconds: score.seconds)
        return cell
    }

    static func getAllScores() -> [Score] {
        var result: [Score] = []
        let userDefaults = UserDefaults.standard
        if let data = userDefaults.object(forKey: "scores") as? Data {
            do {
                let decoder = JSONDecoder()
                result = try decoder.decode([Score].self, from: data)
            } catch {
                print("could'n decode given data to [Score] with error: \(error.localizedDescription)")
            }
        }
        return result
    }
    
    static func saveScore(score: Score) {
        let userScoreArray: [Score] = ScoresTableViewController.getAllScores() + [score]
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(userScoreArray)
            let userDefaults = UserDefaults.standard
            userDefaults.set(encodedData, forKey: "scores")
            
        } catch {
            print("Couldn't encode given [Score] into data with error: \(error.localizedDescription)")
        }
    }
}

class ScoresTableViewCell: UITableViewCell {

    static let reuseIdentifier = "ScoresTableViewCell"
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with userName: String, seconds: Int) {
            userNameLabel.text = userName
            timeLabel.text = "\(String(seconds)) sec"
        }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        // Reset cell state
        userNameLabel.text = nil
        timeLabel.text = nil
    }

}
