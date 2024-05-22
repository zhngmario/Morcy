//
//  SpeechRecognition.swift
//  Morcy
//
//  Created by Mario Zheng on 20/05/24.
//

import Foundation
import Speech
import SwiftUI

final class SpeechRecognition: NSObject, ObservableObject, SFSpeechRecognizerDelegate {
    private let audioEngine = AVAudioEngine()
    private var inputNode: AVAudioInputNode?
    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var audioSession: AVAudioSession?
    
    @Published var recognizedText: String?
    @Published var isProcessing: Bool = false

    init(inputNode: AVAudioInputNode? = nil, speechRecognizer: SFSpeechRecognizer? = nil, recognitionRequest: SFSpeechAudioBufferRecognitionRequest? = nil, recognitionTask: SFSpeechRecognitionTask? = nil, audioSession: AVAudioSession? = nil, recognizedText: String? = nil, isProcessing: Bool = false) {
        self.inputNode = inputNode
        self.speechRecognizer = speechRecognizer
        self.recognitionRequest = recognitionRequest
        self.recognitionTask = recognitionTask
        self.audioSession = audioSession
        self.recognizedText = recognizedText
        self.isProcessing = isProcessing
    
        self.audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession?.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try audioSession?.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Couldn't configure the audio session properly")
        }
    
    }
    
    func start() {
        inputNode = audioEngine.inputNode
        
        var speechLanguage = "en-US"
        
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: speechLanguage))
        //speechRecognizer = SFSpeechRecognizer()
        print("Supports on device recognition: \(speechRecognizer?.supportsOnDeviceRecognition == true ? "✅" : "🔴")")

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        

        guard let speechRecognizer = speechRecognizer,
              speechRecognizer.isAvailable,
              let recognitionRequest = recognitionRequest,
              let inputNode = inputNode
        else {
            assertionFailure("Unable to start the speech recognition!")
            return
        }
        
        speechRecognizer.delegate = self
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            recognitionRequest.append(buffer)
        }

        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            self?.recognizedText = result?.bestTranscription.formattedString
            
            guard error != nil || result?.isFinal == true else { return }
            self?.stop()
        }

        audioEngine.prepare()
        
        do {
            try audioEngine.start()
            isProcessing = true
        } catch {
            print("Coudn't start audio engine!")
            stop()
        }
    }
    
    func stop() {
        recognitionTask?.cancel()
        
        audioEngine.stop()
        inputNode?.removeTap(onBus: 0)
//        try? audioSession?.setActive(false)
        audioSession = nil
        inputNode = nil
        
        isProcessing = false
        
        recognitionRequest = nil
        recognitionTask = nil
        speechRecognizer = nil
    }
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            print("✅ Available")
        } else {
            print("🔴 Unavailable")
            recognizedText = "Text recognition unavailable. Sorry!"
            stop()
        }
     }
}

