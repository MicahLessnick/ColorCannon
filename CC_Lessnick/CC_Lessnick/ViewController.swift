//
//  ViewController.swift
//  CC_Lessnick
//
//  Created by  on 11/14/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cannonBallImage: UIImageView!
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if hardMode{
            //switch available color array based on mode selection
            //allows fewer if statements in switch
            colorArray = hardColors
            targetArray = hardTargets
        }
        else{
            colorArray = normalColors
            targetArray = normalTargets
        }
        
        targetColor = targetArray.randomElement()!
        colorDisplay.text = targetColor
    }

    @IBAction func paintCanClicked(_ sender: UIButton) {
        if !firstColorPicked{
            //first color has not been picked yet, the user has just selected it
            //set firstColor to the first color and change cannon ball
            switch sender {
            case top:
                firstColor = colorArray[0]
                //add code to highlight selection (?)
            case mid:
                firstColor = colorArray[1]
            default:
                firstColor = colorArray[2]
            }
            firstColorPicked.toggle()
        }
        else{
            //fully fill cannon ball and enable shoot button
            //set second color to color picked by user
            switch sender {
            case top:
                secondColor = colorArray[0]
            case mid:
                secondColor = colorArray[1]
            default:
                secondColor = colorArray[2]
            }
            userColor = inputsToOutput[firstColor+secondColor]!
            firstColorPicked.toggle()
            
        }
    }
    
}

