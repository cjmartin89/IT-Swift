//
//  SoundBoard2ViewController.swift
//  IT-Swift
//
//  Created by Chris Martin on 12/26/17.
//  Copyright © 2017 Martin Technical Solutions. All rights reserved.
//

import UIKit
import AVFoundation

class SoundBoard2ViewController: UIViewController {

    var player : AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func soundButtonPressed(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            print(sender.tag)
            playSound(selectedSoundFileName: "Buen Provecho")
        case 2:
            print(sender.tag)
            playSound(selectedSoundFileName: "Flea Bags")
        case 3:
            print(sender.tag)
            playSound(selectedSoundFileName: "Bully")
        case 4:
            print(sender.tag)
            playSound(selectedSoundFileName: "Check")
        case 5:
            print(sender.tag)
            playSound(selectedSoundFileName: "Cry")
        case 6:
            print(sender.tag)
            playSound(selectedSoundFileName: "Eric")
        case 7:
            print(sender.tag)
            playSound(selectedSoundFileName: "For What")
        case 8:
            print(sender.tag)
            playSound(selectedSoundFileName: "Get Ya")
        case 9:
            print(sender.tag)
            playSound(selectedSoundFileName: "Hell")
        case 10:
            print(sender.tag)
            playSound(selectedSoundFileName: "Leaves")
        case 11:
            print(sender.tag)
            playSound(selectedSoundFileName: "Morenga")
        case 12:
            print(sender.tag)
            playSound(selectedSoundFileName: "Scares Me")
        case 13:
            print(sender.tag)
            playSound(selectedSoundFileName: "Too Close")
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
