//
//  ConnectFlashlight.swift
//  Morcy
//
//  Created by Mario Zheng on 24/05/24.
//


import Foundation
import AVFoundation

class ConnectFlashlight : ObservableObject {
    @Published var isFlashlightOn: Bool = false {
        didSet {
            toggleFlashlight(isOn: isFlashlightOn)
        }
    }
    
    private let device = AVCaptureDevice.default(for: .video)
    private var dotAudioPlayer: AVAudioPlayer?
    private var dashAudioPlayer: AVAudioPlayer?
    private var isCancelled = false
    
    private func toggleFlashlight(isOn: Bool) {
        guard let device = device, device.hasTorch else { return }
        do {
            try device.lockForConfiguration()
            device.torchMode = isOn ? .on : .off
            device.unlockForConfiguration()
        } catch {
            print("Flashlight unavailable")
        }
    }
    
    func morseToFlashlight(morseCode: String, flashCallback: @escaping (Bool) -> Void, completion: @escaping () -> Void) {
        let dotDuration: TimeInterval = 1.0
        let dashDuration: TimeInterval = 3.0
        let betweenCodeDuration: TimeInterval = 1.0
        let betweenLetterDuration: TimeInterval = 3.0
        let betweenWordDuration: TimeInterval = 7.0
        
        DispatchQueue.global().async{
            for symbol in morseCode {
                switch symbol {
                case ".":
                    self.flashLightOn(for: dotDuration, flashCallback: flashCallback, isDot: true)
                case "-":
                    self.flashLightOn(for: dashDuration, flashCallback: flashCallback, isDot: false)
                case "/":
                    flashCallback(false)
                    Thread.sleep(forTimeInterval: betweenWordDuration)
                default:
                    flashCallback(false)
                    Thread.sleep(forTimeInterval: betweenLetterDuration)
                }
                flashCallback(false)
                Thread.sleep(forTimeInterval: betweenCodeDuration)
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    private func flashLightOn(for duration: TimeInterval, flashCallback: @escaping (Bool) -> Void, isDot: Bool) {
        DispatchQueue.main.async {
            flashCallback(true)
            self.toggleFlashlight(isOn: true)
            self.playSound(isDot: isDot)
        }
        Thread.sleep(forTimeInterval: duration)
        DispatchQueue.main.async {
            self.toggleFlashlight(isOn: false)
            flashCallback(false)
            self.stopSound(isDot: isDot)
        }
    }
    
    func cancelMorseToFlashlight() {
        isCancelled = true
    }
    
    private func playSound(isDot: Bool) {
        let soundFileName = isDot ? "dotMorse" : "dashMorse"
        guard let soundURL = Bundle.main.url(forResource: soundFileName, withExtension: "wav") else { return }
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            if isDot {
                dotAudioPlayer = audioPlayer
                dotAudioPlayer?.play()
            } else {
                dashAudioPlayer = audioPlayer
                dashAudioPlayer?.play()
            }
        } catch {
            print("Audio unavailable")
        }
    }
    
    private func stopSound(isDot: Bool) {
        if isDot {
            dotAudioPlayer?.stop()
        } else {
            dashAudioPlayer?.stop()
        }
    }
}
