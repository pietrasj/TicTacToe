//
//  SinglePlayerViewController.swift
//  TicTacToe
//
//  Created by Jayne Pietraszkiewicz on 2/4/17.
//  Copyright © 2017 Deakin. All rights reserved.
//
//  Reference: Wilson, S 2014, Swift Programming Tutorial Part 5: Making a Game (Tic Tac Toe with AI), YouTube, published 10 June 2014, retrieved 2 April 2017, <https://youtu.be/LkYpoRj-7hA>
//
//  The below code provides a more advanced AI than is expected for the assignment. I've had to adapted the original code from the above reference for newer versions of Swift.
//
//  Different images used in single player mode. This was to try out different UI look and feel.
//  If I wanted to extend this game more, adding an option to change the image sets would be the first thing I would add in.
//


import UIKit
import AVFoundation

class SinglePlayerViewController: UIViewController {

    @IBOutlet var ticTacImg1: UIImageView!
    @IBOutlet var ticTacImg2: UIImageView!
    @IBOutlet var ticTacImg3: UIImageView!
    @IBOutlet var ticTacImg4: UIImageView!
    @IBOutlet var ticTacImg5: UIImageView!
    @IBOutlet var ticTacImg6: UIImageView!
    @IBOutlet var ticTacImg7: UIImageView!
    @IBOutlet var ticTacImg8: UIImageView!
    @IBOutlet var ticTacImg9: UIImageView!
    
    @IBOutlet var ticTacBtn1: UIButton!
    @IBOutlet var ticTacBtn2: UIButton!
    @IBOutlet var ticTacBtn3: UIButton!
    @IBOutlet var ticTacBtn4: UIButton!
    @IBOutlet var ticTacBtn5: UIButton!
    @IBOutlet var ticTacBtn6: UIButton!
    @IBOutlet var ticTacBtn7: UIButton!
    @IBOutlet var ticTacBtn8: UIButton!
    @IBOutlet var ticTacBtn9: UIButton!
    
    @IBOutlet var resetBtn: UIButton!
    @IBOutlet weak var player1Score: UILabel!
    @IBOutlet weak var drawScore: UILabel!
    @IBOutlet weak var player2Score: UILabel!
    @IBOutlet weak var historyText: UITextView!
    @IBOutlet weak var musicBtn: UIButton!
    
    // declaring audio player for sound effects
    var audioPlayerSoundFX = AVAudioPlayer()
    // declaring audio player for music
    var audioPlayer = AVAudioPlayer()

    // initialise key:value pair dictionary. dictionary will hold sender (0 cpu, 1 player) and the tag of the button used.
    var plays = Dictionary<Int,Int>()
    var done = false
    var aiDeciding = false
    
    // score counter
    var p1Count = 0
    var p2Count = 0
    var drawCount = 0
    
    
    
    // any gameboard button clicked uses this action.
    @IBAction func UIButtonClicked(sender:UIButton) {
        // if game is not done and AI is not deciding on a move
        if !(plays[sender.tag] != nil) && !aiDeciding && !done {
            // set the image for player 1 (x)
            setImageForSpot(spot: sender.tag, player:1)
        }
        
        // check for the win after the move
        checkForWin()
        // AI can take it's turn
        aiTurn()
        
    }

    // function to set the image based on the button tag and player
    
