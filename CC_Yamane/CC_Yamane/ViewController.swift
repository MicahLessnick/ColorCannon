//
//  ViewController.swift
//  CC_Yamane
//
//  Created by  on 11/14/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var cannonball: UIImageView!
    @IBOutlet weak var ship: UIImageView!
    var notFired = true
    var answerCorrect = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // instead of collision detection, let's use a simple animation because the boat
    // and the cannon will always be in the same places
    @IBAction func fireButton_pressed(_ sender: UIButton) {
        self.fireCannonball()
    }
    
    func fireCannonball() {
        if self.notFired {
            self.notFired = false
            let shipCenter = self.ship.center
            let oldCenter = self.cannonball.center
            let newCenter = CGPoint(x: shipCenter.x, y: shipCenter.y + 50.0)
            let oldSize = 65.0
            let newSize = 15.0
            
            hitShip(answerCorrect, shipCenter, oldCenter, newCenter, oldSize, newSize)
            
            self.notFired = true
        }
        
        func bringInNewShip() {
            
        }
        
        func hitShip(_ answer:Bool, _ shipCenter:CGPoint, _ oldCenter:CGPoint, _ newCenter:CGPoint, _ oldSize : CGFloat, _ newSize: CGFloat) {
            // rising
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
                let toSize = newSize + 15.0
                self.cannonball.frame = CGRect(x: newCenter.x-(toSize/2), y: newCenter.y - 60.0, width: toSize, height: toSize)
            }) { (success: Bool) in
                
                // falling and hit ship
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                    self.cannonball.frame = CGRect(x: newCenter.x-(newSize/2), y: newCenter.y, width: newSize, height: newSize)
                }) { (success: Bool) in
                    
                    if answer {
                        // change ship to explosion and bring in new ship
                        bringInNewShip(shipCenter, oldCenter, newCenter, oldSize, newSize)
                    } else {
                        // bounce cannonball off ship and sail away
                        bounceOffShip(shipCenter, oldCenter, newCenter, oldSize, newSize)
                    }
                }
            }
        }  // end of hitShip
        
        func bringInNewShip(_ shipCenter:CGPoint, _ oldCenter:CGPoint, _ newCenter:CGPoint, _ oldSize : CGFloat, _ newSize: CGFloat) {
            // bounce off Ship
            let growth = 5.0
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
                self.cannonball.frame = CGRect(x: newCenter.x + 5.0, y: newCenter.y, width: newSize+growth, height: newSize+growth)
            }) { (success: Bool) in
                
                // land in water
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                    self.cannonball.frame = CGRect(x: newCenter.x + 5.0, y: newCenter.y+30.0, width: newSize+growth, height: newSize+growth)
                }) { (success: Bool) in
                    
                    // land in water
                    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                        self.cannonball.frame = CGRect(x: newCenter.x + 5.0, y: newCenter.y+30.0, width: newSize+growth, height: newSize+growth)
                    }) { (success: Bool) in
                        
                        // reset cannonball location and size
                        self.cannonball.frame = CGRect(x: oldCenter.x-(oldSize/2), y: oldCenter.y-(oldSize/2), width: oldSize, height: oldSize)
                        
                    }
                }
            }
        }  // end of bringInNewShip
        
        func bounceOffShip(_ shipCenter:CGPoint, _ oldCenter:CGPoint, _ newCenter:CGPoint, _ oldSize : CGFloat, _ newSize: CGFloat) {
            // bounce off Ship
            let growth = 5.0
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
                self.cannonball.frame = CGRect(x: newCenter.x + 5.0, y: newCenter.y, width: newSize+growth, height: newSize+growth)
            }) { (success: Bool) in
                
                // go off to the side
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                    self.cannonball.frame = CGRect(x: newCenter.x + 5.0, y: newCenter.y+30.0, width: newSize+growth, height: newSize+growth)
                }) { (success: Bool) in
                    
                    // land in water
                    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                        self.cannonball.frame = CGRect(x: newCenter.x + 5.0, y: newCenter.y+30.0, width: newSize+growth, height: newSize+growth)
                    }) { (success: Bool) in
                        
                        // ship sail away and cannonball fades
                        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                            self.cannonball.alpha = 0
                            self.ship.frame = CGRect(x: newCenter.x + 5.0, y: shipCenter.y+30.0, width: newSize+growth, height: newSize+growth)
                        }) { (success: Bool) in
                            
                            // reset cannonball location and size
                            self.cannonball.frame = CGRect(x: oldCenter.x-(oldSize/2), y: oldCenter.y-(oldSize/2), width: oldSize, height: oldSize)
                        }                    }
                }
            }
        } // end of bounceOffShip
        
    }
}

