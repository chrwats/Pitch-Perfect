//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by CHRISTOPHER WATSON on 06/4/15.
//  Copyright (c) 2015 CWatson. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPLayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile:AVAudioFile!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
  
        audioPLayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPLayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
    }
        // Plays sound slowly(snail icon) on recordSoundsViewController
    @IBAction func playSlowSound(sender: UIButton) {
        audioPLayer.stop()
        audioPLayer.currentTime = 0.0
        audioPLayer.rate = 0.5
        audioPLayer.play()
        
    }
    
        // Plays sound quickly(rabbit icon) on recordSoundsViewController
    @IBAction func playFastSound(sender: UIButton) {
        audioPLayer.stop()
        audioPLayer.currentTime = 0.0
        audioPLayer.rate = 1.5
        audioPLayer.play()
    }
    
        // Plays sound with a higher pitch(chipmunk icon) on recordSoundsViewController
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
        
    
    }

        // Plays sound with a lower pitch(darth vader icon) on recordSoundsViewController
    @IBAction func playVaderButton(sender: UIButton) {
        playAudioWithVariablePitch(-1000)

    }
    
        //Adjust the pitch and play audio(2 methods - playChipmunkAudio and playVaderAudio)
    func playAudioWithVariablePitch(pitch:Float){
        
        //reset any audio playback
        audioReset()
        var audioPlayerNode = AVAudioPlayerNode()

        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    
    }

    // Play sound with reverb added
    @IBAction func playReverb(sender: UIButton) {
        //reset any audio playback
        audioReset()
        
        //audioEngine.detachNode(reverbNode)
        var audioPlayerNode = AVAudioPlayerNode()

        audioEngine.attachNode(audioPlayerNode)
        var reverbNode = AVAudioUnitReverb()
        reverbNode.loadFactoryPreset( AVAudioUnitReverbPreset.Cathedral)
        reverbNode.wetDryMix = 60
        audioEngine.stop()
        // Attach the audio effect node corresponding to the user selected effect
        audioEngine.attachNode(reverbNode)
        
        // Connect Player --> AudioEffect
        audioEngine.connect(audioPlayerNode, to: reverbNode, format: audioFile.processingFormat)
        // Connect AudioEffect --> Output
        audioEngine.connect(reverbNode, to: audioEngine.outputNode, format: audioFile.processingFormat)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler:nil)
        
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        
    }
    
    // Play sound with Echo added
    @IBAction func playEcho(sender: AnyObject) {
        //reset any audio playback
        audioReset()
        
        var echoNode = AVAudioUnitDelay()
        echoNode.delayTime = NSTimeInterval(0.3)
        var audioPlayerNode = AVAudioPlayerNode()

        audioEngine.attachNode(audioPlayerNode)
        
        audioEngine.attachNode(echoNode)
        
        // Connect Player --> AudioEffect
        audioEngine.connect(audioPlayerNode, to: echoNode, format: audioFile.processingFormat)
        // Connect AudioEffect --> Output
        audioEngine.connect(echoNode, to: audioEngine.outputNode, format: audioFile.processingFormat)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler:nil)
        
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func audioReset (){
        audioPLayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
  

}
