//
//  SearchResultViewController.swift
//  WatchMovie
//
//  Created by uttam on 15/08/22.
//

import UIKit

protocol SearchResultViewControllerDelegate:AnyObject{
    func SearchResultViewControllerDidTapCell(_ viewModel:TitlePreviewModel)
}

class SearchResultViewController: UIViewController {
    
    public var serchResultTitle:[Title]=[Title]()
    weak var delegate: SearchResultViewControllerDelegate?
    
    public let searchResultCollectionView:UICollectionView={
        
        let layout=UICollectionViewFlowLayout()
        layout.itemSize=CGSize(width: UIScreen.main.bounds.width/3-10, height: 200)
        layout.minimumLineSpacing = 0
        let collection=UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        view.addSubview(searchResultCollectionView)
        searchResultCollectionView.delegate=self
        searchResultCollectionView.dataSource=self

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultCollectionView.frame=view.bounds
    }
    


}

extension SearchResultViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return serchResultTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell=collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else{
            return UICollectionViewCell()
        }
        let posterURL=serchResultTitle[indexPath.row].poster_path ?? ""
        cell.configure(model: posterURL)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title=serchResultTitle[indexPath.row]
        
        guard let titleName=title.name ?? title.title else {return}
        guard let overview=title.overview else {return}
        APICaller.shared.sesrchYoutube(with: titleName+" trailer") {[weak self] result in
            
            switch result {
            case .success(let data):
                guard let stronSelf=self else {return}
                let viewModel=TitlePreviewModel(title: titleName, youtubeView: data, titleOverview: overview)
                self?.delegate?.SearchResultViewControllerDidTapCell(viewModel)
                
            case .failure(let error):
                guard let stronSelf=self else {return}
                let viewModel=TitlePreviewModel(title: titleName, youtubeView: VideoElement(id: IdVideoElement(kind: "", videoId: "wZ7LytagKlc")), titleOverview: overview)
                self?.delegate?.SearchResultViewControllerDidTapCell(viewModel)
                print(error.localizedDescription)
            }
        }

    }
    
    
}
