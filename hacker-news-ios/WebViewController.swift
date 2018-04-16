import UIKit

class WebViewController: UIViewController {
    var news: News?

    var webView = UIWebView()

    var backBarButtonItem: UIBarButtonItem?
    var forwardBarButtonItem: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(webView)

        webView.frame = view.frame
        webView.delegate = self

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(dismissViewController))
        backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: webView, action: #selector(webView.goBack))
        forwardBarButtonItem = UIBarButtonItem(title: "Forward", style: .plain, target: webView, action: #selector(webView.goForward))
        backBarButtonItem?.isEnabled = false
        forwardBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItems = [
            forwardBarButtonItem!,
            backBarButtonItem!,
        ]
    }

    @objc func dismissViewController() {
        self.dismiss(animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        webView.loadRequest(URLRequest(url: URL(string: news!.url)!))
    }
}

extension WebViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        backBarButtonItem?.isEnabled = webView.canGoBack
        forwardBarButtonItem?.isEnabled = webView.canGoForward
    }
}
