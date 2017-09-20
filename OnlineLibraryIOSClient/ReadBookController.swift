import UIKit

class ReadBookController: UIViewController {
    @IBOutlet weak var bookReadWebView: UIWebView!
    private var url: URL?
    
    public func setUrl(url: URL) {
        self.url = url
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            setUrlAndViewData()
        }

    public func setUrlAndViewData() {
        if let urlNotNil = self.url {
            var urlRequest = URLRequest(url: urlNotNil)
            urlRequest.httpMethod = "GET"
            self.bookReadWebView.loadRequest(urlRequest)
        }
    }
}
