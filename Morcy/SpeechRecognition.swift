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
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var audioSession: AVAudioSession?

    @Published var recognizedText: String?
    @Published var isProcessing: Bool = false
    @Published var speechRecognizer: SFSpeechRecognizer?
    
    init(languageCode: String = "en-US") {
        super.init()
        self.speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: languageCode))
        self.audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession?.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try audioSession?.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Couldn't configure the audio session properly")
        }
    }

    func setLanguageCode(_ languageCode: String) {
        self.speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: languageCode))
    }

    func start() {
        inputNode = audioEngine.inputNode
        
        guard let speechRecognizer = speechRecognizer,
              speechRecognizer.isAvailable else {
            print("Speech recognizer not available!")
            return
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest?.shouldReportPartialResults = true

        let recordingFormat = inputNode?.outputFormat(forBus: 0)
        inputNode?.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()

        do {
            try audioEngine.start()
            isProcessing = true
        } catch {
            print("Couldn't start audio engine!")
            stop()
            return
        }

        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest!) { [weak self] result, error in
            if let result = result {
                self?.recognizedText = result.bestTranscription.formattedString
            }

            if error != nil || result?.isFinal == true {
                self?.stop()
            }
        }
    }

    func stop() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        inputNode?.removeTap(onBus: 0)
        
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest = nil
        isProcessing = false
    }

    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            print("Speech recognizer is available.")
        } else {
            print("Speech recognizer is unavailable.")
            recognizedText = "Text recognition unavailable. Sorry!"
            stop()
        }
    }
}

