//
//  HomeHeaderUIView.swift
//  WatchMovie
//
//  Created by uttam on 13/08/22.
//

import UIKit
protocol HomeHeaderUIViewDelegate:AnyObject{
    func HomeHeaderUIViewDidTapCell(_ viewModel:TitlePreviewModel)
}

class HomeHeaderUIView: UIView {
    
    private var titleElement:Title?
    weak var delegate: HomeHeaderUIViewDelegate?
    
    private let playButton:UIButton={
        let button=UIButton()
        button.setTitle("Play", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let downloadButton:UIButton={
        let button=UIButton()
        button.setTitle("Download", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)

        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()

    


    private let imageView:UIImageView={
        let imageView=UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds=true
        imageView.image=UIImage(named: "dune")
        return imageView
    }()
    
    private func addGradient(){
        let gradient=CAGradientLayer()
        gradient.frame=bounds
        gradient.colors=[
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        layer.addSublayer(gradient)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
        applyConstrain()
        playButton.addTarget(self, action: #selector(playButtonTap), for: .touchUpInside)
        downloadButton.addTarget(self, action: #selector(downloadButtonTap), for: .touchUpInside)
        
    }
    
    @objc private func playButtonTap(){
        guard let title=titleElement else {return}
        guard let titleName=title.name ?? title.title else {return}
        guard let overview=title.overview else {return}
        APICaller.shared.sesrchYoutube(with: titleName+" trailer") {[weak self] result in
            
            switch result {
            case .success(let data):
                guard let stronSelf=self else {return}
                let viewModel=TitlePreviewModel(title: titleName, youtubeView: data, titleOverview: overview)
                self?.delegate?.HomeHeaderUIViewDidTapCell(viewModel)
            case .failure(let error):
                guard let stronSelf=self else {return}
                let viewModel=TitlePreviewModel(title: titleName, youtubeView: VideoElement(id: IdVideoElement(kind: "", videoId: "wZ7LytagKlc")), titleOverview: overview)
                self?.delegate?.HomeHeaderUIViewDidTapCell(viewModel)
                print(error.localizedDescription)
            }
        }


    }
    @objc private func downloadButtonTap(){
        print("#downloadButtonTap")
        guard let title=titleElement else {return}
        CoreDataManger.shared.downloadTitle(with: title) {[weak self] result in
            switch result{
            case .success():
//                print("download done \(self?.titleList[indexPath.row].id)")
                NotificationCenter.default.post(name: Notification.Name("download"), object: nil)
            case .failure(let error):
                print(error)
            }
        }
        
    }

    
    private func applyConstrain(){
        let playButtonConstrain=[
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        let downloadButtonConstrain=[
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downloadButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        NSLayoutConstraint.activate(playButtonConstrain)
        NSLayoutConstraint.activate(downloadButtonConstrain)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame=bounds
    }
    
    public func config(with model:Title){
        titleElement=model
        guard let posterURL=model.poster_path else {return}
        guard let url=URL(string: "\(APIConstant.imageBaseURL)\(posterURL)") else{
            return
        }
        
        imageView.sd_setImage(with: url)
        
    }
}
