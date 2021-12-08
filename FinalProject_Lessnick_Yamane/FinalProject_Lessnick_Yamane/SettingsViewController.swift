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
    @IBOutlet weak var normHSDisplay: UILabel!
    @IBOutlet weak var hardHSDisplay: UILabel!
    
    @IBOutlet weak var sfxSwitch: UISwitch!
    @IBOutlet weak var musicSwitch: UISwitch!
    
    var normHS: Int = 0
    var hardHS: Int = 0
    
    var muteMusic: Bool = false
    var muteSFX: Bool = false
    
    var streak: Int = 0
    //current user streak, variable used for storage only
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialMode()
        normHS = UserDefaults.standard.integer(forKey: "normHS")
        hardHS = UserDefaults.standard.integer(forKey: "hardHS")
        normHSDisplay.text = String(normHS)
        hardHSDisplay.text = String(hardHS)
    }
    
    @IBAction func hardModeToggle(_ sender: UISwitch) {
        //toggle hard mode flag when the switch is pressed
        isHardMode.toggle()
    }
    @IBAction func sfxToggle(_ sender: UISwitch) {
        muteSFX.toggle()
    }
    
    @IBAction func musicToggle(_ sender: UISwitch) {
        muteMusic.toggle()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mainVC:ViewController = segue.destination as! ViewController
        mainVC.hardMode = isHardMode
        mainVC.userScore = streak
        mainVC.muteSFX = muteSFX
        mainVC.muteMusic = muteMusic
    }
    
    @IBAction func resetScoresSelected(_ sender: UIButton) {
        normHS = 0
        hardHS = 0
        UserDefaults.standard.set(0, forKey: "normHS")
        UserDefaults.standard.set(0, forKey: "hardHS")
        normHSDisplay.text = String(normHS)
        hardHSDisplay.text = String(hardHS)
    }
    
    func initialMode(){
        //set the switch's initial appearance based on isHardMode
        if isHardMode{
            hardSwitch.isOn = true
        }
        else{
            hardSwitch.isOn = false
        }
        
        if muteMusic {
            musicSwitch.isOn = true
        } else {
            musicSwitch.isOn = false
        }
        
        if muteSFX {
            sfxSwitch.isOn = true
        } else {
            sfxSwitch.isOn = false
        }
    }
}
