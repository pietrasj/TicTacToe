//
//  ViewController.swift
//  TicTacToe
//
//  Created by Jayne Pietraszkiewicz on 26/3/17.
//  Copyright © 2017 Deakin. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    // declaring audio player for sound effects
    var audioPlayerSoundFX = AVAudioPlayer()
    // declaring audio player for music
    var audioPlayer = AVAudioPlayer()
    var numberOfLoops = 0
    var images = [UIImage(named: "ximage"),
                  UIImage(named: "oimage"),]
    
    @IBOutlet var gameSpaces: [UIButton]!
    @IBOutlet weak var player1Score: UILabel!
    @IBOutlet weak var drawScore: UILabel!
    @IBOutlet weak var player2Score: UILabel!
    @IBOutlet weak var historyText: UITextView!
    @IBOutlet weak var musicBtn: UIButton!

    @IBOutlet weak var player1EnteredName: UITextField!
    @IBOutlet weak var player2EnteredName: UITextField!
    
    
    var currentPlayer = 1
    var gameBoard = [0,0,0,0,0,0,0,0,0]
    var gameIsActive = true
    var grid = [[0,0,0],[0,0,0],[0,0,0]]

    
    // score counter
    var p1Count = 0
    var p2Count = 0
    var drawCount = 0
    // game turn counter
    var turnCount = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
         self.view.backgroundColor = UIColor(patternImage: UIImage(named: "tictactoebg1a.png")!)
        
        //  African Music obtained from:
        //  ZapSplat <http://www.zapsplat.com/music/african-fun-african-percussion-marimba-and-kalimba-driven-loop-fun-light-hearted-3/>
        //
        // play music when the view loads
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "African_fun_long", ofType: "mp3")!))
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            audioPlayer.numberOfLoops = -1
        }
        catch {
            print(error)
        }
        
        //Looks for single or multiple taps away from keyboard.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        view.addGestureRecognizer(tap)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Reset button action
    @IBAction func reset(_ sender: UIButton) {
    
        // pause game
        gameIsActive = false
        
        // loop through buttons to clear the image
        for gameSpace in gameSpaces {
            gameSpace.setImage(nil, for: .normal)
            // set the current player back to 1 (X)
            currentPlayer = 1
            // reset the game board
            grid = [[0,0,0],[0,0,0],[0,0,0]]
            // reset game turn counter
            turnCount = 1
        }
        // set game to active
        gameIsActive = true
    }
    

    // game button action
    @IBAction func tapped(_ sender: UIButton) {
        
        let rowIndex = sender.tag / 3
        let colIndex = sender.tag % 3
        
        if grid[rowIndex][colIndex] != 0
        {
            return
        }
        
        grid[rowIndex][colIndex] = currentPlayer
        
        // if the current player tag is set to 1 (X)
        if currentPlayer == 1
        {
            // place the ximage and set the current player to 2 (O)
            sender.setImage(UIImage(named: "ximage"), for: .normal)
            playSound()
        }
        else
        {
            // else if the current player is set to 2, place the oimage and set current player back to 1 (X)
            sender.setImage(UIImage(named: "oimage"), for: .normal)
            playSound()
        }
        
        let winner = winlose()
        print("player \(currentPlayer) just played, and status winner = \(winner)")
        print("grid \(grid) and index row \(rowIndex) and col \(colIndex)")
        print("turn count: \(turnCount)")
        
        // if no winner identified at turn 9, game is a draw
        if turnCount == 9 && winner == 0 {
            drawCount += 1
            drawScore.text = "\(drawCount)"
            print("Draw")
            historyText.text = historyText.text + "\nGame was a Draw!"
            alertWinner(playerName: "Neither")
        }
        
        switch winner {
        case 0:
            currentPlayer = (currentPlayer % 2) + 1
            turnCount += 1
        case 1:
            p1Count += 1
            player1Score.text = "\(p1Count)"
            print("Player 1 is the winner")
            
            // check if players entered their own name. If so write this to alert and history
            let p1Text : String = player1EnteredName.text!
            if p1Text == "Player 1" || p1Text == "" {
                historyText.text = historyText.text + "\nPlayer 1 Won!"
                alertWinner(playerName: "Player 1")
            } else {
                alertWinner(playerName: "\(p1Text)")
                historyText.text = historyText.text + "\n\(p1Text) Won!"
            }

        case 2:
            p2Count += 1
            player2Score.text = "\(p2Count)"
            print("Player 2 is the winner")
            // check if players entered their own name. If so write this to alert and history
            let p2Text : String = player2EnteredName.text!
            if p2Text == "Player 2" || p2Text == "" {
                alertWinner(playerName: "Player 2")
                historyText.text = historyText.text + "\nPlayer 2 Won!"
            } else {
                alertWinner(playerName: "\(p2Text)")
                historyText.text = historyText.text + "\n\(p2Text) Won!"
            }
            
            
        default:
            print("No Winner Identified")
        }
    }
    
    func winlose() -> Int {
        // first row
        if grid[0][0] != 0 && grid[0][0] == grid[0][1] && grid[0][1] == grid[0][2]
        {
           return grid[0][0]
        }
        // second row
        if grid[1][0] != 0 && grid[1][0] == grid[1][1] && grid[1][1] == grid[1][2]
        {
            return grid[1][0]
        }
        // third row
        if grid[2][0] != 0 && grid[2][0] == grid[2][1] && grid[2][1] == grid[2][2]
        {
            return grid[2][0]
        }
        // first column
        if grid[0][0] != 0 && grid[0][0] == grid[1][0] && grid[1][0] == grid[2][0]
        {
            return grid[0][0]
        }
        // second column
        if grid[0][1] != 0 && grid[0][1] == grid[1][1] && grid[1][1] == grid[2][1]
        {
            return grid[0][1]
        }
        // third column
        if grid[0][2] != 0 && grid[0][2] == grid[1][2] && grid[1][2] == grid[2][2]
        {
            return grid[0][2]
        }
        // top left to bottom right
        if grid[0][0] != 0 && grid[0][0] == grid[1][1] && grid[1][1] == grid[2][2]
        {
            return grid[0][0]
        }
        // top right to bottom left
        if grid[0][2] != 0 && grid[0][2] == grid[1][1] && grid[1][1] == grid[2][0]
        {
            return grid[0][2]
        }
        return 0
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
    
    // function to start game after one player has won. Occurs when OK in alert box is tapped.
    func start() {
        // reset the game board
        grid = [[0,0,0],[0,0,0],[0,0,0]]
        for gameSpace in gameSpaces {
            gameSpace.setImage(nil, for: .normal)
            // set the current player back to 1 (X)
            currentPlayer = 1
            // reset turn counter
            turnCount = 1
        }
    }
    
    
    //  Wood Sound obtained from:
    //  ZapSplat <http://www.zapsplat.com/music/wooden-bread-bin-lid-close-1/>
    //
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
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    

}

