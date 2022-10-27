//
//  TrailerViewController.swift
//  Test_Knowledge
//
//  Created by Nelson Geovanny Pena Agudelo on 26/10/22.
//

import UIKit
import WebKit

extension TrailerViewController {
    static func build() -> TrailerViewController {
        let vc = TrailerViewController(nibName: "TrailerViewController", bundle: nil)
        return vc
    }
}


class TrailerViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    public var keyVideo: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.layer.cornerRadius = 10
        webView.configuration.allowsAirPlayForMediaPlayback = true
        let youtubeURL = URL(string: "https://www.youtube.com/embed/" + keyVideo!)
        webView.load(URLRequest(url: youtubeURL!))
    }

    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true)
    }
}
