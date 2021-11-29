//
//  ViewController.swift
//  FinalProject_Lessnick_Yamane
//
//  Created by  on 11/14/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cannonBallImage: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var fireButton: UIButton!
    
    var firstColorPicked: Bool = false
    var hardMode: Bool = false
    //flags for hard mode and number of selections
    
    var firstColor: String = ""
    var secondColor: String = ""
    //user's selection
    
    var normalColors = ["Red", "Blue", "Yellow"]
    var normalTargets = ["Red", "Blue", "Yellow", "Purple", "Green", "Orange"]
    var hardColors = ["Cyan", "Magenta", "Yellow"]
    var hardTargets = ["Cyan", "Magenta", "Yellow", "Blue", "Red", "Green"]
    var colorArray:[String] = []
    var targetArray:[String] = []
    //array containing available colors to be chosen in each game mode
    
    var targetColor = ""
    var userColor = ""
    //target and user input
    
    var userScore = 0
    
    let inputsToOutput = ["RedRed":"Red",
                          "RedBlue":"Purple",
                          "RedYellow":"Orange",
                          "BlueBlue":"Blue",
                          "BlueYellow":"Green",
                          "BlueRed":"Purple",
                          "YellowYellow":"Yellow",
                          "YellowRed":"Orange",
                          "YellowBlue":"Green",
                          "CyanCyan":"Cyan",
                          "CyanMagenta":"Blue",
                          "CyanYellow":"Green",
                          "MagentaMagenta":"Magenta",
                          "MagentaYellow":"Red",
                          "MagentaCyan":"Blue",
                          "YellowCyan":"Green",
                          "YellowMagenta":"Red"]
    //dictionary containing every possible user input + resulting output
    
    @IBOutlet weak var top: UIButton!
    @IBOutlet weak var mid: UIButton!
    @IBOutlet weak var bot: UIButton!

    @IBOutlet weak var colorDisplay: UILabel!
    
    @IBOutlet weak var topSelect1: UIImageView!
    @IBOutlet weak var midSelect1: UIImageView!
    @IBOutlet weak var botSelect1: UIImageView!
    @IBOutlet weak var topSelect2: UIImageView!
    @IBOutlet weak var midSelect2: UIImageView!
    @IBOutlet weak var botSelect2: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        isHardMode(hardMode)
        resetVars()
        turnOffSelections()
        //resetVars sets all varables to their default, disables fire button, and generates a new target
        
    }

    @IBAction func paintCanClicked(_ sender: UIButton) {
        if !firstColorPicked{
            //first color has not been picked yet, the user has just selected it
            //set firstColor to the first color and change cannon ball
            switch sender {
            case top:
                firstColor = colorArray[0]
                topSelect1.isHidden = false
            case mid:
                firstColor = colorArray[1]
                midSelect1.isHidden = false
            default:
                firstColor = colorArray[2]
                botSelect1.isHidden = false
            }
            
            firstColorPicked.toggle()
        }
        else{
            //fully fill cannon ball and enable shoot button
            //set second color to color picked by user
            switch sender {
            case top:
                secondColor = colorArray[0]
                if !compareColors(sender){
                    topSelect1.isHidden = false
                }
            case mid:
                secondColor = colorArray[1]
                if !compareColors(sender){
                    midSelect1.isHidden = false
                }
            default:
                secondColor = colorArray[2]
                if !compareColors(sender){
                    botSelect1.isHidden = false
                }
            }
            
            togglePaintButtons()
            
            if firstColor != "" && secondColor != ""
            {
                //ensures inputsToOutputs will work
                userColor = inputsToOutput[firstColor+secondColor]!
                fireButton.isEnabled = true
            }
            firstColorPicked.toggle()
        }
    }
    
    func isHardMode(_ hardSelected: Bool) {
        //called during initialization (and after returning from settings, if hard mode was toggled)
        if hardSelected{
            //switch available color array based on mode selection
            //allows fewer if statements in switch
            colorArray = hardColors
            targetArray = hardTargets
        }
        else{
            colorArray = normalColors
            targetArray = normalTargets
        }
    }
    
    func togglePaintButtons() {
        //toggles whether all paint cans are enabled or disabled
        top.isEnabled.toggle()
        mid.isEnabled.toggle()
        bot.isEnabled.toggle()
    }
    
    @IBAction func fireCannon(_ sender: UIButton) {
        //fires the cannon when userColor has been populated
        //sets user inputs back to empty strings and decides what to do on success/fail
        if userColor == targetColor{
            //print statements here are temporary, will be changed to actual animation at a later time
            print("match")
            userScore += 1
        }
        else{
            print("fail")
        }
        scoreLabel.text = "Score: \(userScore)"
        resetVars()
        togglePaintButtons()
    }
    
    
    @IBAction func clearContents(_ sender: UIButton) {
        //clears user selection, keeps current target
        firstColor = ""
        secondColor = ""
        userColor = ""
        fireButton.isEnabled = false
        firstColorPicked = false
        //no color has been chosen, so cannon and color picked flag should both be false
        
        top.isEnabled = true
        mid.isEnabled = true
        bot.isEnabled = true
        
        turnOffSelections()
    }
    
    func resetVars(){
        //function to set all varables to their default, disable fire button, and generate a new target
        firstColor = ""
        secondColor = ""
        userColor = ""
        targetColor = targetArray.randomElement()!
        colorDisplay.text = targetColor
        fireButton.isEnabled = false
        turnOffSelections()
    }
    
    func turnOffSelections() {
        topSelect1.isHidden = true
        midSelect1.isHidden = true
        botSelect1.isHidden = true
        topSelect2.isHidden = true
        midSelect2.isHidden = true
        botSelect2.isHidden = true
    }
    
    func compareColors(_ sender: UIButton) -> Bool{
        //toggles double-selection of the same paint can if the user has selected the same option
        //returns true if the user has selected the same color, false otherwise
        if firstColor == secondColor {
            switch sender {
            case top:
                topSelect2.isHidden = false
            case mid:
                midSelect2.isHidden = false
            default:
                botSelect2.isHidden = false
            }
            return true
        }
        else{
            return false
        }
        
    }
    func setCannonBall(){
        //set the color of the cannonball (half-full if it's the first selection, totally full if it's the second)
        if !firstColorPicked{
            cannonBallImage.image = UIImage(named: "cannonball-half-\(firstColor)")
        }
        else{
            cannonBallImage.image = UIImage(named: "cannonball-\(secondColor)")
        }
    }
}
