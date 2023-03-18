import UIKit
import Foundation

func printSomething() {
    for name in ["서연", "🌙", "🐰", "🐶"] {
        print(name)
    }
}

func printBall() {
    for _ in 0...5 {
        print("🥏⚽️🏀")
    }
}

let something = BlockOperation {
    printSomething()
}

let ball = BlockOperation {
    printBall()
}

OperationQueue().addOperation(something)
