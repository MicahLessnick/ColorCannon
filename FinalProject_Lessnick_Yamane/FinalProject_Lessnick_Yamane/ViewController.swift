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
    @IBOutlet weak var ship: UIImageView!
    @IBOutlet weak var cannonball_shot: UIImageView!
    @IBOutlet weak var clear: UIButton!
    
    var firstColorPicked: Bool = false
    var hardMode: Bool = false
    var currentMode: Bool = false
    //currentMode will be checked against hardMode to see if score needs to be reset
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
    var misses = 0
    //user's streak
    
    var normalHS: Int = 0
    var hardHS: Int = 0
    //highscores
    
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
        targetColor = targetArray.randomElement()!
        colorDisplay.text = targetColor
        turnOffSelections()
        //resetVars sets all varables to their default, disables fire button, and generates a new target
        
        normalHS = UserDefaults.standard.integer(forKey: "normHS")
        hardHS = UserDefaults.standard.integer(forKey: "hardHS")
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let settingVC: SettingsViewController = segue.destination as! SettingsViewController
        
        settingVC.isHardMode = hardMode
        settingVC.streak = userScore
    }
    
    /*override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //may need to use this function to change paint colors
     
        isHardMode(hardMode)
        turnOffSelections()
    }*/
    
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
            setCannonBall()
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
            setCannonBall()
            firstColorPicked.toggle()
        }
    }
    
    func isHardMode(_ hardSelected: Bool) {
        //called during initialization (and after returning from settings, if hard mode was toggled)
        //also contains code to reset streak if the mode was changed
        currentMode = UserDefaults.standard.bool(forKey: "curMod")
        if currentMode != hardSelected{
            currentMode.toggle()
            userScore = 0
        }
        
        UserDefaults.standard.set(currentMode, forKey: "curMod")
        scoreLabel.text = "Streak: \(userScore)"
        
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
        top.setImage(UIImage(named: "Paint-\(colorArray[0])"), for: .normal)
        mid.setImage(UIImage(named: "Paint-\(colorArray[1])"), for: .normal)
        bot.setImage(UIImage(named: "Paint-\(colorArray[2])"), for: .normal)
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
        
        let shipCenter = self.ship.center
        let labelCenter = self.colorDisplay.center
        let oldCenter = self.cannonball_shot.center
        let newCenter = CGPoint(x: shipCenter.x, y: shipCenter.y + 50.0)
        let oldSize = 65.0
        let newSize = 10.0
        
        clear.isEnabled = false
        fireButton.isEnabled = false
        
        // begin animation
        self.cannonBallImage.isHidden = true                                              // hide cannonball on screen
        self.cannonball_shot.image = UIImage(named: "Cannonball-Full-\(self.userColor)")  // set cannonball image
        
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
            // rising
            let toSize = newSize + 15.0
            self.cannonball_shot.frame = CGRect(x: newCenter.x-(toSize/2),
                                           y: newCenter.y - 60.0,
                                           width: toSize, height: toSize)
        }) { (success: Bool) in
            
            // falling and hit ship
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                self.cannonball_shot.frame = CGRect(x: newCenter.x-(newSize/2),
                                               y: newCenter.y,
                                               width: newSize, height: newSize)
            }) { (success: Bool) in
                
                // check if answer is correct
                if self.userColor == self.targetColor {
                    // correct combo
                    self.userScore += 1
                    self.misses = 0
                    
                    if !self.hardMode{
                        if self.userScore > self.normalHS{
                            //if normal mode streak is better than current high score, override previous high score
                            UserDefaults.standard.set(self.userScore, forKey: "normHS")
                        }
                    }
                    else{
                        if self.userScore > self.hardHS{
                            //if hard mode streak is better than current high score, override previous high score
                            UserDefaults.standard.set(self.userScore, forKey: "hardHS")
                        }
                    }
                    
                    // change ship to explosion and bring in new ship
                    self.sinkShip(shipCenter, labelCenter, oldCenter, newCenter, oldSize, newSize)
                    
                } else {
                    // wrong combo
                    self.userScore = 0
                    self.misses += 1
                    
                    // bounce off the ship and don't move until third miss
                    self.bounceOffShip(shipCenter, labelCenter, oldCenter, newCenter, oldSize, newSize)
                }
            }
        }
    }
    
    func afterFire() {
        self.scoreLabel.text = "Streak: \(self.userScore)"
        self.cannonBallImage.isHidden = false  // show cannonball again
        resetVars()
        togglePaintButtons()
        clear.isEnabled = true
    }
    
    func sinkShip(_ shipCenter:CGPoint, _ labelCenter:CGPoint, _ oldCenter:CGPoint, _ newCenter:CGPoint,
                        _ oldSize : CGFloat, _ newSize: CGFloat) {
        // reset cannonball shot
        self.cannonball_shot.frame = CGRect(x: oldCenter.x-(oldSize/2),
                                       y: oldCenter.y-(oldSize/2),
                                       width: oldSize, height: oldSize)
        // change ship to burning
        self.ship.image = UIImage(named: "Ship-Burn")
        
        // sink ship
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseIn, animations: {
            self.ship.frame = CGRect(x: shipCenter.x - 123,
                                     y: shipCenter.y + 80,
                                     width: 246, height: 160)
            self.colorDisplay.frame = CGRect(x: labelCenter.x - 60.5,
                                             y: labelCenter.y + 120,
                                             width: 119, height: 80)
        }) { (success: Bool) in
            self.ship.image = UIImage(named: "Ship")
            
            // bring in new ship
            self.bringInNewShip(shipCenter, labelCenter, oldCenter, newCenter, oldSize, newSize)
        }
    }  // end of sinkShip
    
    func bounceOffShip(_ shipCenter:CGPoint, _ labelCenter:CGPoint, _ oldCenter:CGPoint, _ newCenter:CGPoint,
                       _ oldSize : CGFloat, _ newSize: CGFloat) {
        // bounce off Ship
        let growth = 5.0
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.cannonball_shot.frame = CGRect(x: newCenter.x + 5.0,
                                           y: newCenter.y,
                                           width: newSize+growth,
                                           height: newSize+growth)
        }) { (success: Bool) in
            
            // go off to the side
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                self.cannonball_shot.frame = CGRect(x: newCenter.x + 5.0,
                                               y: newCenter.y+30.0,
                                               width: newSize+growth, height: newSize+growth)
            }) { (success: Bool) in
                
                // land in water
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                    self.cannonball_shot.frame = CGRect(x: newCenter.x + 5.0,
                                                   y: newCenter.y+30.0,
                                                   width: newSize+growth, height: newSize+growth)
                }) { (success: Bool) in
                    // cannonball splashes
                    self.cannonball_shot.image = UIImage(named: "Cannonball-Splash")
                    
                    // don't sail away until 3 misses
                    if self.misses == 3 {
                        self.misses = 0
                        
                        // ship sails away
                        UIView.animate(withDuration: 1.5, delay: 0, options: .curveLinear, animations: {
                            self.ship.frame = CGRect(x: -160,
                                                     y: shipCenter.y-80,
                                                     width: 160, height: 160)
                            self.colorDisplay.frame = CGRect(x: -140,
                                                             y: labelCenter.y-40,
                                                             width: 119, height: 80)
                            
                        }) { (success: Bool) in
                            // reset cannonball location and size
                            self.cannonball_shot.frame = CGRect(x: oldCenter.x-(oldSize/2),
                                                           y: oldCenter.y-(oldSize/2),
                                                           width: oldSize, height: oldSize)
                            
                            self.bringInNewShip(shipCenter, labelCenter, oldCenter, newCenter, oldSize, newSize)
                        }
                    } else {
                        // sink cannonball slowly
                        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                            self.cannonball_shot.frame = CGRect(x: newCenter.x + 5.0,
                                                           y: newCenter.y+31.0,
                                                           width: newSize+growth, height: newSize+growth)
                        }) { (success: Bool) in
                        
                            // reset cannonball location and size
                            self.cannonball_shot.frame = CGRect(x: oldCenter.x-(oldSize/2),
                                                           y: oldCenter.y-(oldSize/2),
                                                           width: oldSize, height: oldSize)
                            self.cannonball_shot.image = UIImage(named: "Cannonball-Empty")
                            self.afterFire()
                        }
                    }
                }
            }
        }
    }  // end of bounceOffShip
    
    func bringInNewShip(_ shipCenter:CGPoint, _ labelCenter:CGPoint, _ oldCenter:CGPoint, _ newCenter:CGPoint,
                  _ oldSize : CGFloat, _ newSize: CGFloat) {
        // set new color
        targetColor = targetArray.randomElement()!
        colorDisplay.text = targetColor
        
        // set ship and color label to right side
        self.ship.frame = CGRect(x: 414,
                                 y: shipCenter.y-80,
                                 width: 160, height: 160)
        self.colorDisplay.frame = CGRect(x: 414+20,
                                         y: labelCenter.y-40,
                                         width: 119, height: 80)
        
        self.cannonball_shot.alpha = 1
        
        
        UIView.animate(withDuration: 1.5, delay: 1.0, options: .curveLinear, animations: {
            // bring in ship
            self.colorDisplay.frame = CGRect(x: labelCenter.x-60.5,
                                        y: labelCenter.y-40,
                                        width: 119, height: 80)
            self.ship.frame = CGRect(x: shipCenter.x-80,
                                     y: shipCenter.y-80,
                                     width: 160, height: 160)
        }) { (success: Bool) in
            
            self.afterFire()
        }
    }  // end of bringInNewShip
    
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
        cannonBallImage.image = UIImage(named: "Cannonball-Empty")
    }
    
    func resetVars(){
        //function to set all varables to their default, disable fire button, and generate a new target
        firstColor = ""
        secondColor = ""
        userColor = ""
        fireButton.isEnabled = false
        turnOffSelections()
        cannonBallImage.image = UIImage(named: "Cannonball-Empty")
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
            cannonBallImage.image = UIImage(named: "Cannonball-Half-\(firstColor)")
        }
        else{
            cannonBallImage.image = UIImage(named: "Cannonball-Full-\(userColor)")
        }
    }
}
