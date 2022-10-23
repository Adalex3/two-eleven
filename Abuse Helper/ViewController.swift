//
//  ViewController.swift
//  Abuse Helper
//
//  Created by Alex Hynds on 10/21/22.
//

import UIKit
import SpriteKit
import Alamofire
import AVFoundation
import CoreLocation
import CoreHaptics

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var directionsLabel: UILabel!
    @IBOutlet weak var vfxView: UIVisualEffectView!
    @IBOutlet weak var behindView: UIView!
    @IBOutlet weak var scoreTitleLabel: UIImageView!
    @IBOutlet weak var logoLabel: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var emergencyIcon: UIImageView!
    @IBOutlet weak var audioIcon: UIImageView!
    @IBOutlet weak var videoIcon: UIImageView!
    @IBOutlet weak var galleryIcon: UIImageView!
    
    @IBAction func newGameButton(_ sender: Any) {
        print("New game")
        hapticManager.explode(duration: 4.0)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.newGameButton.makeInvisible()
            self.skView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            self.behindView.transform = self.skView.transform
        }, completion: {_ in
            UIView.animate(withDuration: 0.25, animations: {
                self.skView.transform = CGAffineTransform(scaleX: 1.75, y: 1.75)
                self.behindView.transform = self.skView.transform
                self.skView.makeInvisible()
                self.behindView.makeInvisible()
            }, completion: {_ in
                self.skView.makeVisible()
                self.behindView.makeVisible()
                UIView.animate(withDuration: 0.5, animations: {
                    self.skView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
                    self.behindView.transform = self.skView.transform
                }, completion: {_ in
                    self.board?.startingBoard()
                    self.board?.update()
                    self.skView.presentScene(self.board!.scene)
                    self.scoreLabelAnimate(self.board!.score())
                    UIView.animate(withDuration: 1.0, delay: 0.0, animations: {
                        self.skView.transform = .identity
                        self.behindView.transform = self.skView.transform
                    }, completion: { _ in
                        self.newGameButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                        UIView.animate(withDuration: 2.0, animations: {
                            self.newGameButton.transform = .identity
                            self.newGameButton.makeVisible()
                        })
                    })
                })
            })
        })
    }
    
    let locationManager = CLLocationManager()
    
    // Live token
    let TWILIO_ACCOUNT_SID = "AC83fe2c07cccad5672e10fcc6c4e3fee1"
    let TWILIO_AUTH_TOKEN = "a0eb1b983cf36043ad43200b0046fff4"

    @IBOutlet weak var skView: SKView!