    func setImageForSpot(spot:Int, player:Int) {
        // if player equal to 1 then place "ximage", otherwise place "oimage"
        let playerMark = player == 1 ? "2ndximage" : "2ndoimage"
        // key in dictonary set to player (0 CPU or 1 Player)
        plays[spot] = player
        switch spot {
        // set the image of x or o based on the player and what cell they chose and play soundFX
        case 1:
            ticTacImg1.image = UIImage(named: playerMark)
            playSound()
        case 2:
            ticTacImg2.image = UIImage(named: playerMark)
            playSound()
        case 3:
            ticTacImg3.image = UIImage(named: playerMark)
            playSound()
        case 4:
            ticTacImg4.image = UIImage(named: playerMark)
            playSound()
        case 5:
            ticTacImg5.image = UIImage(named: playerMark)
            playSound()
        case 6:
            ticTacImg6.image = UIImage(named: playerMark)
            playSound()
        case 7:
            ticTacImg7.image = UIImage(named: playerMark)
            playSound()
        case 8:
            ticTacImg8.image = UIImage(named: playerMark)
            playSound()
        case 9:
            ticTacImg9.image = UIImage(named: playerMark)
            playSound()
        default:
            ticTacImg5.image = UIImage(named: playerMark)
            playSound()
        }
    }
    
    // Action for reset button
    @IBAction func resetBtnClicked(sender: UIButton) {
        // game is no longer done
        done = false
        // reset function
        reset()
    }
    
    // reset button function
    func reset() {
        // reset the dictionary
        plays = [:]
        // reset images to blank
        ticTacImg1.image = nil
        ticTacImg2.image = nil
        ticTacImg3.image = nil
        ticTacImg4.image = nil
        ticTacImg5.image = nil
        ticTacImg6.image = nil
        ticTacImg7.image = nil
        ticTacImg8.image = nil
        ticTacImg9.image = nil
    }
    
    // check for win function
    func checkForWin () {
        // "I":0 CPU, "You":1 Player. Can use this later to form sentence for userMessage.
        let whoWon = ["I":0,"You":1]
        for(key,value) in whoWon {
            if ((plays[7] == value && plays[8] == value && plays[9] == value) || // bottom
                (plays[4] == value && plays[5] == value && plays[6] == value) || // horizontalmiddle
                (plays[1] == value && plays[2] == value && plays[3] == value) || // top
                (plays[1] == value && plays[4] == value && plays[7] == value) || // left
                (plays[2] == value && plays[5] == value && plays[8] == value) || // verticalmiddle
                (plays[3] == value && plays[6] == value && plays[9] == value) || // right
                (plays[1] == value && plays[5] == value && plays[9] == value) || // diagleftright
                (plays[3] == value && plays[5] == value && plays[7] == value)) // diagrightleft)
            {
                // if statement to advise who has won the game
                if key == "You" {
                    p1Count += 1
                    player1Score.text = "\(p1Count)"
                    print("You are the winner")
                    historyText.text = historyText.text + "\nYou Won!"
                }
                else
                {
                    p2Count += 1
                    player2Score.text = "\(p2Count)"
                    print("I am the winner")
                    historyText.text = historyText.text + "\nComputer Won!"
                }
                
                alertWinner(playerName: "\(key)")
                done = true
            }
        }
    }
    
    // check possible winning combinations
    func checkBottom(value:Int) -> (location:String,pattern:String) {
        return ("bottom", checkFor(value: value, inList: [7,8,9]))
    }
    
    func checkTop(value:Int) -> (location:String,pattern:String) {
        return ("top",checkFor(value: value, inList: [1,2,3]))
    }
    
    func checkMiddleAcross(value:Int) -> (location:String,pattern:String) {
        return ("middleAcross",checkFor(value: value, inList: [4,5,6]))
    }
    
    func checkMiddleDown(value:Int) -> (location:String,pattern:String) {
        return ("middleDown",checkFor(value: value, inList: [2,5,8]))
    }
    
    func checkLeft(value:Int) -> (location:String,pattern:String) {
        return ("left",checkFor(value: value, inList: [1,4,7]))
    }
    
    func checkRight(value:Int) -> (location:String,pattern:String) {
        return ("right",checkFor(value: value, inList: [3,6,9]))
    }
    
    func checkDiagLeftRight(value:Int) -> (location:String,pattern:String) {
        return ("diagLeftRight",checkFor(value: value, inList: [1,5,9]))
    }
    
