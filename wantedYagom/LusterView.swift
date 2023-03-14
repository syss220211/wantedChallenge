//
//  LusterView.swift
//  wantedYagom
//
//  Created by 박서연 on 2023/03/06.
//

import UIKit

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
    @IBAction private func touchUpLoadButton(_sender: UIButton) {
        
    }
}
