import SwiftUI
import WebKit

struct GifView: UIViewRepresentable {
    let name: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.clipsToBounds = false
        webView.clipsToBounds = false
        webView.backgroundColor = .clear
        webView.isOpaque = false

        if let path = Bundle.main.path(forResource: name, ofType: "gif"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            let base64String = data.base64EncodedString()
            let htmlString = """
            <html>
                <head>
                    <style>
                        html, body {
                            margin: 0;
                            padding: 0;
                            background: transparent;
                            height: 100%;
                            display: flex;
                            justify-content: center;
                            align-items: center;
                        }
                        img {
                            margin: 0 auto;
                            width: 100%;
                            height: auto;
                            display: block;
                            object-fit: contain;
                        }
                    </style>
                </head>
                <body>
                    <img src="data:image/gif;base64,\(base64String)" />
                </body>
            </html>
            """
            webView.loadHTMLString(htmlString, baseURL: nil)
        }

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

