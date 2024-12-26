//
//  BackgroundImageView.swift
//  CombineWeather
//
//  Created by Dongik Song on 12/23/24.
//

import SwiftUI
import WebKit

struct BackgroundImageView: UIViewRepresentable {
    @Binding var name: String
    
    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()
        containerView.clipsToBounds = true

        guard let gifView = createGIFView() else {
            return containerView
        }

        containerView.addSubview(gifView)
        gifView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gifView.topAnchor.constraint(equalTo: containerView.topAnchor),
            gifView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            gifView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            gifView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
        
        return containerView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
//        guard let gifView = createGIFView() else { return }
//            uiView.subviews.forEach { $0.removeFromSuperview() }
//            uiView.addSubview(gifView)
//            gifView.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                gifView.topAnchor.constraint(equalTo: uiView.topAnchor),
//                gifView.bottomAnchor.constraint(equalTo: uiView.bottomAnchor),
//                gifView.leadingAnchor.constraint(equalTo: uiView.leadingAnchor),
//                gifView.trailingAnchor.constraint(equalTo: uiView.trailingAnchor),
//            ])
    }
    
    private func createGIFView() -> UIImageView? {
        guard let path = Bundle.main.path(forResource: name, ofType: "gif"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }

        let gifView = UIImageView()
        gifView.contentMode = .scaleAspectFill
        
        var images: [UIImage] = []
        var duration: Double = 0

        let frameCount = CGImageSourceGetCount(source)
        for i in 0..<frameCount {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let frameDuration = getFrameDuration(for: source, at: i)
                duration += frameDuration
                images.append(UIImage(cgImage: cgImage))
            }
        }

        gifView.animationImages = images
        gifView.animationDuration = duration
        gifView.startAnimating()
        return gifView
    }
    
    private func getFrameDuration(for source: CGImageSource, at index: Int) -> Double {
        guard let properties = CGImageSourceCopyPropertiesAtIndex(source, index, nil) as? [CFString: Any],
              let gifProperties = properties[kCGImagePropertyGIFDictionary] as? [CFString: Any],
              let frameDuration = gifProperties[kCGImagePropertyGIFUnclampedDelayTime] as? Double ??
                                   gifProperties[kCGImagePropertyGIFDelayTime] as? Double else {
            return 0.1 // 기본값
        }
        return frameDuration > 0 ? frameDuration : 0.1
    }
}
