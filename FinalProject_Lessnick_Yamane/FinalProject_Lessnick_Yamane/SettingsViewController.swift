//
//  SettingsViewController.swift
//  FinalProject_Lessnick_Yamane
//
//  Created by  on 11/29/21.
//

import UIKit
import AVFoundation

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
    var backgroundPlayer = AVAudioPlayer()   // AudioPlayer for background music
    var audioPlayer1 = AVAudioPlayer()       // sfx AudioPlayer
    var audioPlayer2 = AVAudioPlayer()       // another AudioPlayer to prevent overlapping
    
    var targetColor = ""
    
    var modeChanged:Bool = false
    
    var streak: Int = 0
    //current user streak, variable used for storage only
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialMode()
        normHS = UserDefaults.standard.integer(forKey: "normHS")
        hardHS = UserDefaults.standard.integer(forKey: "hardHS")
        normHSDisplay.text = String(normHS)
        hardHSDisplay.text = String(hardHS)
        modeChanged = false
    }
    
    @IBAction func hardModeToggle(_ sender: UISwitch) {
        //toggle hard mode flag when the switch is pressed
        isHardMode.toggle()
        modeChanged.toggle()
    }
    @IBAction func sfxToggle(_ sender: UISwitch) {
        muteSFX.toggle()
        if muteSFX {
            audioPlayer1.stop()
            audioPlayer2.stop()
        }
    }
    
    @IBAction func musicToggle(_ sender: UISwitch) {
        muteMusic.toggle()
        if muteMusic {
            backgroundPlayer.stop()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mainVC:ViewController = segue.destination as! ViewController
        mainVC.hardMode = isHardMode
        mainVC.userScore = streak
        mainVC.muteSFX = muteSFX
        mainVC.muteMusic = muteMusic
        mainVC.backgroundPlayer = backgroundPlayer
        mainVC.audioPlayer1 = audioPlayer1
        mainVC.audioPlayer2 = audioPlayer2
        mainVC.modeChanged = modeChanged
        mainVC.targetColor = targetColor
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
