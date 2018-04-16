import UIKit

class WebViewController: UIViewController {
    var news: News?

    var webView = UIWebView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(webView)

        webView.frame = view.frame

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(dismissViewController))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Forward", style: .plain, target: webView, action: #selector(webView.goForward)),
            UIBarButtonItem(title: "Back", style: .plain, target: webView, action: #selector(webView.goBack)),
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
