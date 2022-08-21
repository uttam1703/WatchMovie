//
//  CollectionTableViewCell.swift
//  WatchMovie
//
//  Created by uttam on 12/08/22.
//

import UIKit

protocol CollectionTableViewCellDelegate:AnyObject{
    func CollectionTableViewCellDidTapCell(_ cell:CollectionTableViewCell,_ viewModel:TitlePreviewModel)
}

class CollectionTableViewCell: UITableViewCell {
    
    static let identifier="CollectionTableViewCell"
    weak var delegate: CollectionTableViewCellDelegate?
    
    var titleList:[Title]=[Title]()
    
    private let collectionView:UICollectionView={
        
        let layout=UICollectionViewFlowLayout()
        layout.itemSize=CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectiion=UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectiion.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectiion
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .orange
        contentView.addSubview(collectionView)
        collectionView.delegate=self
        collectionView.dataSource=self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame=contentView.bounds
    }
    
    public func configure(with title:[Title]){
        self.titleList=title
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
    }
    
    private func downloadAt(indexPath:IndexPath){
//        print("download done \(self.titleList[indexPath.row].id)")
        CoreDataManger.shared.downloadTitle(with: titleList[indexPath.row]) {[weak self] result in
            switch result{
            case .success():
                print("download done \(self?.titleList[indexPath.row].id)")
                NotificationCenter.default.post(name: Notification.Name("download"), object: nil)
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
}

extension CollectionTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else{
            return UICollectionViewCell()
        }
        guard let model=titleList[indexPath.row].poster_path else {
            return UICollectionViewCell()
        }
        cell.configure(model: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title=titleList[indexPath.row]
        
        guard let titleName=title.name ?? title.title else {return}
        guard let overview=title.overview else {return}
        APICaller.shared.sesrchYoutube(with: titleName+" trailer") {[weak self] result in
            
            switch result {
            case .success(let data):
                guard let stronSelf=self else {return}
                let viewModel=TitlePreviewModel(title: titleName, youtubeView: data, titleOverview: overview)
                self?.delegate?.CollectionTableViewCellDidTapCell(stronSelf, viewModel)
                
            case .failure(let error):
                guard let stronSelf=self else {return}
                let viewModel=TitlePreviewModel(title: titleName, youtubeView: VideoElement(id: IdVideoElement(kind: "", videoId: "wZ7LytagKlc")), titleOverview: overview)
                self?.delegate?.CollectionTableViewCellDidTapCell(stronSelf, viewModel)
                print(error.localizedDescription)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let context=UIContextMenuConfiguration(identifier: nil, previewProvider: nil) {[weak self] _ in
            
            let download=UIAction(title: "download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) {[weak self] _ in
                self?.downloadAt(indexPath: indexPath)
            }
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [download])
        }
        return context
        
    }
    
    
}
