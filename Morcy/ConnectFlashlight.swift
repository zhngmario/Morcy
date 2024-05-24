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
    
    func morseToFlashlight(morseCode: String) {
        let dotDuration: TimeInterval = 1.0
        let dashDuration: TimeInterval = 3.0
        let betweenCodeDuration: TimeInterval = 1.0
        let betweenLetterDuration: TimeInterval = 3.0
        let betweenWordDuration: TimeInterval = 7.0
        
        DispatchQueue.global().async{
            for symbol in morseCode {
                switch symbol {
                case ".":
                    self.flashLightOn(for: dotDuration)
                case "-":
                    self.flashLightOn(for: dashDuration)
                case "/":
                    Thread.sleep(forTimeInterval: betweenWordDuration)
                default:
                    Thread.sleep(forTimeInterval: betweenLetterDuration)
                }
                Thread.sleep(forTimeInterval: betweenCodeDuration)
            }
        }
    }
    
    private func flashLightOn(for duration: TimeInterval) {
        toggleFlashlight(isOn: true)
        Thread.sleep(forTimeInterval: duration)
        toggleFlashlight(isOn: false)
    }
}
