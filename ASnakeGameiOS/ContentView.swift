import SwiftUI

public struct ContentView4: View {
    @StateObject private var viewModel = SnakeGameViewModel()
    private let cellSize: CGFloat = 10

    public init() {}

    public var body: some View {
        GeometryReader { geometry in
            let gridSize = min(geometry.size.width, geometry.size.height)
            ZStack {
                Color.black
                VStack(spacing: 1) {
                    ForEach(0..<viewModel.game.size, id: \.self) { y in
                        HStack(spacing: 1) {
                            ForEach(0..<viewModel.game.size, id: \.self) { x in
                                let point = CGPoint(x: CGFloat(x), y: CGFloat(y))
                                Rectangle()
                                    .fill(cellColor(at: point))
                                    .frame(width: cellSize, height: cellSize)
                            }
                        }
                    }
                }
                if viewModel.game.isGameOver {
                    Text("Game Over")
                        .foregroundColor(.white)
                        .font(.headline)
                        .background(Color.black.opacity(0.7))
                }
            }
            .gesture(swipeGesture)
            .onAppear {
                viewModel.start()
            }
            .onDisappear {
                viewModel.stop()
            }
        }
    }

    private func cellColor(at point: CGPoint) -> Color {
        if viewModel.game.snake.contains(point) {
            return .green
        } else if viewModel.game.apple == point {
            return .red
        } else {
            return .gray
        }
    }

    private var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 10)
            .onEnded { value in
                let horizontal = value.translation.width
                let vertical = value.translation.height

                if abs(horizontal) > abs(vertical) {
                    viewModel.changeDirection(to: horizontal > 0 ? .right : .left)
                } else {
                    viewModel.changeDirection(to: vertical > 0 ? .down : .up)
                }
            }
    }
}

