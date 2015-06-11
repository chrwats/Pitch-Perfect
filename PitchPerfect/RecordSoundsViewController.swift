//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by CHRISTOPHER WATSON on 06/3/15.
//  Copyright (c) 2015 CWatson. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var beginRecordingButton: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    var recPaused: Bool! = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        recordingInProgress.hidden = true
        recordButton.enabled = true
        beginRecordingButton.hidden = false
        pauseButton.hidden = true

    }
   

    @IBAction func recordAudio(sender: UIButton) {
            // Record User voice
        recordButton.enabled = false
        recordingInProgress.hidden = false
        stopButton.hidden = false
        beginRecordingButton.hidden = true
        pauseButton.hidden = false

        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        //setup audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        //initialize and preprate the recorder
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    @IBAction func stopAudio(sender: UIButton) {
        recordingInProgress.hidden = true
        
        //Stop recording the users voice
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance();
        audioSession.setActive(false, error: nil)
        
    }
    
    @IBAction func PauseRecording(sender: UIButton) {
        if (!recPaused){
        audioRecorder.pause()
        // TODO:change rec. in progress label to paused
        recordingInProgress.text = "Paused"
            recPaused = true
        }else {
         audioRecorder.record()
            recordingInProgress.text = "Recording In Progress"
            recPaused = false
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag)   {
            
        //Save the recorded Audio
        recordedAudio=RecordedAudio()
        recordedAudio.filePathUrl = recorder.url
        recordedAudio.title = recorder.url.lastPathComponent
        
        //Move to the next scene - seque
        self.performSegueWithIdentifier("StopRecordingSeque", sender: recordedAudio)
        }
        else{
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
    if (segue.identifier == "StopRecordingSeque")
    {
        let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
        let data = sender as! RecordedAudio
        playSoundsVC.receivedAudio = data
    }
    }
}

