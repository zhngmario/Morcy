//
//  ContentView.swift
//  Morcy
//
//  Created by Mario Zheng on 15/05/24.
//

import SwiftUI

struct ContentView: View {
    @State var isFlashlightOn = false
    @State var helpOn = false
    @State var isRecording = false
    
    var body: some View {
        ZStack {
            VStack{
                HStack{
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
                Text("Recognized text here...")
                    .font(.system(size: 100, weight:.semibold, design: .rounded))
                Spacer()
                
                Button{
                    //aksi
                } label: {
                    Image(systemName: "gobackward")
                        .resizable()
                        .frame(width: 43, height: 45)
                        .foregroundColor(.gray.opacity(0.5))
                }
                
                Spacer()
                
                HStack(spacing: 30) {
                    Button(
                        action: {
                            isRecording.toggle()
                    }
                            
                    ){
                        Image(systemName: isRecording ?  "mic.circle.fill" : "stop.circle")
                            .resizable()
                            .frame(width: 130, height: 130)
                            .scaleEffect(isRecording ? 1.0 : 1.1)
                           
                            .foregroundColor(.morcyRed)
                    }
                    Button(
                        action:  {
                            isFlashlightOn.toggle()
                            // aksi
                        }
                    ){
                        Image(systemName: isFlashlightOn ?  "flashlight.off.circle.fill" : "flashlight.on.circle.fill")
                            .resizable()
                            .frame(width: 130, height: 130)
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
