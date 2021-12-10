//-----------------------------------------------------------------------------------------
// Micah Lessnick and Mark Yamane, 12/08/2021
//
// Color Cannon Settings
//
// Allows the user to toggle between easy and hard mode, as well as mute sound effects or
// music.
//
// The code contained in this program represents our own work and ideas - ML and MY
//-----------------------------------------------------------------------------------------

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
    var musicChanged: Bool = false
    var audioDir = "sounds/"
    var backgroundPlayer = AVAudioPlayer()   // AudioPlayer for background music
    var audioPlayer1 = AVAudioPlayer()       // sfx AudioPlayer
    var audioPlayer2 = AVAudioPlayer()       // another AudioPlayer to prevent overlapping
    var screamPlayer = AVAudioPlayer()       // AudioPlayer for jump scare
    var surprisedPressed = false
    
    var targetColor = ""
    var misses = 0
    var modeChanged:Bool = false
    
    var streak: Int = 0
    //current user streak, variable used for storage only
    
    var randomArray = [2.0, 3.0, 4.0, 5.0]
    @IBOutlet weak var supImg: UIImageView!
    var timer1: Timer!
    var timer2: Timer!
    var timer3: Timer!
    @IBOutlet var longPress: UILongPressGestureRecognizer!
    @IBOutlet weak var easterEgg: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialMode()
        normHS = UserDefaults.standard.integer(forKey: "normHS")
        hardHS = UserDefaults.standard.integer(forKey: "hardHS")
        normHSDisplay.text = String(normHS)
        hardHSDisplay.text = String(hardHS)
        modeChanged = false
        musicChanged = false
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
        musicChanged.toggle()
        if muteMusic {
            backgroundPlayer.stop()
        } else {
            let backgroundMusic = URL(fileURLWithPath: Bundle.main.path(forResource: self.audioDir+"background-music", ofType:"mp3")!)
            do {
                self.backgroundPlayer = try AVAudioPlayer(contentsOf: backgroundMusic)
                self.backgroundPlayer.numberOfLoops = -1 // loop music
                self.backgroundPlayer.play()
                
           } catch {
                print("Sound file not found")
           }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mainVC:ViewController = segue.destination as! ViewController
        mainVC.hardMode = isHardMode
        mainVC.userScore = streak
        mainVC.muteSFX = muteSFX
        mainVC.muteMusic = muteMusic
        mainVC.musicChanged = musicChanged
        mainVC.backgroundPlayer = backgroundPlayer
        mainVC.audioPlayer1 = audioPlayer1
        mainVC.audioPlayer2 = audioPlayer2
        mainVC.modeChanged = modeChanged
        mainVC.targetColor = targetColor
        mainVC.misses = misses
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
    
    
    @IBAction func surprise(_ sender: UILongPressGestureRecognizer) {
        longPress.isEnabled = false
        easterEgg.isUserInteractionEnabled = false
        
        if !surprisedPressed {
            surprisedPressed.toggle()
            backgroundPlayer.stop()
            let randDelay: Double = randomArray.randomElement()!
            //add code to set view as jump scare after delay
            self.timer1 = Timer.scheduledTimer(timeInterval: randDelay,
                                              target: self,
                                              selector: #selector(waitImage),
                                              userInfo: nil,
                                              repeats: false)
            
        }
    }
    
    @objc func waitImage(_ sender: Timer) {
        supImg.image = UIImage(named: "spook")
        
        if !muteSFX {
            // play scream
            let scream = URL(fileURLWithPath: Bundle.main.path(forResource: self.audioDir+"scream", ofType:"mp3")!)// play sfx
            do {
                self.screamPlayer = try AVAudioPlayer(contentsOf: scream)
                self.screamPlayer.play()
           } catch {
                print("Sound file not found")
           }
        }
        
        self.timer2 = Timer.scheduledTimer(timeInterval: 0.6,
                                          target: self,
                                          selector: #selector(flipImage),
                                          userInfo: nil,
                                          repeats: false)
    }
    @objc func flipImage(_ sender: Timer) {
        supImg.image = UIImage(named: "transparency")
        if muteMusic {
            backgroundPlayer.stop()
        } else {
            self.timer1 = Timer.scheduledTimer(timeInterval: 2.0,
                                              target: self,
                                              selector: #selector(playMusicAgain),
                                              userInfo: nil,
                                              repeats: false)
        }
    }
    
    @objc func playMusicAgain(_ sender: Timer) {
        if muteMusic {
            backgroundPlayer.stop()
        } else {
            let backgroundMusic = URL(fileURLWithPath: Bundle.main.path(forResource: self.audioDir+"background-music", ofType:"mp3")!)
            do {
                self.backgroundPlayer = try AVAudioPlayer(contentsOf: backgroundMusic)
                self.backgroundPlayer.numberOfLoops = -1 // loop music
                self.backgroundPlayer.play()
                
           } catch {
                print("Sound file not found")
           }
        }
    }
    
}
