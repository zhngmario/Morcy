//
//  MorseCode.swift
//  Morcy
//
//  Created by Mario Zheng on 24/05/24.
//

import Foundation

struct MorseCode {
    static func textToMorse(text : String) -> String {
        let morseCodeDictionary: [Character: String] = [
            "A": ".-", "B": "-...",
            "C": "-.-.", "D": "-..",
            "E": ".", "F": "..-.",
            "G": "--.", "H": "....",
            "I": "..", "J": ".---",
            "K": "-.-", "L": ".-..",
            "M": "--", "N": "-.",
            "O": "---", "P": ".--.",
            "Q": "--.-", "R": ".-.",
            "S": "...", "T": "-",
            "U": "..-", "V": "...-",
            "W": ".--", "X": "-..-",
            "Y": "-.--", "Z": "--..",
            
            "0": "-----",
            "1": ".----",
            "2": "..---",
            "3": "...--",
            "4": "....-",
            "5": ".....",
            "6": "-....",
            "7": "--...",
            "8": "---..",
            "9": "----."
        ]
        
        return text.uppercased().compactMap { morseCodeDictionary[$0] }.joined(separator: "")
        
    }
}


