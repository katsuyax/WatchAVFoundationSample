//
//  InterfaceController.swift
//  WatchAVFoundationSample WatchKit Extension
//
//  Created by katsuya on 2016/12/18.
//  Copyright © 2016年 CrossBridge. All rights reserved.
//

import WatchKit
import Foundation
import AVFoundation

class InterfaceController: WKInterfaceController {
    
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var audioFile: AVAudioFile!
    
    var speechSynthesizer: AVSpeechSynthesizer!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // AVSpeechSynthesizer
        AVSpeechSynthesisVoice.speechVoices().forEach {
            print($0.language)
        }
        
        speechSynthesizer = AVSpeechSynthesizer()
        speechSynthesizer.delegate = self

        // AVAudioEngine
        guard let path = Bundle.main.path(forResource: "se", ofType: "caf") else {
            return
        }
        
        audioEngine = AVAudioEngine()
        audioPlayerNode = AVAudioPlayerNode()
        let audioPath = URL(fileURLWithPath: path)
        audioFile = try! AVAudioFile(forReading: audioPath)
        audioEngine.attach(audioPlayerNode)
        audioEngine.connect(audioPlayerNode,
                            to: audioEngine.mainMixerNode,
                            format: audioFile.processingFormat)
        audioEngine.prepare()
        try! audioEngine.start()
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    @IBAction func hanldeButton1() {
        audioPlayerNode.scheduleFile(audioFile, at: nil) { () -> Void in
            print("complete")
        }
        audioPlayerNode.play()
    }
    
    @IBAction func handleButton2() {
        let speechUtterance = AVSpeechUtterance(string: "おはよう。こんにちは。こんばんは")
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "jp-JP")
        speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
        speechUtterance.pitchMultiplier = 1.0   // [0.5 - 2] Default = 1
        speechSynthesizer.speak(speechUtterance)
        
    }
}

extension InterfaceController: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                           didStart utterance: AVSpeechUtterance) {
        print("再生開始")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                           didFinish utterance: AVSpeechUtterance) {
        print("再生終了")
    }
}
