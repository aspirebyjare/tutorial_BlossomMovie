////
////  YoutubePlayer.swift
////  BlossomMovie
////
////  Created by Jared Smith on 3/22/26.
////
//
//import SwiftUI
//import WebKit
//
//struct YoutubePlayer: UIViewRepresentable {
//    let webView = WKWebView()
//    let videoId: String
//    let youtubeBaseURL = APIConfig.shared?.youtubeBaseURL
//    
//    func makeUIView(context: Context) -> some UIView {
//        webView
//    }
//    
//    func updateUIView(_ uiView: UIViewType, context: Context) {
//        guard let baseURLString = youtubeBaseURL,
//              let baseURL = URL(string: baseURLString) else {return}
//        let fullURL = baseURL.appending(path: videoId)
//        webView.load(URLRequest(url: fullURL))
//    }
//}
import SwiftUI
import WebKit

struct YoutubePlayer: UIViewRepresentable {
    let videoId: String

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.scrollView.isScrollEnabled = false
        webView.isOpaque = false
        webView.backgroundColor = .clear
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard context.coordinator.lastVideoId != videoId else { return }
        context.coordinator.lastVideoId = videoId

        let bundleId = Bundle.main.bundleIdentifier?.lowercased() ?? "com.example.app"
        let referrerString = "https://\(bundleId)"
        let urlString = "https://www.youtube.com/embed/\(videoId)?playsinline=1"

        guard
            let url = URL(string: urlString),
            let referrerURL = URL(string: referrerString)
        else {
            return
        }

        var request = URLRequest(url: url)
        request.setValue(referrerURL.absoluteString, forHTTPHeaderField: "Referer")

        uiView.load(request)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    final class Coordinator {
        var lastVideoId: String?
    }
}
