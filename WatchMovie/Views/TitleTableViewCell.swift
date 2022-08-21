//
//  TitleTableViewCell.swift
//  WatchMovie
//
//  Created by uttam on 14/08/22.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    static let identifier="TitleTableViewCell"
    
//    private let playTitLeButton:UIButton={
//        let button=UIButton()
//        let image=UIImage(systemName: "play.circle",withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
//        button.setImage(image, for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints=false
//        button.tintColor = .black
//        return button
//    }()
    
    private let titleImageView:UIImageView={
        let imageView=UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds=true
        imageView.translatesAutoresizingMaskIntoConstraints=false
        return imageView
    }()
    
    private let titleNameLabel:UILabel={
        let label=UILabel()
        label.numberOfLines=0
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleImageView)
        contentView.addSubview(titleNameLabel)
//        contentView.addSubview(playTitLeButton)
        
        applyConstrain()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyConstrain(){
        let titleImageConstrain=[
            titleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleImageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
            titleImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant:-10),
            titleImageView.widthAnchor.constraint(equalToConstant: 100)
            
        ]
        let titleNameConstrin=[
            titleNameLabel.leadingAnchor.constraint(equalTo: titleImageView.trailingAnchor,constant: 20),
            titleNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
//        let playButtonContrain=[
//            playTitLeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -20),
//            playTitLeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
//
//        ]
        
        NSLayoutConstraint.activate(titleImageConstrain)
        NSLayoutConstraint.activate(titleNameConstrin)
//        NSLayoutConstraint.activate(playButtonContrain)
        
    }
    
    func configure(model:TitleViewModel){
        
        guard let url=URL(string: "\(APIConstant.imageBaseURL)\(model.posterImageURL)") else {return}
        titleImageView.sd_setImage(with: url)
//        print(model.titleName)
        titleNameLabel.text=model.titleName
    }
}
