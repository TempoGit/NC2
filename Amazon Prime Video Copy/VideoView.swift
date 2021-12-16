//
//  VideoView.swift
//  Amazon Prime Video Copy
//
//  Created by Salvatore Manna on 13/12/21.
//

import Foundation
import WebKit
import SwiftUI





struct VideoView: UIViewRepresentable {
    
    var videoID: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)") else {return}
        uiView.scrollView.isScrollEnabled = false
        uiView.load(URLRequest(url: youtubeURL))
    }
    
}

