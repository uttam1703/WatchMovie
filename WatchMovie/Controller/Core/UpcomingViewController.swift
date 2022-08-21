//
//  UpcomingViewController.swift
//  WatchMovie
//
//  Created by uttam on 11/08/22.
//

import UIKit
//import XCTest

class UpcomingViewController: UIViewController {
    
    private var titles:[Title]=[Title]()
    
    private let upComingtableView:UITableView={
        let table=UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title="Upcoming"
        navigationController?.navigationBar.prefersLargeTitles=true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(upComingtableView)
        upComingtableView.delegate=self
        upComingtableView.dataSource=self
        fetchData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upComingtableView.frame=view.bounds
        
    }
    
    private func fetchData(){
        APICaller.shared.getHomeMovieList(with: SectionsName.upcoming_movie) {[weak self] result in
            switch result{
            case .success(let data):
                self?.titles=data
                DispatchQueue.main.async {
                  
                    self?.upComingtableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    

}

extension UpcomingViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else{
            return UITableViewCell()
        }
        
        let titleName=titles[indexPath.row].title ?? titles[indexPath.row].name ?? "No name"
        let posterURL=titles[indexPath.row].poster_path ?? ""
        
        let titleViewModel=TitleViewModel(titleName: titleName, posterImageURL: posterURL)
        cell.configure(model: titleViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let title=titles[indexPath.row]
        
        guard let titleName=title.name ?? title.title else {return}
        guard let overview=title.overview else {return}
        APICaller.shared.sesrchYoutube(with: titleName+" trailer") {[weak self] result in
            
            switch result {
            case .success(let data):
                guard let stronSelf=self else {return}
                let viewModel=TitlePreviewModel(title: titleName, youtubeView: data, titleOverview: overview)
                DispatchQueue.main.async { [weak self] in
                    print(viewModel.youtubeView)
                    let vc=TitlePreviewViewController()
                    vc.configure(with: viewModel)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                
            case .failure(let error):
                guard let stronSelf=self else {return}
                let viewModel=TitlePreviewModel(title: titleName, youtubeView: VideoElement(id: IdVideoElement(kind: "", videoId: "wZ7LytagKlc")), titleOverview: overview)
                DispatchQueue.main.async { [weak self] in
                    print(viewModel.youtubeView)
                    let vc=TitlePreviewViewController()
                    vc.configure(with: viewModel)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                print(error.localizedDescription)
            }
        }
        
    }
    
    
}
