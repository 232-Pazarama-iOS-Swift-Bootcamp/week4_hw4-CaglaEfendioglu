//
//  HomeVC.swift
//  odev4
//
//  Created by Cagla Efendioglu on 12.10.2022.
//

import UIKit
import SnapKit
import FirebaseFirestore

class HomeVC: UIViewController {
    
    //MARK: Views
    
    private var parentTableView: UITableView = {
        let table = UITableView()
        //table.rowHeight = 200
        table.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.Identifier.path.rawValue)
        return table
    }()
    
    //MARK: Properties
    private let dataBase = Firestore.firestore()
    var recentPhotoData: [Photo] = []
    private var firestorePhoto: [String] = []
    private var viewModel: HomeViewModelProtocol
    
    init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initDelegate()
        viewModel.fetchRecentPhoto()
    }
    
    //MARK: Private Func

    
    private func initDelegate() {
        viewModel.setUpOutPutDelegate(self)
        parentTableView.delegate = self
        parentTableView.dataSource = self
        
        configure()
    }
    
    private func configure() {
        view.backgroundColor = .white
        navigationItem.title = "Home"
        view.addSubview(parentTableView)
        
        makeTableView()
    }
    
    private func addUserDefaultPhoto(with recentItemJpg: String) {
        let resentUserDefault = UserDefaults.standard
        var recentJpgArray = resentUserDefault.object(forKey: "recent") as? [String] ?? [String]()
        
        if recentJpgArray.contains(recentItemJpg) {
        }else{
            recentJpgArray.append(recentItemJpg)

            resentUserDefault.set(recentJpgArray, forKey: "recent")
        }
    }
    
    private func fetchFirestorePhoto(with jpgItem: String) {
        let docRef = dataBase.document("libraries/photos")
        docRef.getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }
            
            guard let photoArray = data["text"] as? [String] else {
                return
            }
            self.firestorePhoto = photoArray
            self.addFirestorePhoto(with: jpgItem)
        }
    }
    
    private func addFirestorePhoto(with jpgItem: String) {
        let docRef = dataBase.document("libraries/photos")
        firestorePhoto.append(jpgItem)
        docRef.setData(["text": firestorePhoto])
    }
}

//MARK: HomeViewModelOutput

extension HomeVC: HomeViewModelOutput {
    func showData(photoData: [Photo]) {
        recentPhotoData = photoData
        DispatchQueue.main.async { [weak self] in
            self?.parentTableView.reloadData()
        }
    }
    
    func showError(error: String) {
        print(error)
    }
}

//MARK: UITableViewDelegate, UITableViewDataSource

extension HomeVC: UITableViewDelegate, UITableViewDataSource, cellFavoriteDelegate {
    func clickLibraryButton(with item: IndexPath) {
        let recentPhotoID = recentPhotoData[item.row]
        let serverID = recentPhotoID.server ?? ""
        let id = recentPhotoID.id ?? ""
        let secretID = recentPhotoID.secret ?? ""
        
        let recentPhotoJpg = "https://live.staticflickr.com/\(serverID)/\(id)_\(secretID).jpg"
        fetchFirestorePhoto(with: recentPhotoJpg)
        print("added to Library")
    }
    
    func clickFavoriteButton(with item: IndexPath) {
        let recentPhotoID = recentPhotoData[item.row]
        let serverID = recentPhotoID.server ?? ""
        let id = recentPhotoID.id ?? ""
        let secretID = recentPhotoID.secret ?? ""

         let recentPhotoJpg = "https://live.staticflickr.com/\(serverID)/\(id)_\(secretID).jpg"
      
        addUserDefaultPhoto(with: recentPhotoJpg)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.Identifier.path.rawValue) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        
        cell.cellIndexPath = indexPath
        cell.delegate = self
        
        cell.saveModel(value: viewModel.recentPhotoData()[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height / 2.5
    }
}

//MARK: Constraints


extension HomeVC {
    private func makeTableView() {
        parentTableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalTo(view)
        }
    }
}
