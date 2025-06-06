import SwiftUI

public struct ContentView4: View {
    @StateObject private var viewModel = SnakeGameViewModel()
    
    private let columnCount = 15 // 横向格子数固定
    private let showGrid: Bool = true // ✅ 控制是否显示格子线

    public init() {}

    public var body: some View {
//        GeometryReader { geo in
//            let screenWidth = geo.size.width
        let screenWidth = WKInterfaceDevice.current().screenBounds.width
            let cellSize = screenWidth / CGFloat(columnCount)
//            let maxRows = Int(geo.size.height / cellSize)
        let maxRows = Int(WKInterfaceDevice.current().screenBounds.height / cellSize)
            let rowCount = min(viewModel.game.size, maxRows)

            ZStack {
                Image("background", bundle: Bundle(identifier: "com.mengdongfuture.ASnakeGame"))
                    .resizable()
                    .scaledToFill()
                    .frame(width: screenWidth, height: WKInterfaceDevice.current().screenBounds.height)
//                Rectangle()
//                    .fill(.yellow)
//                    .frame(width: screenWidth, height: WKInterfaceDevice.current().screenBounds.height)
                VStack(spacing: 0) {
                    // 游戏区域
                    VStack(spacing: 0) {
                        ForEach(0..<rowCount, id: \.self) { y in
                            HStack(spacing: 0) {
                                ForEach(0..<columnCount, id: \.self) { x in
                                    let point = CGPoint(x: CGFloat(x), y: CGFloat(y))
                                    ZStack {
                                        if showGrid {
                                            Rectangle()
                                                .stroke(Color.black.opacity(0.8), lineWidth: 0.5)
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

                // Score Overlay
                VStack {
                    Text("Score: \(viewModel.game.score)")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding(.top, 10)
                        .shadow(radius: 2)
                    Spacer()
                }

                // Game Over Overlay
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
//        }
    }

    private func cellView(at point: CGPoint) -> some View {
        if point == viewModel.game.snake.first {
            return AnyView(
//                Image("snake_head")
//                    .resizable()
//                    .scaledToFit()
                Rectangle()
                    .fill(.blue)
//                    .ignoresSafeArea()
            )
        } else if viewModel.game.snake.contains(point) {
            return AnyView(
//                Image("snake_body")
//                    .resizable()
//                    .scaledToFit()
                Rectangle()
                    .fill(.green)
//                    .ignoresSafeArea()
            )
        } else if point == viewModel.game.apple {
            return AnyView(
                Image("star", bundle: Bundle(identifier: "com.mengdongfuture.ASnakeGame"))
                    .resizable()
                    .scaledToFill()
//                Rectangle()
//                    .fill(.red)
////                    .ignoresSafeArea()
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
