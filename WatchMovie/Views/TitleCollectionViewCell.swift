//
//  TitleCollectionViewCell.swift
//  WatchMovie
//
//  Created by uttam on 14/08/22.
//

import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    static let identifier="TitleCollectionViewCell"
    
    private let imageView:UIImageView={
        let imageView=UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame=bounds
    }
    
    public func configure(model:String){
        guard let url=URL(string: "\(APIConstant.imageBaseURL)\(model)") else{
            return
        }
        
        imageView.sd_setImage(with: url)
    }
}
