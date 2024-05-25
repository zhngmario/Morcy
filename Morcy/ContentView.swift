//
//  ContentView.swift
//  Morcy
//
//  Created by Mario Zheng on 15/05/24.
//

import SwiftUI

struct ContentView: View {
    @State var isFlashlightOn = true
    @State var helpOn = false
    @State var isRecording = false
    @State var recognizingText = false
    @State var detectedText : String = ""
    @State var isEnglishSelected = true
    @State var selectedLanguage = "en-US"
    
    @ObservedObject var flashlightView = ConnectFlashlight()
    @ObservedObject var speechView = SpeechRecognition(languageCode: "en-US")
    
    let languages = ["en-US": "English (US)", "id-ID": "Bahasa Indonesia"]
    
    var body: some View {
        ZStack {
            VStack{
                HStack{
                    Picker("Select Language", selection: $selectedLanguage) {
                        ForEach(languages.keys.sorted(), id: \.self) { key in
                            Text(languages[key] ?? key).tag(key) }
                    }.accentColor(.black)
                        .pickerStyle(MenuPickerStyle())
                    .onChange(of: selectedLanguage) { value in speechView.setLanguageCode(value) }
                    Spacer()
                    Button(
                        action: {
                            helpOn.toggle()
                        }
                    ){
                        Image(systemName: helpOn ? "questionmark.circle" : "questionmark.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.gray.opacity(0.5))
                    }
                } .padding()
                Spacer()
            }
            VStack{
                HStack{
                    Spacer()
                    Image("MorcyWhite")
                        .resizable()
                        .frame(width: 220, height: 220)
                    Spacer()
                }
                Spacer()
                if recognizingText == false{
                    Text("Enter text...")
                        .font(.system(size: 100, weight:.semibold, design: .rounded))
                        .foregroundStyle(.gray.opacity(0.5))
                }
                else if recognizingText == true && detectedText == ""{
                    Text(speechView.recognizedText ?? "")
                        .font(.system(size: 100, weight:.semibold, design: .rounded))
                }
                else if recognizingText == true && detectedText != "" {
                    Text(detectedText)
                        .font(.system(size: 100, weight:.semibold, design: .rounded))
                }
                Spacer()
                
                Button {
                    speechView.recognizedText = ""
                    detectedText = ""
                } label: {
                    Image(systemName: "gobackward")
                        .resizable()
                        .frame(width: 40, height: 45)
                        .foregroundColor(.gray.opacity(0.5))
                }
                
                Spacer()
                
                HStack(spacing: 30) {
                    Button(
                        action: {
                            isRecording.toggle()
                            recognizingText = true
                            if isRecording == true {
                                speechView.start()
                            }
                            else {
                                speechView.stop()
                                detectedText = speechView.recognizedText ?? ""
                            }
                    }
                            
                    ){
                        Image(systemName: isRecording ? "stop.circle" :  "mic.circle.fill")
                            .resizable()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.morcyRed)
                    }
                    Button(
                        action:  {
                            flashlightView.isFlashlightOn.toggle()
                            isFlashlightOn.toggle()
                            let morsedText = MorseCode.textToMorse(text: detectedText)
                            flashlightView.morseToFlashlight(morseCode: morsedText)
                            }
                    ){
                        Image(systemName: isFlashlightOn ?  "flashlight.off.circle.fill" : "flashlight.on.circle.fill")
                            .resizable()
                            .frame(width: 120, height: 120)
                            .foregroundColor(isFlashlightOn ? Color.gray.opacity(0.5) : Color.black)
                    }
                }          
            }
        }
        .padding()
    
    }
}

#Preview {
    ContentView()
}
