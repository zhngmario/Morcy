//
//  InstructionsView.swift
//  Morcy
//
//  Created by Mario Zheng on 27/05/24.
//

import SwiftUI

struct InstructionsView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            Image("MorcyWhite")
                .resizable()
                .frame(width: 220, height: 220)
            
            ScrollView {
                VStack(spacing: 16) {
                    VStack(spacing: 8) {
                        Image(systemName: "questionmark.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                        
                        Text("Instructions")
                            .font(.system(size: 50, weight: .semibold, design: .rounded))
                            .padding(.top, 0)
                    }
                    
                    VStack(spacing: 10) {
                        Image(systemName: "1.circle")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("Select a language you're comfortable to speak in.")
                            .font(.system(size: 24, design: .rounded))
                            .padding(.bottom)
                        Image(systemName: "2.circle")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("Tap the microphone button to start recording.")
                            .font(.system(size: 24, design: .rounded))
                            .padding(.bottom)
                        Image(systemName: "3.circle")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("""
                        After you finished talking, you can check the detected text
                        at the center of the screen.
                        """)
                        .font(.system(size: 24, design: .rounded))
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                        Image(systemName: "4.circle")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("""
                            If it is as what you desired, you can tap the stop button.
                            If it's not, you can clear it by tapping the retry button.
                            """)
                        .font(.system(size: 24, design: .rounded))
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                        Image(systemName: "5.circle")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("""
                            Translate the detected text into morse codes
                            by tapping the flashlight button.
                            
                            Dot codes will be played for 1 second
                            Dash codes will be played for 3 seconds
                            Between codes duration is 1 second
                            Between letters duration is 3 seconds
                            Between words duration is 7 seconds
                            """)
                        .font(.system(size: 24, design: .rounded))
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                    }
                    .padding()
                }
            }
            
            Button(action: {
                            isPresented = false
                        }) {
                            Text("Close")
                                .font(.system(size: 20, design: .rounded))
                                .foregroundColor(.white)
                                .padding(.vertical, 15)
                                .padding(.horizontal, 300)
                                .background(Color.black)
                                .cornerRadius(50)
                        }
                        .contentShape(Rectangle())
                    }
        .padding()
    }
}

#Preview {
    InstructionsView(isPresented: .constant(true))
}
