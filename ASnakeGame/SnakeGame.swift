import Foundation
import SwiftUI

struct SnakeGame {
    var size: Int = 15 // 控制列数，行数视 ContentView 控制是否显示

    var snake: [CGPoint] = [CGPoint(x: 7, y: 7)]
    var snakeDirection: [Direction] = [.right]
    
    var direction: Direction = .right
    var apple: CGPoint = .zero
    var isGameOver = false
    var score: Int = 0

    init(size: Int = 15) {
        self.size = size
        placeApple()
        for _ in 1...2 {
            var newHead = snake[0]
            newHead.x += 1
            
            snake.insert(newHead, at: 0)
            snakeDirection.append(.right)
        }
    }

    mutating func placeApple() {
        repeat {
            apple = CGPoint(x: CGFloat(Int.random(in: 0..<size)),
                            y: CGFloat(Int.random(in: 0..<size)))
        } while snake.contains(apple)
    }

    mutating func update() {
        guard !isGameOver else { return }
        var newHead = snake[0]
        switch direction {
        case .up: newHead.y -= 1
        case .down: newHead.y += 1
        case .left: newHead.x -= 1
        case .right: newHead.x += 1
        }

        if newHead.x < 0 || newHead.x >= CGFloat(size) ||
            newHead.y < 0 || newHead.y >= CGFloat(size) ||
            snake.contains(newHead) {
            isGameOver = true
            return
        }

        snake.insert(newHead, at: 0)
        snakeDirection.insert(direction, at: 0)

        if newHead == apple {
            score += 1
            placeApple()
        } else {
            snake.removeLast()
            
            snakeDirection.removeLast()
        }
        
        print("=====snake=====")
        print("\(snakeDirection)")
        print("=====snake=====")
    }
}
