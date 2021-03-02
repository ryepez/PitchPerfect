//
//  RecordSoundsViewController.swift
//  pitchPerfect
//
//  Created by Ramon Yepez on 2/18/21.
//
import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    // outlets
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordButton: UIButton!
    
    //Property
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // disabling the stop button when the app first run.
        stopRecordButton.isEnabled = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
    }
    @IBAction func recordAudio(_ sender: Any) {
     // calling and setting the UI function to true
        configureUITwo(true)

        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
           let recordingName = "recordedVoice.wav"
           let pathArray = [dirPath, recordingName]
           let filePath = URL(string: pathArray.joined(separator: "/"))

           let session = AVAudioSession.sharedInstance()
           try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

           try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        //making the audioRecoreder the delegate
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    @IBAction func stopRecording(_ sender: Any) {
        //calling the UI configuration function and setting to false
        configureUITwo(false)

        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    //function that check if the recording is finished and makes seque
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Something went wrong with the recording")
        }
    }

//it makes preparation for the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playerSound = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playerSound.recordedAudioURL = recordedAudioURL
            
        }
        
    }
    
    func configureUITwo(_ playState: Bool) {
        // if the playState is true will make recording button disable becuase it will false
        recordButton.isEnabled = !playState
        //if playState is true will make the button true, if playState is false, enable wil be false too.
        stopRecordButton.isEnabled = playState
        // using a ternary condition to set the text label
        recordingLabel.text = playState ? "Recording..." : "Tap to Record"
    
                   
    }
    
    
}

