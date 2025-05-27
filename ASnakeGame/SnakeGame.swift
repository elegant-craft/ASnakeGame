import Foundation
import SwiftUI

struct SnakeGame {
    let size = 15
    var snake: [CGPoint] = [CGPoint(x: 7, y: 7)]
    var direction: Direction = .right
    var apple: CGPoint = .zero
    var isGameOver = false

    init() {
        placeApple()
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

        // Check collisions
        if newHead.x < 0 || newHead.x >= CGFloat(size) ||
            newHead.y < 0 || newHead.y >= CGFloat(size) ||
            snake.contains(newHead) {
            isGameOver = true
            return
        }

        snake.insert(newHead, at: 0)

        if newHead == apple {
            placeApple()
        } else {
            snake.removeLast()
        }
    }
}

