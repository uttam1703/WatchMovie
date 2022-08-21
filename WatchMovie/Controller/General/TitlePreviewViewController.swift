//
//  TitlePreviewViewController.swift
//  WatchMovie
//
//  Created by uttam on 15/08/22.
//

import UIKit
import WebKit

class TitlePreviewViewController: UIViewController {
    
    
    private let titleLabel:UILabel={
        let label=UILabel()
//        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints=false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text="Prey"
//        label.numberOfLines=0
        return label
    }()
    
    private let overvirewLabel:UILabel={
        let label=UILabel()
        label.translatesAutoresizingMaskIntoConstraints=false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines=0
        label.text="tedt data"
        return label
    }()
    
    private let webView:WKWebView={
        let view=WKWebView()
        view.translatesAutoresizingMaskIntoConstraints=false
        return view
    }()
    
    private let downloadButton:UIButton={
        let button=UIButton()
        button.translatesAutoresizingMaskIntoConstraints=false
        button.backgroundColor = .red
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds=true
        button.layer.cornerRadius=8
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
//        title="Time"
        navigationController?.navigationBar.tintColor = .systemBlue
        view.backgroundColor = .systemBackground
        view.addSubview(titleLabel)
        view.addSubview(overvirewLabel)
        view.addSubview(webView)
        view.addSubview(downloadButton)
        addConstrainN()

    }
    
    private func addConstrainN(){
        let webViewConstrain=[
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 300)        ]
        let titleLableConstrain=[
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ]
        let overviewConstrain=[
            overvirewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            overvirewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overvirewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        let downloadConstrain=[
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                        downloadButton.topAnchor.constraint(equalTo: overvirewLabel.bottomAnchor, constant: 25),
                        downloadButton.widthAnchor.constraint(equalToConstant: 140),
                        downloadButton.heightAnchor.constraint(equalToConstant: 40)        ]
        
        NSLayoutConstraint.activate(webViewConstrain)
        NSLayoutConstraint.activate(titleLableConstrain)
        NSLayoutConstraint.activate(overviewConstrain)
        NSLayoutConstraint.activate(downloadConstrain)

    }
    
    public func configure(with model:TitlePreviewModel){
        titleLabel.text=model.title
        overvirewLabel.text=model.titleOverview
        
        guard let url=URL(string: "\(APIConstant.YoutubeVideoLink)\(model.youtubeView.id.videoId)") else {return}
        
        webView.load(URLRequest(url: url))
    }

}
