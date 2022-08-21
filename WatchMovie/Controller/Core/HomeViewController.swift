//
//  HomeViewController.swift
//  WatchMovie
//
//  Created by uttam on 11/08/22.
//

import UIKit

class HomeViewController: UIViewController {
   
    
    
    
    let sectionTitles:[String] = ["Trending Movies", "Trending Tv", "Popular", "Upcoming Movies", "Top rated"]
    private let tableView:UITableView={
        let table=UITableView(frame: .zero, style: .grouped)
        table.register(CollectionTableViewCell.self, forCellReuseIdentifier: CollectionTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title="WatchMovie"
        view.addSubview(tableView)
        tableView.delegate=self
        tableView.dataSource=self
        configureNavBar()
        setHomeHeaderImage()
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame=view.bounds
    }
    
    private func setHomeHeaderImage(){
        let homeHeaderUiView=HomeHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeHeaderUiView.delegate=self
        APICaller.shared.getHomeMovieList(with: SectionsName.trending_movie) {[weak self] result in
            switch result{
            case .success(let data):
                guard let randomEle=data.randomElement() else {return}
                guard let posterPath=randomEle.poster_path else {return}
                DispatchQueue.main.async {
                    homeHeaderUiView.config(with: randomEle)
                    self?.tableView.tableHeaderView=homeHeaderUiView

                }

//                cell.configure(with: data)
            case .failure(let error):
                print(error)
            }
        }

        
    }
    
    private func configureNavBar(){
        var image=UIImage(systemName: "play.circle.fill")
        image = image?.withRenderingMode(.alwaysOriginal)
        
        navigationItem.leftBarButtonItem=UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .black
    }
    
    

}


extension HomeViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell=tableView.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier, for: indexPath) as? CollectionTableViewCell else{
            return UITableViewCell()
        }
        cell.delegate = self
        switch indexPath.section{
        case SectionsNameRawValue.trending_movie.rawValue:
            APICaller.shared.getHomeMovieList(with: SectionsName.trending_movie) { result in
                switch result{
                case .success(let data):
                    cell.configure(with: data)
                case .failure(let error):
                    print(error)
                }
            }
        case SectionsNameRawValue.trending_tv.rawValue:
            APICaller.shared.getHomeMovieList(with: SectionsName.trending_tv) { result in
                switch result{
                case .success(let data):
                    cell.configure(with: data)
                case .failure(let error):
                    print(error)
                }
            }

        case SectionsNameRawValue.upcoming_movie.rawValue:
            APICaller.shared.getHomeMovieList(with: SectionsName.upcoming_movie) { result in
                switch result{
                case .success(let data):
                    cell.configure(with: data)
                case .failure(let error):
                    print(error)
                }
            }

        case SectionsNameRawValue.top_rated_movie.rawValue:
            APICaller.shared.getHomeMovieList(with: SectionsName.top_rated_movie) { result in
                switch result{
                case .success(let data):
                    cell.configure(with: data)
                case .failure(let error):
                    print(error)
                }
            }

        case SectionsNameRawValue.popular_movie.rawValue:
            APICaller.shared.getHomeMovieList(with: SectionsName.popular_movie) { result in
                switch result{
                case .success(let data):
                    cell.configure(with: data)
                case .failure(let error):
                    print(error)
                }
            }


            
        default:
            UITableViewCell()
        }
               
//        cell.textLabel?.text="hello"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x+20,
                                         y: header.bounds.origin.y,
                                         width: 100,
                                         height: header.bounds.height)
        header.textLabel?.textColor = .black
//        header.text
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defualtOffset=view.safeAreaInsets.top
        let offset=scrollView.contentOffset.y+defualtOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
    
}

extension HomeViewController:CollectionTableViewCellDelegate,HomeHeaderUIViewDelegate{
    func CollectionTableViewCellDidTapCell(_ cell: CollectionTableViewCell, _ viewModel: TitlePreviewModel) {
        DispatchQueue.main.async { [weak self] in
            print(viewModel.youtubeView)
            let vc=TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func HomeHeaderUIViewDidTapCell(_ viewModel: TitlePreviewModel) {
        DispatchQueue.main.async { [weak self] in
            print(viewModel.youtubeView)
            let vc=TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}



