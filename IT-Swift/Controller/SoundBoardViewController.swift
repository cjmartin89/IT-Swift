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
            playSound(selectedSoundFileName: "Boys")
        case 2:
            print(sender.tag)
            playSound(selectedSoundFileName: "I Can't")
        case 3:
            print(sender.tag)
            playSound(selectedSoundFileName: "Excited")
        case 4:
            print(sender.tag)
            playSound(selectedSoundFileName: "Cocotaso")
        case 5:
            print(sender.tag)
            playSound(selectedSoundFileName: "Coffee Stir")
        case 6:
            print(sender.tag)
            playSound(selectedSoundFileName: "Goodbye")
        case 7:
            print(sender.tag)
            playSound(selectedSoundFileName: "Force It")
        case 8:
            print(sender.tag)
            playSound(selectedSoundFileName: "Handle It")
        case 9:
            print(sender.tag)
            playSound(selectedSoundFileName: "What")
        case 10:
            print(sender.tag)
            playSound(selectedSoundFileName: "Where Charles")
        case 11:
            print(sender.tag)
            playSound(selectedSoundFileName: "Chihuahua 2")
        case 12:
            print(sender.tag)
            playSound(selectedSoundFileName: "Laugh")
        case 13:
            print(sender.tag)
            playSound(selectedSoundFileName: "Lil Boy")
        case 14:
            print(sender.tag)
            playSound(selectedSoundFileName: "Lunch")
        case 15:
            print(sender.tag)
            playSound(selectedSoundFileName: "Mmmm")
        case 16:
            print(sender.tag)
            playSound(selectedSoundFileName: "Monkey")
        case 17:
            print(sender.tag)
            playSound(selectedSoundFileName: "Protocol")
        case 18:
            print(sender.tag)
            playSound(selectedSoundFileName: "QRU")
        case 19:
            print(sender.tag)
            playSound(selectedSoundFileName: "Serious")
        case 20:
            print(sender.tag)
            playSound(selectedSoundFileName: "That Big")
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
