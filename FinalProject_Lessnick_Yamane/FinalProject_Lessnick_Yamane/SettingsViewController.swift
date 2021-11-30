//
//  SettingsViewController.swift
//  FinalProject_Lessnick_Yamane
//
//  Created by  on 11/29/21.
//

import UIKit

class SettingsViewController: UIViewController {

    var isHardMode:Bool = false
    
    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var hardSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialMode()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func hardModeToggle(_ sender: UISwitch) {
        //toggle hard mode flag when the switch is pressed
        isHardMode.toggle()
        if sender.isOn{
            modeLabel.text = "Hard Mode"
        }
        else{
            modeLabel.text = "Normal Mode"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mainVC:ViewController = segue.destination as! ViewController
        mainVC.hardMode = isHardMode
    }
    
    func initialMode(){
        //set the switch's initial appearance based on isHardMode
        if isHardMode{
            hardSwitch.isOn = true
            modeLabel.text = "Hard Mode"
        }
        else{
            hardSwitch.isOn = false
            modeLabel.text = "Normal Mode"
        }
    }
}
