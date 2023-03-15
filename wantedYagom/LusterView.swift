//
//  LusterView.swift
//  wantedYagom
//
//  Created by 박서연 on 2023/03/06.
//

import UIKit

// 이미지 샘플 따라하기

fileprivate enum ImageURL {
    private static let imageIds: [String] = [
        "europe-4k-1318341",
        "europe-4k-1369012",
        "europe-4k-1379801",
        "cool-lion-167408",
        "iron-man-323408"
    ]
    
    static subscript(index: Int) -> URL {
        let id = imageIds[index]
        return URL(string: "https://wallpaperaccess.com/download/"+id)!
    }
}

final class LusterView: UIView {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var progressView: UIProgressView!
    @IBOutlet private var loadButton: UIButton!
    
    // 프로그래스 바 설정
    private var observation: NSKeyValueObservation!
    // 버튼 stop 표시
    private var task: URLSessionDataTask!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadButton.setTitle("Stop", for: .selected)
        loadButton.setTitle("Load", for: .normal)
        loadButton.isSelected = false
    }
    
    deinit {
        observation.invalidate()
        observation = nil
    }
    
    func reset() {
        imageView.image = .init(systemName: "photo")
        progressView.progress = 0
//        loadButton.isEnabled = true
        loadButton.isSelected = false
    }
    
    func loadImage() {
        loadButton.sendActions(for: .touchUpInside)
    }
    
    // button 을 누르면 로드 되는 함수
    @IBAction private func touchUpLoadButton(_ sender: UIButton) {
        
        sender.isSelected.toggle()
        guard sender.isSelected else {
            task.cancel()
            return
        }
        
        // 버튼 태그 0 - 4 받아오기
        guard (0...4).contains(sender.tag) else {
            fatalError("버튼 태그를 확인해주세요")
        }
        debugPrint(sender.tag)
        
        let url = ImageURL[sender.tag]
        let request = URLRequest(url: url)
        
        task = URLSession.shared.dataTask(with: request) { data, response, error in // 이미지 다운로드 끝나면 {} 실행
            if let error = error {
                guard error.localizedDescription == "cancelled" else {
                    fatalError(error.localizedDescription)
                }
                DispatchQueue.main.async {
                    self.reset()
                }
                return
            }
            // 여기까지 다 main thread에서 작업 (화면에서 조작 = main thread에서 작업)
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    // 이미지 다운 받고, 화면에 그리는 2개의 작업을 하기 때문에 동시성 사용, road all은 화면 5개를 그려야함
                    // main을 통해서 이미지 다 다운 받았으니 화면에 그리라는 일을 전달 해야 하는 데 화면 UI 그리는일은 main thread에서만 가능하기 때문에 .main.async에서 imageView 그려주기
                    self.imageView.image = .init(systemName: "xmark") // 일을 보낸쪽으로 다시 되돌려주어야하는 부분도 있기 때문에 되돌림
                }
                return
            }
            
            DispatchQueue.main.async {
                self.imageView.image = image
                self.loadButton.isSelected = false
            }
        }
    
        observation = task.progress.observe(\.fractionCompleted, options: [.new], changeHandler:  { progress, change in
            DispatchQueue.main.async {
                self.progressView.progress = Float(progress.fractionCompleted)
                // task의 진행상황 옵저빙(progress->fractionCompleted)
            }
        })
        task.resume() // Datatask를 새로운 백그라운드 쓰레드에서 샐행시켜줌 -> 이미지 다운로드 작업 진행
    }
}
