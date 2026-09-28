```swift
import SwiftUI
import WebKit

struct ContentView: View {
    @State private var webView: WKWebView?

    var body: some View {
        ZStack {
            WebView(
                url: URL(string: "https://xfelix-sign.de")!,
                webViewReference: $webView
            )
            .ignoresSafeArea(edges: [.bottom])

            VStack {
                HStack {
                    Button {
                        webView?.goBack()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(.black.opacity(0.75))
                            .clipShape(Circle())
                    }
                    .disabled(!(webView?.canGoBack ?? false))
                    .opacity(webView?.canGoBack == true ? 1.0 : 0.35)

                    Spacer()
                }
                .padding(.leading, 16)
                .padding(.top, 8)

                Spacer()
            }
        }
        .background(Color.black)
        .preferredColorScheme(.dark)
    }
}

struct WebView: UIViewRepresentable {
    let url: URL
    @Binding var webViewReference: WKWebView?

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true

        let webView = WKWebView(frame: .zero, configuration: configuration)

        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true

        webView.scrollView.alwaysBounceVertical = true
        webView.scrollView.backgroundColor = .black
        webView.isOpaque = false
        webView.backgroundColor = .black

        if #available(iOS 16.4, *) {
            webView.isInspectable = false
        }

        DispatchQueue.main.async {
            webViewReference = webView
        }

        var request = URLRequest(url: url)
        request.cachePolicy = .useProtocolCachePolicy
        webView.load(request)

        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        DispatchQueue.main.async {
            if webViewReference !== webView {
                webViewReference = webView
            }
        }
    }

    final class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {

        private func shouldOpenExternally(_ url: URL) -> Bool {
            guard let scheme = url.scheme?.lowercased() else {
                return false
            }

            return [
                "itms-services",
                "itms-apps",
                "itms",
                "mailto",
                "tel"
            ].contains(scheme)
        }

        private func openExternally(_ url: URL) {
            DispatchQueue.main.async {
                UIApplication.shared.open(url)
            }
        }

        func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationAction: WKNavigationAction,
            decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
        ) {
            guard let url = navigationAction.request.url else {
                decisionHandler(.cancel)
                return
            }

            if shouldOpenExternally(url) {
                openExternally(url)
                decisionHandler(.cancel)
                return
            }

            if let host = url.host?.lowercased(),
               host == "xfelix-sign.de" ||
               host == "www.xfelix-sign.de" {
                decisionHandler(.allow)
            } else if url.scheme?.lowercased() == "https" {
                openExternally(url)
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        }

        func webView(
            _ webView: WKWebView,
            createWebViewWith configuration: WKWebViewConfiguration,
            for navigationAction: WKNavigationAction,
            windowFeatures: WKWindowFeatures
        ) -> WKWebView? {
            guard let url = navigationAction.request.url else {
                return nil
            }

            if shouldOpenExternally(url) || url.scheme?.lowercased() == "https" {
                openExternally(url)
            }

            return nil
        }

        func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationResponse: WKNavigationResponse,
            decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void
        ) {
            decisionHandler(.allow)
        }
    }
}
```
