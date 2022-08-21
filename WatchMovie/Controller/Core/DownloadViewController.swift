//
//  DownloadViewController.swift
//  WatchMovie
//
//  Created by uttam on 11/08/22.
//

import UIKit

class DownloadViewController: UIViewController {
    private var titles:[TitleItem]=[TitleItem]()
    
    private let downloadTableView:UITableView={
        let table=UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        title="Download"
        navigationController?.navigationBar.prefersLargeTitles=true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(downloadTableView)
        downloadTableView.delegate=self
        downloadTableView.dataSource=self
        fetchData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadTableView.frame=view.bounds
        
    }
    
    private func fetchData(){
        CoreDataManger.shared.readDownloadData {[weak self] result in
            switch result{
            case .success(let data):
                self?.titles=data
                DispatchQueue.main.async {
                    
                    self?.downloadTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    


}

extension DownloadViewController:UITableViewDelegate,UITableViewDataSource{
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle{
        case .delete:
            CoreDataManger.shared.deleteDownloadData(model: titles[indexPath.row]) {[weak self] result in
                switch result{
                case .success():
                    print("deleted")
                case.failure(let error):
                    print(error)
                    
                }
                self?.titles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            }
         default:
            break
        }
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


