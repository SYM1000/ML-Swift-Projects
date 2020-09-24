//
//  ContentView.swift
//  Speech-Recognition
//
//  Created by Santiago Yeomans on 22/09/20.
//  Copyright © 2020 Santiago Yeomans. All rights reserved.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    var body: some View {
        
        Button(action: {
            hablar()
        }) {
            Text("Hablar")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func hablar(){
    
    let speechSynthesizer = AVSpeechSynthesizer()
    let voice = AVSpeechSynthesisVoice(language: "Spanish")
    let espanol = AVSpeechUtterance(string: "Puto el que me oiga")
    espanol.voice = voice
    
    let utterance = AVSpeechUtterance(string: "hello mother fucker")
    speechSynthesizer.speak(espanol)
}
