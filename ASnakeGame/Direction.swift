import Foundation

enum Direction {
    case up, down, left, right

    func turned(to swipe: Direction) -> Direction {
        switch (self, swipe) {
        case (.up, .down), (.down, .up), (.left, .right), (.right, .left):
            return self
        default:
            return swipe
        }
    }
}
