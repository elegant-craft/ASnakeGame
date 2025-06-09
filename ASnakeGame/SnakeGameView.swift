import SwiftUI

public struct SnakeGameView: View {
    @StateObject private var viewModel = SnakeGameViewModel()
    
    private let columnCount = 15
    private let showGrid: Bool = true

    public init() {}

    public var body: some View {
        let screenWidth = WKInterfaceDevice.current().screenBounds.width
            let cellSize = screenWidth / CGFloat(columnCount)
        let maxRows = Int(WKInterfaceDevice.current().screenBounds.height / cellSize)
            let rowCount = min(viewModel.game.size, maxRows)

            ZStack {
                Image("background", bundle: Bundle(identifier: "com.mengdongfuture.ASnakeGame"))
                    .resizable()
                    .scaledToFill()
                    .frame(width: screenWidth, height: WKInterfaceDevice.current().screenBounds.height)
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        ForEach(0..<rowCount, id: \.self) { y in
                            HStack(spacing: 0) {
                                ForEach(0..<columnCount, id: \.self) { x in
                                    let point = CGPoint(x: CGFloat(x), y: CGFloat(y))
                                    ZStack {
                                        if showGrid {
                                            Rectangle()
                                                .stroke(Color.clear, lineWidth: 0.5)
                                        }
                                        cellView(at: point)
                                    }
                                    .frame(width: cellSize, height: cellSize)
                                }
                            }
                        }
                    }
                }
                .frame(width: screenWidth, height: cellSize * CGFloat(rowCount))
                .clipped()
                VStack {
                    Text("Score: \(viewModel.game.score)")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding(.top, 10)
                        .shadow(radius: 2)
                    Spacer()
                }
                if viewModel.game.isGameOver {
                    VStack {
                        Text("Game Over")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(.top, 20)

                        Text("Tap to Restart")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.6))
                }
            }
            .frame(width: screenWidth, height: WKInterfaceDevice.current().screenBounds.height)
            .clipped()
            .ignoresSafeArea()
            .gesture(tapGesture)
            .gesture(swipeGesture)
            .onAppear { viewModel.start() }
            .onDisappear { viewModel.stop() }
    }

    private func cellView(at point: CGPoint) -> some View {
        if point == viewModel.game.snake.first {
            return AnyView(
                Image("snake_head", bundle: Bundle(identifier: "com.mengdongfuture.ASnakeGame"))
                    .resizable()
                    .scaledToFill()
                    .rotationEffect(
                        .degrees(
                            viewModel.game.direction == .right ? -90 :
                                viewModel.game.direction == .down ? 0 :
                                viewModel.game.direction == .left ? 90 :
                                viewModel.game.direction == .up ? 180 : 0
                        )
                    )
            )
        } else if point == viewModel.game.snake.last && viewModel.game.snakeDirection[viewModel.game.snake.firstIndex(of: point)!] == viewModel.game.snakeDirection[viewModel.game.snake.firstIndex(of: point)! - 1] {
            return AnyView(
                Image("snake_tail", bundle: Bundle(identifier: "com.mengdongfuture.ASnakeGame"))
                    .resizable()
                    .scaledToFill()
                    .rotationEffect(
                        .degrees(
                            viewModel.game.snakeDirection[viewModel.game.snake.firstIndex(of: point)!] == .right ? -90 :
                                viewModel.game.snakeDirection[viewModel.game.snake.firstIndex(of: point)!] == .down ? 0 :
                                viewModel.game.snakeDirection[viewModel.game.snake.firstIndex(of: point)!] == .left ? 90 :
                                viewModel.game.snakeDirection[viewModel.game.snake.firstIndex(of: point)!] == .up ? 180 : 0
                        )
                    )
            )
        } else if viewModel.game.snake.contains(point) && viewModel.game.snakeDirection[viewModel.game.snake.firstIndex(of: point)!] == viewModel.game.snakeDirection[viewModel.game.snake.firstIndex(of: point)! - 1] {
            return AnyView(
                Image("snake_body", bundle: Bundle(identifier: "com.mengdongfuture.ASnakeGame"))
                    .resizable()
                    .scaledToFill()
                    .rotationEffect(
                        .degrees(
                            viewModel.game.snakeDirection[viewModel.game.snake.firstIndex(of: point)!] == .right ? -90 :
                                viewModel.game.snakeDirection[viewModel.game.snake.firstIndex(of: point)!] == .down ? 0 :
                                viewModel.game.snakeDirection[viewModel.game.snake.firstIndex(of: point)!] == .left ? 90 :
                                viewModel.game.snakeDirection[viewModel.game.snake.firstIndex(of: point)!] == .up ? 180 : 0
                        )
                    )
            )
        } else if viewModel.game.snake.contains(point) {
            if viewModel.game.snakeDirection[viewModel.game.snake.firstIndex(of: point)! - 1] == .left && viewModel.game.snakeDirection[viewModel.game.snake.firstIndex(of: point)!] == .down {
                return AnyView(
                    Image("snake_body_coner_1", bundle: Bundle(identifier: "com.mengdongfuture.ASnakeGame"))
                        .resizable()
                        .scaledToFill()
                )
            } else if viewModel.game.snakeDirection[viewModel.game.snake.firstIndex(of: point)! - 1] == .up && viewModel.game.snakeDirection[viewModel.game.snake.firstIndex(of: point)!] == .left {
                return AnyView(
                    Image("snake_body_coner_1", bundle: Bundle(identifier: "com.mengdongfuture.ASnakeGame"))
                        .resizable()
                        .scaledToFill()
                        .rotationEffect(
                            .degrees(90)
                        )
                )
            } else if viewModel.game.snakeDirection[viewModel.game.snake.firstIndex(of: point)! - 1] == .right && viewModel.game.snakeDirection[viewModel.game.snake.firstIndex(of: point)!] == .up {
                return AnyView(
                    Image("snake_body_coner_1", bundle: Bundle(identifier: "com.mengdongfuture.ASnakeGame"))
                        .resizable()
                        .scaledToFill()
                        .rotationEffect(
                            .degrees(180)
                        )
                )
            } else if viewModel.game.snakeDirection[viewModel.game.snake.firstIndex(of: point)! - 1] == .down && viewModel.game.snakeDirection[viewModel.game.snake.firstIndex(of: point)!] == .right {
                return AnyView(
                    Image("snake_body_coner_1", bundle: Bundle(identifier: "com.mengdongfuture.ASnakeGame"))
                        .resizable()
                        .scaledToFill()
                        .rotationEffect(
                            .degrees(-90)
                        )
                )
            } else if viewModel.game.snakeDirection[viewModel.game.snake.firstIndex(of: point)! - 1] == .down && viewModel.game.snakeDirection[viewModel.game.snake.firstIndex(of: point)!] == .left {
                return AnyView(
                    Image("snake_body_coner_2", bundle: Bundle(identifier: "com.mengdongfuture.ASnakeGame"))
                        .resizable()
                        .scaledToFill()
                )
            } else if viewModel.game.snakeDirection[viewModel.game.snake.firstIndex(of: point)! - 1] == .left && viewModel.game.snakeDirection[viewModel.game.snake.firstIndex(of: point)!] == .up {
                return AnyView(
                    Image("snake_body_coner_2", bundle: Bundle(identifier: "com.mengdongfuture.ASnakeGame"))
                        .resizable()
                        .scaledToFill()
                        .rotationEffect(
                            .degrees(90)
                        )
                )
            } else if viewModel.game.snakeDirection[viewModel.game.snake.firstIndex(of: point)! - 1] == .up && viewModel.game.snakeDirection[viewModel.game.snake.firstIndex(of: point)!] == .right {
                return AnyView(
                    Image("snake_body_coner_2", bundle: Bundle(identifier: "com.mengdongfuture.ASnakeGame"))
                        .resizable()
                        .scaledToFill()
                        .rotationEffect(
                            .degrees(180)
                        )
                )
            } else {
                return AnyView(
                    Image("snake_body_coner_2", bundle: Bundle(identifier: "com.mengdongfuture.ASnakeGame"))
                        .resizable()
                        .scaledToFill()
                        .rotationEffect(
                            .degrees(-90)
                        )
                )
            }
        } else if point == viewModel.game.apple {
            return AnyView(
                Image("apple", bundle: Bundle(identifier: "com.mengdongfuture.ASnakeGame"))
                    .resizable()
                    .scaledToFill()
            )
        } else {
            return AnyView(Color.clear)
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

    private var tapGesture: some Gesture {
        TapGesture()
            .onEnded {
                if viewModel.game.isGameOver {
                    viewModel.restart()
                }
            }
    }
}
