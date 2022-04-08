//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by AlexS on 07/03/2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US", "Uganda"].shuffled()
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner",
        "Uganda": "Flag with black, yellow and red stripes of equal size repeated once, with a crested crane in the middle"
    ]
    
    @State private var answer = Int.random(in: 0...2)
    @State private var showResult = false
    @State private var resultTitle = ""
    @State private var resultMessage = ""
    @State private var score = 0
    @State private var numberOfQuestions = 0
    @State private var resultTitle2 = ""
    @State private var resultMessage2 = ""
    
    @State private var animate = false
    @State private var animationDegrees =  0.0
    @State private var tapped:Int? = nil
    @State private var scaleEffect:Double = 1.0
    
    
    var body: some View {
        ZStack{
            RadialGradient(stops:
                            [Gradient.Stop(color: Color(red: 0.1, green: 0.2, blue: 0.4), location: 0.3),
                             Gradient.Stop(color: Color(red: 0.66, green: 0.22, blue: 0.36), location: 0.3)
                            ],
                           center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
            Spacer()
            VStack {
                Spacer()
                Text("Guess The Flag")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                
                Spacer()
                HStack {
                    Text("Your Score is:")
                        .foregroundColor(.white)
                        .font(.title)
                    Text(" \(score)")
                        .foregroundColor(Color(red: 0.1, green: 0.2, blue: 0.4))
                        .font(.title)
                }
                Spacer()
                
                VStack(spacing: 15){
                    Text("Tap the flag of")
                    Text(countries[answer])
                        .foregroundStyle(.secondary)
                        .font(.headline)
                    
                    
                    VStack{
                        ForEach(0..<3) { number in
                            Button {
                                flagTapped(number)
                                tapped = number
                                withAnimation {
                                    scaleEffect /= 1.25
                                }
                                
                                withAnimation {
                                    animationDegrees += 360
                                }
                                
                            } label: {
                                Image(countries[number])
                                    .renderingMode(.original)
                                    .clipShape(Capsule())
                                    .rotation3DEffect(.degrees(tapped == number ? animationDegrees : 0), axis: (x: 1, y: 0, z: 0))
                                    .opacity(tapped == number ? 0.55 : 1)
                                    .scaleEffect(tapped == number ? 1.2 : scaleEffect)
                                    .shadow(radius: 5)
                                    .accessibilityLabel(labels[countries[number], default: "Unknown Flag"])
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
            }
            
        }
        .alert(isPresented: $showResult) {
            Alert(title: Text( numberOfQuestions == 10 ? resultTitle2 : resultTitle), message: Text(numberOfQuestions == 10 ? resultMessage2 : resultMessage), dismissButton: .default(numberOfQuestions == 10 ? Text("Play Again") : Text("Continue"), action: {
                withAnimation(.easeInOut) {
                    numberOfQuestions == 10 ? reset() : askQuestion()
                }
                
            }))
        }
     
        
    }
    
    func flagTapped(_ number:Int){
        
        if number == answer {
            resultTitle = "Correct!! 🥳"
            score += 1
            resultMessage = "Your score is \(score)"
            
        }  else {
            resultTitle = "Sorry that is Wrong ☹️"
            resultMessage = "That is the flag of \(countries[number])"
            
        }
        animate = true
        showResult.toggle()
        numberOfQuestions += 1
        resultTitle2 = "🤪🙀 Game Over!! 🤪🙀".uppercased()
        
        if score == 10 {
            resultMessage2 = "Well Done! 🥳🎉 You scored 100% !!"
        } else {
            resultMessage2 = "Your Final Score Out Of 10 is: \(score)".uppercased()
        }
    
    }
    
    
    func askQuestion(){
        countries.shuffle()
        answer = Int.random(in: 0...2)
        tapped = nil
        scaleEffect = 1.0
        animationDegrees -= 360
    }
    
    func reset(){
        score = 0
        numberOfQuestions = 0
        askQuestion()
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}
