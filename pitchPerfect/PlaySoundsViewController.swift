//
//  PlaySoundsViewController.swift
//  pitchPerfect
//
//  Created by Ramon Yepez on 2/19/21.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
 // outlets 
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var labelTime: UILabel!
    //Properties
    var recordedAudioURL: URL!
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!

    enum ButtonType: Int {
        case slow = 0, fast, chipmunk, vader, echo, reverb
    }
    
    // MARK: Actions

    @IBAction func playSoundForButton(_ sender: UIButton) {
//swich statement to change the play different pitches
        switch(ButtonType(rawValue: sender.tag)!) {
            case .slow:
                playSound(rate: 0.5)
            case .fast:
                playSound(rate: 1.5)
            case .chipmunk:
                playSound(pitch: 1000)
            case .vader:
                playSound(pitch: -1000)
            case .echo:
                playSound(echo: true)
            case .reverb:
                playSound(reverb: true)
            }

            configureUI(.playing)

    }

    @IBAction func stopButtonPressed(_ sender: AnyObject) {
        
        stopAudio()

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()

        // Do any additional setup after loading the view.
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        configureUI(.notPlaying)
        
        // making sure the UI buttons do not get strech
        snailButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        chipmunkButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        rabbitButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        vaderButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        echoButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        snailButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        reverbButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFit

        // this code gets info about the recorded file to get duration.
        do
            {
                let avAudioPlayer = try AVAudioPlayer (contentsOf:recordedAudioURL)
               let duration = avAudioPlayer.duration
                let sec = Int(duration.truncatingRemainder(dividingBy:60.0))
                let minutes = Int(duration / 60) % 60
                labelTime.text = (NSString(format: "Duration: %0.2d:%0.2d",minutes,sec)) as String
            }
            catch{
                print(error)
            }
    }
    // this function will stop the sounds after the view disapper. 
    override func viewDidDisappear(_ animated: Bool) {
            stopAudio()
        }
    
    
}
