//
//  SoundBoardViewController.swift
//  IT-Swift
//
//  Created by Chris Martin on 11/26/17.
//  Copyright © 2017 Martin Technical Solutions. All rights reserved.
//

import UIKit
import AVFoundation

class SoundBoardViewController: UIViewController {

//    var selectedSoundFileName : String = ""
    
    var player : AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func buttonPressed(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            print(sender.tag)
            playSound(selectedSoundFileName: "Charles - Earth Mother")
        case 2:
            print(sender.tag)
            playSound(selectedSoundFileName: "I Cant")
        case 3:
            print(sender.tag)
            playSound(selectedSoundFileName: "Huh")
        case 4:
            print(sender.tag)
            playSound(selectedSoundFileName: "Cocotaso")
        case 5:
            print(sender.tag)
            playSound(selectedSoundFileName: "Coffee Stir - Fast")
        case 6:
            print(sender.tag)
            playSound(selectedSoundFileName: "Coffee Stir")
        case 7:
            print(sender.tag)
            playSound(selectedSoundFileName: "Force It")
        case 8:
            print(sender.tag)
            playSound(selectedSoundFileName: "Frank - Right Now")
        case 9:
            print(sender.tag)
            playSound(selectedSoundFileName: "What")
        case 10:
            print(sender.tag)
            playSound(selectedSoundFileName: "Where Charles")
        case 11:
            print(sender.tag)
            playSound(selectedSoundFileName: "Chihuahua")
        case 12:
            print(sender.tag)
            playSound(selectedSoundFileName: "Chihuahua 2")
        default:
            print(sender.tag)
            print("No Sound")
        }
    }
    
    func playSound(selectedSoundFileName : String) {
        
        let soundUrl = Bundle.main.url(forResource: selectedSoundFileName, withExtension: "wav")!
        
        do {
            
            player = try AVAudioPlayer(contentsOf: soundUrl)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
            
        } catch let error as NSError {
            
            print(error)
        }
        
    }

    
    
}
