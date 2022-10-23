//
//  IntroViewController.swift
//  Abuse Helper
//
//  Created by Alex Hynds on 10/22/22.
//

import Foundation
import UIKit
import AVFoundation

class IntroViewController: UIViewController {
    
    var layer: AVPlayerLayer! = AVPlayerLayer()
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        
        guard let path = Bundle.main.path(forResource: "intro-animation", ofType: "mp4") else {
            print("Logo animation not found.")
            return
        }
        
        var playerLayer = AVPlayerLayer()
        var avPlayer = AVPlayer()
        
        let playerItem = AVPlayerItem(url: URL(fileURLWithPath: path))
        avPlayer = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: avPlayer)
        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.view.layer.addSublayer(playerLayer)
        self.view.layer.sublayers?[0].backgroundColor = UIColor.clear.cgColor
        avPlayer.play()
        
        delay(2.4, completion: {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.performSegue(withIdentifier: "fadeSegue", sender: self)
        })
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layer.frame = self.view.layer.bounds
    }
    
    
}
