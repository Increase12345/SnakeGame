//
//  ContentView.swift
//  Snake
//
//  Created by Nick Pavlov on 6/13/23.
//

import SwiftUI

struct ContentView: View {
    enum direction {
        case up, down, left, right
    }
    
    let minX = UIScreen.main.bounds.minX
    let maxX = UIScreen.main.bounds.maxX
    let minY = UIScreen.main.bounds.minY
    let maxY = UIScreen.main.bounds.maxY
    
    @State private var startPos: CGPoint = .zero
    @State private var isStarted = true
    @State private var gameOver = false
    @State private var dir = direction.down
    @State private var posArray = [CGPoint(x: 0, y: 0)]
    @State private var foodPos = CGPoint(x: 0, y: 0)
    let snakeSize: CGFloat = 15
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Background color
            Color(red: 0.7, green: 0.9, blue: 0.3)
            
            ZStack {
                ForEach(0..<posArray.count, id: \.self) { index in
                    Rectangle()
                        .frame(width: snakeSize, height: snakeSize)
                    // Snake color
                        .foregroundColor(Color(red: 0.1, green: 0.3, blue: 0.6))
                        .position(posArray[index])
                }
                Rectangle()
                    .fill(Color(red: 0.6, green: 0.2, blue: 0.1))
                    .frame(width: snakeSize, height: snakeSize)
                    .position(foodPos)
            }
                
                if gameOver {
                    VStack(spacing: 10) {
                        Text("Game Over")
                        Text("Score: \(posArray.count - 1)")
                        Button {
                            AppState.shared.gameID = UUID()
                        } label: {
                            Text("New Game")
                                .foregroundColor(Color(red: 0.1, green: 0.3, blue: 0.6))
                        }
                    }
                    .font(.largeTitle)
                }
            }
            .onAppear() {
                foodPos = changeRectPosition()
                posArray[0] = changeRectPosition()
            }
            .gesture(DragGesture()
                .onChanged { gesture in
                    if isStarted {
                        startPos = gesture.location
                        isStarted.toggle()
                    }
                }
                .onEnded { gesture in
                    let xDis = abs(gesture.location.x - startPos.x)
                    let yDis = abs(gesture.location.y - startPos.y)
                    if startPos.y < gesture.location.y && yDis > xDis {
                        dir = direction.down
                    } else if startPos.y > gesture.location.y && yDis > xDis {
                        dir = direction.up
                    } else if startPos.x > gesture.location.x && yDis < xDis {
                        dir = direction.right
                    } else if startPos.x < gesture.location.x && yDis < xDis {
                        dir = direction.left
                    }
                    isStarted.toggle()
                }
            )
            .onReceive(timer) { (_) in
                if !gameOver {
                    changeDirection()
                    if posArray[0] == foodPos {
                        posArray.append(posArray[0])
                        foodPos = changeRectPosition()
                    }
                }
            }
            .ignoresSafeArea()
    }
    
    func changeDirection() {
        if posArray[0].x < minX || posArray[0].x > maxX && !gameOver {
            gameOver.toggle()
        } else if posArray[0].y < minY || posArray[0].y > maxY && !gameOver {
            gameOver.toggle()
        }
        
        var prev = posArray[0]
        if dir == .down {
            posArray[0].y += snakeSize
        } else if dir == .up {
            posArray[0].y -= snakeSize
        } else if dir == .left {
            posArray[0].x += snakeSize
        } else {
            posArray[0].x -= snakeSize
        }
        
        for index in 1..<posArray.count {
            let current = posArray[index]
            posArray[index] = prev
            prev = current
        }
    }
    
    func changeRectPosition() -> CGPoint {
        let rows = Int(maxX / snakeSize)
        let columns = Int(maxY / snakeSize)
        
        let randomX = Int.random(in: 1..<rows) * Int(snakeSize)
        let randomY = Int.random(in: 1..<columns) * Int(snakeSize)
        
        return CGPoint(x: randomX, y: randomY)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
