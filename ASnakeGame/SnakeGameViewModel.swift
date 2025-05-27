import Foundation
import Combine

class SnakeGameViewModel: ObservableObject {
    @Published var game = SnakeGame()
    var timer: Timer?

    func start() {
        game = SnakeGame()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
            DispatchQueue.main.async {
                self.game.update()
            }
        }
    }

    func changeDirection(to new: Direction) {
        game.direction = game.direction.turned(to: new)
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }
}
