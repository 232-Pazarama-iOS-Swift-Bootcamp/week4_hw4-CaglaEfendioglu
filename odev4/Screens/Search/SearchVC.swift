//
//  SearchVC.swift
//  odev4
//
//  Created by Cagla Efendioglu on 12.10.2022.
//

import UIKit

class SearchVC: UIViewController {

    //MARK: - Views
    
    private lazy var searchBar: UISearchController = {
        let search = UISearchController()
        search.searchBar.placeholder = "Search Image"
        search.searchBar.showsCancelButton = true
        return search
    }()
    
    private lazy var searchListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemGray6
        collectionView.register(
            SearchCollectionViewCell.self,
            forCellWithReuseIdentifier: SearchCollectionViewCell.Identifier.path.rawValue
        )
        return collectionView
    }()
    
    //MARK: - Properties
    private var recentPhotoData: [Photo] = []
    private var searchPhotoData: [Photo] = []
    private var isSearch = false
    private var viewModel: SearchViewModelProtocol
    
    init(viewModel: SearchViewModelProtocol) {
            self.viewModel = viewModel
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initDelegate()
        viewModel.fetchRecentPhoto()
    }
    

    //MARK: - Private Func
    
    private func initDelegate() {
        navigationItem.searchController = searchBar
        viewModel.setUpOutPutDelegate(self)
        searchBar.searchBar.delegate = self
        searchListCollectionView.delegate = self
        searchListCollectionView.dataSource = self
        
        configure()
    }
    
    private func configure() {
        navigationItem.title = "Search"
        view.backgroundColor = .white
        view.addSubview(searchListCollectionView)
        
        makeSearchCollection()
    }

}

extension SearchVC: SearchViewModelOutput {
    func showData(photoData: [Photo]) {
        recentPhotoData = photoData
        DispatchQueue.main.async { [weak self] in
            self?.searchListCollectionView.reloadData()
        }
    }
    
    func showError(error: String) {
        print(error)
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearch {
            return viewModel.searchNumberOfRows()
        }
        return viewModel.recentNumberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.Identifier.path.rawValue, for: indexPath) as? SearchCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if isSearch {
            cell.saveModel(item: viewModel.searchPhotoData()[indexPath.row])
        } else {
            cell.saveModel(item: viewModel.recentPhotoData()[indexPath.row])
        }
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let colums: CGFloat = 2
        let with = collectionView.bounds.width
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 30
        let width = (with - 70) / colums
        let height = width
        return CGSize(width: width, height: height)
    }
}

//MARK: - UISearchBarDelegate

extension SearchVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        viewModel.fetchSearchPhoto(text: text)
        isSearch = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.fetchRecentPhoto()
        isSearch = false
    }
}

//MARK: - Constraints

extension SearchVC {
    private func makeSearchCollection() {
        searchListCollectionView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalTo(view)
        }
    }
}
