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
    //flag indicating whether or not the first color has been picked
    
    var firstColor: String = ""
    //string containing the name of the first color the user picked
    var secondColor: String = ""
    
    var normalColors = ["Blue", "Red", "Yellow"]
    var hardColors = ["Cyan", "Magenta", "Yellow"]
    //array containing available colors to be chosen in each game mode
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func paintCanClicked(_ sender: UIButton) {
        if !firstColorPicked{
            //first color has not been picked yet, the user has just selected it
            //set firstColor to the first color and change cannon ball
        }
        else{
            //fully fill cannon ball and enable shoot button
            //set second color to color picked by user
            switch firstColor {
            case "Blue":
                switch <#value#> {
                case <#pattern#>:
                    <#code#>
                default:
                    <#code#>
                }
            case "Red":
                switch <#value#> {
                case <#pattern#>:
                    <#code#>
                default:
                    <#code#>
                }
            
            default:
                //default at the moment will be yellow. More cases will be added for "hard mode"
                <#code#>
            }
        }
    }
    
}