//    @IBOutlet var imageView: UIImageView
//    @IBOutlet var button: UIButton
    
    var board: Board? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        hideIcons()
        
        directionsLabel.makeInvisible()
        newGameButton.makeInvisible()
        scoreLabel.text = "0"
        scoreLabel.font = UIFont(name: "Kollektif", size: 30)
        newGameButton.titleLabel?.font = UIFont(name: "Kollektif", size: 14)
        scoreLabel.makeInvisible()
        skView.makeInvisible()
        scoreTitleLabel.makeInvisible()
        logoLabel.makeInvisible()
        behindView.makeInvisible()
        vfxView.makeInvisible()
        
        board = Board(size: skView.bounds.size)
        board!.startingBoard()
        board!.update()
        skView.presentScene(board!.scene)
        
        
        guard let path = Bundle.main.path(forResource: "rainbow", ofType: "mov") else {
            print("Rainbow animation not found.")
            return
        }
        
        var playerLayer = AVPlayerLayer()
        var avPlayer = AVPlayer()
        
        let playerItem = AVPlayerItem(url: URL(fileURLWithPath: path))
        avPlayer = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: avPlayer)
        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.view.layer.insertSublayer(playerLayer, below: self.view.layer.sublayers![0])
        self.view.layer.sublayers?[0].backgroundColor = UIColor.clear.cgColor
        avPlayer.play()
        
        delay(1.0, completion: {
            hapticManager.whoosh(1.0,1.0)
        })
        
        delay(2, completion: {
            self.setup()
            self.fadeIn()
        })

    }
    
    func hideIcons() {
        galleryIcon.makeInvisible()
        videoIcon.makeInvisible()
        audioIcon.makeInvisible()
        emergencyIcon.makeInvisible()
    }
    
    func showIcons() {
        galleryIcon.alpha = 0.5
        videoIcon.alpha = 0.5
        audioIcon.alpha = 0.5
        emergencyIcon.alpha = 0.5
    }
    
    func fadeIn() {
        UIView.animate(withDuration: 2.0, animations: {
            self.scoreLabel.makeVisible()
            self.logoLabel.makeVisible()
            self.scoreTitleLabel.makeVisible()
            self.skView.makeVisible()
            self.behindView.makeVisible()
            self.vfxView.makeVisible()
        }, completion: { _ in
            self.newGameButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 2.0, animations: {
                self.newGameButton.transform = .identity
                self.newGameButton.makeVisible()
            })
        })
    }
    
    func setup() {
        
        let LSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        LSwipe.direction = .left
        let RSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        RSwipe.direction = .right
        let USwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeUp))
        USwipe.direction = .up
        let DSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeDown))
        DSwipe.direction = .down

        self.view.addGestureRecognizer(LSwipe)
        self.view.addGestureRecognizer(RSwipe)
        self.view.addGestureRecognizer(USwipe)
        self.view.addGestureRecognizer(DSwipe)
        
    }
    
    
    
    @objc func swipeLeft() {
        print("Swipe Left")
        print(board?.positions)
        board?.swipe(direction: .left)
        handleSwipe()
    }
    
    @objc func swipeRight() {
        print("Swipe Right")
        print(board?.positions)
        board?.swipe(direction: .right)
        handleSwipe()
    }
    
    @objc func swipeUp() {
        print("Swipe Up")
        print(board?.positions)
        board?.swipe(direction: .up)
        handleSwipe()
    }
    
    @objc func swipeDown() {
        print("Swipe Down")
        print(board?.positions)
        board?.swipe(direction: .down)
        handleSwipe()
    }
    
    public func handleSwipe() {
        skView.presentScene(board!.scene)
        if(board!.checkForWin()) { win() }
        scoreLabelAnimate(board!.score())
        hapticManager.click()
    }
    
    
    func win() {
        hapticManager.explode(duration: 2)
    }
    
    
    func scoreLabelAnimate(_ number: Int) {
        
        let totalDuration = 0.5
//        var i = Int(scoreLabel.text!)!
//        let diff = number-i
        
        UIView.animate(withDuration: totalDuration, delay: 0.0, animations: {
            self.scoreLabel.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        })
        
        delay(totalDuration, completion: {
            self.scoreLabel.text = String(describing: number)
        })
        
        UIView.animate(withDuration: 0.2, delay: totalDuration, animations: {
            self.scoreLabel.transform = .identity
        })
        
    }

    
    // DECOY //
    
    
    var timer = Timer()

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touches began")
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(longPress), userInfo: nil, repeats: false)
    }

    var distFromButton: CGFloat = CGFloat(Int.max)
    
    var position = 0
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        distFromButton = distFromButton(touches.first!.location(in: self.view))
        
        if let firstTouch = touches.first {
            let oldPos = position
            let hitView = view.hitTest(firstTouch.location(in: view), with: event)
            if emergencyIcon.frame.contains(firstTouch.location(in: self.view)) {
                position = 1
            } else if audioIcon.frame.contains(firstTouch.location(in: self.view)) {
                position = 2
            } else if galleryIcon.frame.contains(firstTouch.location(in: self.view)) {
                position = 3
            } else if videoIcon.frame.contains(firstTouch.location(in: self.view)) {
                position = 4
            } else {
                position = 0
            }
            
            if (oldPos != position && position != 0) {
                hapticManager.click(1.0)
            } else if (oldPos != position && position == 0) {
                hapticManager.click(0.5)
            }
        }
        
    }
    
    func distFromButton(_ pos: CGPoint) -> CGFloat {
        return abs(pos.y-((emergencyIcon.frame.maxY+emergencyIcon.frame.minY)/2))
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touches ended")
        timer.invalidate()
        hideIcons()
        directionsLabel.makeInvisible()
        
        if let firstTouch = touches.first {
            let hitView = view.hitTest(firstTouch.location(in: view), with: event)
            if emergencyIcon.frame.contains(firstTouch.location(in: self.view)) {
                print("touch is inside emergency")
                emergency()
            } else if audioIcon.frame.contains(firstTouch.location(in: self.view)) {
                print("touch is inside audio")
                audio()
            } else if galleryIcon.frame.contains(firstTouch.location(in: self.view)) {
                print("touch is inside gallery")
                gallery()
            } else if videoIcon.frame.contains(firstTouch.location(in: self.view)) {
                print("touch is inside video")
                video()
            } else {
                print("Touch is outside.")
            }
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touches cancelled")
        timer.invalidate()
        hideIcons()
        directionsLabel.makeInvisible()
    }

    @objc func longPress() {


        print("5 seconds has passed.")
        
        hapticManager.success()
        showIcons()
        UIView.animate(withDuration: 0.3, delay: 0.0, animations: {
            self.directionsLabel.makeVisible()
        })
//
//        // Haptic drone
//        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.2)
//        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.2)
//        let continuousEvent = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0, duration: 100)
//
//        do {
//            let pattern = try CHHapticPattern(events: [continuousEvent], parameters: [])
//
//            // Create a player from the continuous haptic pattern.
//            continuousPlayer = try engine.makeAdvancedPlayer(with: pattern)
//
//        } catch let error {
//            print("Pattern Player Creation Error: \(error)")
//        }
//
        

    }
    
    
    
    //MARK: ACTIONS

    func emergency() {
        
        hapticManager.success()
        
        let url = "https://api.twilio.com/2010-04-01/Accounts/\(TWILIO_ACCOUNT_SID)/Messages"

        var body = """
Hello. You are listed as an emergency contact for Andrea Sanchez. They activated Emergency Mode in the discreet abusive relationship monitor 2^11; they may be in need of immediate help. Their current location is latitude: \(currentLocation!.coordinate.latitude), longitude: \(currentLocation!.coordinate.longitude).

http://maps.apple.com/?ll=\(currentLocation!.coordinate.latitude),\(currentLocation!.coordinate.longitude)

https://www.google.com/maps/search/?api=1&query=\(currentLocation!.coordinate.latitude)%2C\(currentLocation!.coordinate.longitude)
"""
        
        let parameters = ["From": "+17867551062", "To": "+17863167023", "Body": body]

        AF.request(url, method: .post, parameters: parameters).authenticate(username: TWILIO_ACCOUNT_SID, password: TWILIO_AUTH_TOKEN).response { response in
            print(response)
        }
        
    }
    
    var currentLocation: CLLocation?
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
    }
    
    func gallery() {
        hapticManager.success()
        present((self.storyboard?.instantiateViewController(withIdentifier: "galleryVC"))!, animated: true)
    }
    
    var captureDevice: AVCaptureDevice?
    let captureSession = AVCaptureSession()
    func video() {
        
        hapticManager.success()
        // Record video and save it to files, NOT photos library
        
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        let devices = AVCaptureDevice.devices()
        for device in devices {
            if(device.hasMediaType(AVMediaType.video)) {
                if(device.position == AVCaptureDevice.Position.back) {
                    captureDevice = device as? AVCaptureDevice
                    if captureDevice != nil {
                        beginSession()
                    }
                }
            }
        }
        
    }
    
    func beginSession() {
        var err: NSError? = nil
        
    }
    
    func audio() {
        
        hapticManager.success()
        // Record audio and save it to files, NOT voice memos
        
    }

}
