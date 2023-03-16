import UIKit
import Foundation

// 순서대로 안 나오니까 DispatchQueue 만들어보기 -> 기본 디폴트 = Serial Queue
// attributes 추가
let myQueue = DispatchQueue(label: "myQueue", qos: .background, attributes: .concurrent)

// 우선순위
let imageDownloadQueue = DispatchQueue(label: "download", qos: .utility, attributes: .concurrent)
// Qos : 작업의 우선순위 클래스 (userInteractive > userInitiated > default > utility > background)

func printSomething() {
    for name in ["서연", "🐶", "☁️", "사랑🫶🏻", "🔥"] {
        print(name)
    }
}

func downloadImage() {
    for _ in 0...5 {
        print("🌁🌄🌉🌌")
    }
}

let imageItem = DispatchWorkItem {
    downloadImage()
}

// workItem으로 만들어보기
let dispatchItem = DispatchWorkItem {
    printSomething()
}




for _ in (0...30) {
//    DispatchQueue.global().async(execute: dispatchItem) // global을 사용해서 실행하면, FIFO인 Queue임에도 불구하고 배열이 순서대로 출력되지 않음 -> default concurrent Queue
    imageDownloadQueue.async(execute: imageItem)
    myQueue.async(execute: dispatchItem) // 순서대로 출력됨 -> attributes 추가하면 비순서대로
}
sleep(3)


/* MARK: Queue의 종류는 2가지
1) Serial Queue : 작업이 들어오는 순서대로 실행
2) concurrent Queue : 작업이 들어오는 순서와 상관없이 실행
-> main Queue의 default = Serial Queue
*/
