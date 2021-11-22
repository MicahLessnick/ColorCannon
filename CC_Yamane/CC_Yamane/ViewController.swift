//
//  ViewController.swift
//  CC_Yamane
//
// Set up cannon firing animations for Color Cannon
// TODO: can combine cannonball and new ship functions (reset)

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var cannonball: UIImageView!
    @IBOutlet weak var ship: UIImageView!
    @IBOutlet var appView: UIView!
    @IBOutlet weak var comboCheckButton: UIButton!
    
    var notFired = true
    var answerCorrect = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // instead of collision detection, let's use a simple animation because the boat
    // and the cannon will always be in the same places
    @IBAction func fireButton_pressed(_ sender: UIButton) {
        self.fireCannonball()
    }
    @IBAction func comboCheck_pressed(_ sender: UIButton) {
        if comboCheckButton.titleLabel!.text == "Correct Combo" {
            comboCheckButton.setTitle("Wrong Combo", for: .normal)
            self.answerCorrect = false
        } else {
            comboCheckButton.setTitle("Correct Combo", for: .normal)
            self.answerCorrect = true
        }
    }
    
    func fireCannonball() {
        if self.notFired {
            self.notFired = false
            let shipCenter = self.ship.center
            let oldCenter = self.cannonball.center
            let newCenter = CGPoint(x: shipCenter.x, y: shipCenter.y + 50.0)
            let oldSize = 65.0
            let newSize = 15.0
            
            self.hitShip(self.answerCorrect, shipCenter, oldCenter, newCenter, oldSize, newSize)
            
            self.notFired = true
        }
    }
    
    func hitShip(_ answer:Bool, _ shipCenter:CGPoint, _ oldCenter:CGPoint,
                 _ newCenter:CGPoint, _ oldSize : CGFloat, _ newSize: CGFloat) {
        // rising
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
            let toSize = newSize + 15.0
            self.cannonball.frame = CGRect(x: newCenter.x-(toSize/2),
                                           y: newCenter.y - 60.0,
                                           width: toSize, height: toSize)
        }) { (success: Bool) in
            
            // falling and hit ship
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                self.cannonball.frame = CGRect(x: newCenter.x-(newSize/2),
                                               y: newCenter.y,
                                               width: newSize, height: newSize)
            }) { (success: Bool) in
                
                if answer {
                    // change ship to explosion and bring in new ship
                    self.sinkShip(shipCenter, oldCenter, newCenter, oldSize, newSize)
                } else {
                    // bounce cannonball off ship and sail away
                    // TODO: only sail away if third fail
                    self.bounceOffShip(shipCenter, oldCenter, newCenter, oldSize, newSize)
                }
            }
        }
    }  // end of hitShip
    
    func sinkShip(_ shipCenter:CGPoint, _ oldCenter:CGPoint, _ newCenter:CGPoint,
                        _ oldSize : CGFloat, _ newSize: CGFloat) {
        self.cannonball.frame = CGRect(x: oldCenter.x-(oldSize/2),
                                       y: oldCenter.y-(oldSize/2),
                                       width: oldSize, height: oldSize)
        self.ship.image = UIImage(named: "ship-burn")
        
        // fade ship
        UIView.animate(withDuration: 2.0, delay: 0, options: .curveEaseIn, animations: {
            self.ship.alpha = 0
        }) { (success: Bool) in
            self.ship.image = UIImage(named: "ship")
            // bring in new ship
            self.bringInNewShip(shipCenter, oldCenter, newCenter, oldSize, newSize)
        }
    }  // end of sinkShip
    
    func bringInNewShip(_ shipCenter:CGPoint, _ oldCenter:CGPoint, _ newCenter:CGPoint,
                  _ oldSize : CGFloat, _ newSize: CGFloat) {
        // bring in a ship from the right side of the screen
        self.ship.frame = CGRect(x: 414,
                                 y: shipCenter.y-80,
                                 width: 160, height: 160)
        self.ship.alpha = 1
        self.cannonball.alpha = 1
        
        UIView.animate(withDuration: 2.0, delay: 0, options: .curveLinear, animations: {
            self.ship.frame = CGRect(x: shipCenter.x-80,
                                     y: shipCenter.y-80,
                                     width: 160, height: 160)
        }) { (success: Bool) in
        }
    }  // end of bringInNewShip
    
    func bounceOffShip(_ shipCenter:CGPoint, _ oldCenter:CGPoint, _ newCenter:CGPoint,
                       _ oldSize : CGFloat, _ newSize: CGFloat) {
        // bounce off Ship
        let growth = 5.0
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.cannonball.frame = CGRect(x: newCenter.x + 5.0,
                                           y: newCenter.y,
                                           width: newSize+growth,
                                           height: newSize+growth)
        }) { (success: Bool) in
            
            // go off to the side
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.cannonball.frame = CGRect(x: newCenter.x + 5.0,
                                               y: newCenter.y+30.0,
                                               width: newSize+growth, height: newSize+growth)
            }) { (success: Bool) in
                
                // land in water
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                    self.cannonball.frame = CGRect(x: newCenter.x + 5.0,
                                                   y: newCenter.y+30.0,
                                                   width: newSize+growth, height: newSize+growth)
                }) { (success: Bool) in
                    
                    // cannonball fades and ship sails away
                    UIView.animate(withDuration: 2.0, delay: 0, options: .curveLinear, animations: {
                        self.cannonball.alpha = 0
                        self.ship.frame = CGRect(x: -160,
                                                 y: shipCenter.y-80,
                                                 width: 160, height: 160)
                    }) { (success: Bool) in
                        
                        // reset cannonball location and size
                        self.cannonball.frame = CGRect(x: oldCenter.x-(oldSize/2),
                                                       y: oldCenter.y-(oldSize/2),
                                                       width: oldSize, height: oldSize)
                        self.bringInNewShip(shipCenter, oldCenter, newCenter, oldSize, newSize)
                    }
                }
            }

        } // end of bounceOffShip
    }
}

