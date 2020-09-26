//
//  ContentView.swift
//  Emotion-Analysis
//
//  Created by Santiago Yeomans on 24/09/20.
//  Copyright © 2020 Santiago Yeomans. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        NavigationView{
        Home()
            .navigationBarTitle("Analísis de Voz")
        }
        
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View{
    
    private var audioRecorder = AudioRecorder()
    @State private var grabando: Bool = false
    @State private var allowed: Bool = false
    @State private var emocion : String = "Presiona grabar"
    
    
    
    
    private var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return (paths.first!)
    }
    
    private var audioFilePath: URL {
        print(documentsDirectory.appendingPathComponent("recordedAudio.m4a"))
        return documentsDirectory.appendingPathComponent("recordedAudio.m4a")
    }
    
    
    var body: some View{
        VStack{
            
        Text(self.emocion)
            .font(.title)
            .bold()
            .padding(.top, 80)
            
        Spacer()
            
            VStack{
            Button(action: {
                self.grabando = !self.grabando
                self.emocion = "...."
                
                if self.grabando {
                    self.audioRecorder.startRecording(fileURL: self.audioFilePath)
                    
                } else {
                    self.audioRecorder.stopRecording()
                }
            }){
                Image(systemName: "mic.fill").font(.system(size: 40)).foregroundColor(Color.white).padding(.bottom, 4)

                
                
            }.frame(width: 70, height: 70)
                .background(grabando ? Color.red : Color.green).animation(.spring())
            .clipShape(Circle())
            
                Text(grabando ? "Grabando" : "")
                    .font(.headline)
                    .bold()
                    .animation(.spring())
            }
            
            Spacer()
            
            //boton de clasificar
            Button(action:{
                //Clasifica el sonido
                //Modelo de ML
                let audioClassifier = AudioClassifier(model: EmotionClassifier_1().model)
                
                audioClassifier?.classify(audioFile: self.audioFilePath) { result in
                    if let result = result{
                        self.emocion = result
                        print("La emocion es: \(result)")
                    }
                    
                }
                
                
            }){
                Text("Analizar audio")
                    .foregroundColor(Color.white)
                .padding()
            }
            .background(Color.gray)
            .cornerRadius(5)
            Spacer()
            
            
            
        }
        .onAppear {
            self.audioRecorder.requestPermission { (allowed) in
                DispatchQueue.main.async {
                    print(allowed)
                    self.allowed = allowed
                }
            }
        }
    }
}