    func checkDiagRightLeft(value:Int) -> (location:String,pattern:String) {
        return ("diagRightLeft",checkFor(value: value, inList: [3,5,7]))
    }
    
    
    // check for the pattern, eg 011, 110, 101
    func checkFor(value:Int, inList:[Int]) -> String {
        var conclusion = ""
        for cell in inList {
            if plays[cell] == value {
                conclusion += "1"
            } else {
                conclusion += "0"
            }
        }
        return conclusion
    }
    
    // function to check the row combination
    func rowCheck(value:Int) -> (location:String,pattern:String)? {
        // locate rows that will lead to a win for CPU
        let acceptableFinds = ["011","110","101"]
        let findFuncs = [checkTop,checkBottom,checkLeft,checkRight,checkMiddleAcross,checkMiddleDown,checkDiagLeftRight,checkDiagRightLeft]
        // loop through findFuncs
        for algorithm in findFuncs {
            // locate the location of the acceptableFinds pattern
            let algorithmResults = algorithm(value)
            if (acceptableFinds.index(of: (algorithmResults.pattern)) != nil) {
                return algorithmResults
            }
        }
        return nil
    }
    
    // function to check if the spot is occupied
    func isOccupied(spot:Int) -> Bool {
        return plays[spot] != nil
    }
    
    // function for AI turn
    func aiTurn() {
        // set delay to give the impression the CPU is thinking
        delay(0.4) {
            
            // if the game is done, AI does not need to take a turn
            if self.done {
                return
            }
            
            // AI is deciding on next move
            self.aiDeciding = true
            
            // check if CPU (0) has 2 in a row
            if let result = self.rowCheck(value: 0) {
                var whereToPlayResult = self.whereToPlay(location: result.location,pattern:result.pattern)
                if !self.isOccupied(spot: whereToPlayResult) {
                    self.setImageForSpot(spot: whereToPlayResult, player: 0)
                    self.aiDeciding = false
                    self.checkForWin()
                    return
                }
            }
            
            // check if player (1) has 2 in a row
            if let result = self.rowCheck(value: 1) {
                var whereToPlayResult = self.whereToPlay(location: result.location,pattern:result.pattern)
                if !self.isOccupied(spot: whereToPlayResult) {
                    self.setImageForSpot(spot: whereToPlayResult, player: 0)
                    self.aiDeciding = false
                    self.checkForWin()
                    return
                }
            }
            
            // is centre available?
            if !self.isOccupied(spot: 5) {
                self.setImageForSpot(spot: 5, player: 0)
                self.aiDeciding = false
                self.checkForWin()
                return
            }
            
            // function to check for first available spot
            func firstAvailable(isCorner:Bool) -> Int? {
                // if spot is a corner, than 1,3,7,9 otherwise 2,4,6,8
                let spots = isCorner ? [1,3,7,9] : [2,4,6,8]
                for spot in spots {
                    if !self.isOccupied(spot: spot) {
                        return spot
                    }
                    
                }
                return nil
            }
            
            // is corner available?
            if let cornerAvailable = firstAvailable(isCorner:true) {
                self.setImageForSpot(spot: cornerAvailable, player: 0)
                self.aiDeciding = false
                self.checkForWin()
                return
            }
            
            // is side available?
            if let sideAvailable = firstAvailable(isCorner:false) {
                self.setImageForSpot(spot: sideAvailable, player: 0)
                self.aiDeciding = false
                self.checkForWin()
                return
            }
            
            // if the game is a draw, advise the player
            self.drawCount += 1
            self.drawScore.text = "\(self.drawCount)"
            print("Draw")
            self.historyText.text = self.historyText.text + "\nGame was a Draw!"
            self.alertWinner(playerName: "Neither")
            // AI has completed deciding on next move
            self.aiDeciding = false
        }
        
    }
    
