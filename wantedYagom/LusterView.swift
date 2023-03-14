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
    
    func reset() {
        imageView.image = .init(systemName: "photo")
        progressView.progress = 0
        loadButton.isEnabled = true
    }
    
    func loadImage() {
        loadButton.sendActions(for: .touchUpInside)
    }
    
    // button 을 누르면 로드 되는 함수
    @IBAction private func touchUpLoadButton(_ sender: UIButton) {
        reset()
        
        // 버튼 태그 0 - 4 받아오기
        guard (0...4).contains(sender.tag) else {
            fatalError("버튼 태그를 확인해주세요")
        }
        debugPrint(sender.tag)
        
        let url = ImageURL[sender.tag]
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self.imageView.image = .init(systemName: "xmark")
                }
                return
            }
            
            DispatchQueue.main.async {
                self.imageView.image = image
            }
            
        }
        task.resume()
    }
}