    // function t
    func whereToPlay(location:String,pattern:String) -> Int {
        let leftPattern = "011"
        let rightPattern = "110"
        _ = "101"
        
        switch location {
        case "top":
            // depending on the patter, return the free space as marked by 0
            if pattern == leftPattern {
                return 1
            } else if pattern == rightPattern {
                return 3
            } else {
                return 2
            }
        case "bottom":
            // depending on the patter, return the free space as marked by 0
            if pattern == leftPattern {
                return 7
            } else if pattern == rightPattern {
                return 9
            } else {
                return 8
            }
        case "middleAcross":
            // depending on the patter, return the free space as marked by 0
            if pattern == leftPattern {
                return 4
            } else if pattern == rightPattern {
                return 6
            } else {
                return 5
            }
        case "middleDown":
            // depending on the patter, return the free space as marked by 0
            if pattern == leftPattern {
                return 2
            } else if pattern == rightPattern {
                return 8
            } else {
                return 5
            }
        case "left":
            // depending on the patter, return the free space as marked by 0
            if pattern == leftPattern {
                return 1
            } else if pattern == rightPattern {
                return 7
            } else {
                return 4
            }
        case "right":
            // depending on the patter, return the free space as marked by 0
            if pattern == leftPattern {
                return 3
            } else if pattern == rightPattern {
                return 9
            } else {
                return 6
            }
        case "diagLeftRight":
            // depending on the patter, return the free space as marked by 0
            if pattern == leftPattern {
                return 1
            } else if pattern == rightPattern {
                return 9
            } else {
                return 5
            }
        case "diagRightLeft":
            // depending on the patter, return the free space as marked by 0
            if pattern == leftPattern {
                return 3
            } else if pattern == rightPattern {
                return 7
            } else {
                return 5
            }
        default:
            return 4
        }
    }
    
    // introduce a delay for the CPU player
    //
    // Reference: Matt 2014, dispatch_after - GCD in swift?, StackOverFlow, published 20 June 2014, retrieved 2 April 2017, <http://stackoverflow.com/questions/24034544/dispatch-after-gcd-in-swift/24318861#24318861>
    //
    //
    func delay(_ delay:Double, closure:@escaping ()->()) {
            let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    
    }

    // function to display alert box when game is over with a winner
    func alertWinner(playerName : String) {
        let alertController = UIAlertController(title: "Game Over", message: "\(playerName) Won!",
            preferredStyle: .actionSheet)
        
        let yesAction = UIAlertAction(title: "Ok", style: .default) {
            (action) -> Void in self.start()}
        
        alertController.addAction(yesAction)
        self.present(alertController, animated: true, completion: nil)
    }

    // restart function called when Game over alert OK button is clicked
    func start() {
        done = false
        reset()
    }
    
    // background music control
    @IBAction func musicOnOff(_ sender: UIButton){
        // music is playing on load, if its playing, pause it and change the icon to play
        if audioPlayer.isPlaying {
            audioPlayer.pause()
            musicBtn.setImage(UIImage(named: "play1"), for: .normal)
        }
            // if the music is stopped, play again and change icon to pause
        else
        {
            audioPlayer.play()
            musicBtn.setImage(UIImage(named: "pause"), for: .normal)
        }
        
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        if audioPlayer.isPlaying {
            audioPlayer.pause()
        }
        else {
            audioPlayer.stop()
        }
        
    }
    
    // play soundFX funciton to be called when a piece is placed on the game board
    func playSound() {
        // do try catch for audio player
        do {
            audioPlayerSoundFX = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "wood sound", ofType: "mp3")!))
            audioPlayerSoundFX.prepareToPlay()
            audioPlayerSoundFX.play()
        }
        catch {
            print(error)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  Dance of Death obtained from:
        //  Purple Planet <http://www.purple-planet.com/horror-old/4583971268>
        //
        // play music when the view loads
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Dance Of Death", ofType: "mp3")!))
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            audioPlayer.numberOfLoops = -1
        }
        catch {
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
