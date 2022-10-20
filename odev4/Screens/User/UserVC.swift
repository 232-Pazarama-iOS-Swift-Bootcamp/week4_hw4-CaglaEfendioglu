//
//  UserVC.swift
//  odev4
//
//  Created by Cagla Efendioglu on 12.10.2022.
//

import UIKit
import FirebaseFirestore

class UserVC: UIViewController {
    
    //MARK: - Views
    
    private lazy var UserImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        //image.layer.cornerRadius = 10
        image.layer.cornerRadius = view.frame.size.height / 24
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.red.cgColor
        image.clipsToBounds = true
        
        return image
    }()
    
    private lazy var userName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .purple
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var segmentControl: UISegmentedControl = {
        var segment = UISegmentedControl()
        segment.translatesAutoresizingMaskIntoConstraints = false
        let items = ["", ""]
        segment = UISegmentedControl(items: items)
        segment.backgroundColor = .white
        segment.selectedSegmentTintColor = .white
        segment.selectedSegmentIndex = 0
        let heartImage = UIImage(systemName:"heart.fill")?.withRenderingMode(.alwaysOriginal)
        let bookImage = UIImage(systemName:"books.vertical.fill")?.withRenderingMode(.alwaysOriginal)
        segment.setImage(heartImage, forSegmentAt: 0)
        segment.setImage(bookImage, forSegmentAt: 1)
        return segment
    }()
    
    private lazy var likeListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemGray6
        collectionView.register(
            UserCollectionViewCell.self,
            forCellWithReuseIdentifier: UserCollectionViewCell.Identifier.path.rawValue
        )
        return collectionView
    }()
    
    //MARK: - Properties
    private let dataBase = Firestore.firestore()
    private var firestorePhoto: [String] = []
    var favoriteUserDefaultData: [String] = []
    var isFavorite = false
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        segmentControl.selectedSegmentIndex = 0
        fetchFavorite()
    }
    
    //MARK: - Private Func
    
    private func initDelegate() {
        likeListCollectionView.delegate = self
        likeListCollectionView.dataSource = self
        
        configure()
    }
    
    private func configure() {
        navigationItem.title = "Profile"
        view.backgroundColor = .white
        view.addSubview(UserImage)
        view.addSubview(userName)
        view.addSubview(segmentControl)
        view.addSubview(likeListCollectionView)
        
        configureNavitaionBar()
        createSegmentConntrol()
        
        makeUserName()
        makeUserImage()
        makeSegmentController()
        makeLikeCollection()
        
        UserImage.image = UIImage(named: "UnknownUser")
        userName.text = "EfendiCagla"
        
       
    }
    
    private func fetchFavorite() {
        let resentUserDefault = UserDefaults.standard
        favoriteUserDefaultData = resentUserDefault.object(forKey: "recent") as? [String] ?? [String]()
        isFavorite = true
        DispatchQueue.main.async {
            self.likeListCollectionView.reloadData()
        }
    }
    
    private func fetchFirestorePhoto() {
        let docRef = dataBase.document("libraries/photos")
        docRef.getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }
            
            guard let photoArray = data["text"] as? [String] else {
                return
            }
            self.firestorePhoto = photoArray
            DispatchQueue.main.async {
                self.likeListCollectionView.reloadData()
                self.isFavorite = false
            }
        }
       
    }
    
    private func createSegmentConntrol() {
            segmentControl.addTarget(self, action: #selector(click(_:)), for: .valueChanged)
        }

        @objc func click(_ segmentControl: UISegmentedControl) {
            switch segmentControl.selectedSegmentIndex {
            case 0:
                segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], for: UIControl.State.normal)
                fetchFavorite()
                firestorePhoto.removeAll()
            default:
                segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: UIControl.State.normal)
                fetchFirestorePhoto()
                favoriteUserDefaultData.removeAll()
               
        }
    }
    
    private func configureNavitaionBar() {
        let rightButton = UIBarButtonItem(title: "Sign Out", style: .plain , target: self, action: #selector(signOut(_:)))
        navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc func signOut(_ navigationItem: UIBarButtonItem) {
        print("sign out")
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension UserVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFavorite {
           return favoriteUserDefaultData.count
        }
        return firestorePhoto.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCollectionViewCell.Identifier.path.rawValue, for: indexPath) as? UserCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if isFavorite {
            cell.saveModel(jpg: favoriteUserDefaultData[indexPath.row])
        }else{
            cell.saveModel(jpg: firestorePhoto[indexPath.row])
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

//MARK: - Constraints

extension UserVC {
    private func makeUserImage() {
        UserImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(view).offset(24)
            make.height.equalTo(view.frame.size.height / 12)
            make.width.equalTo(view.frame.size.height / 12)
        }
    }
    
    private func makeUserName() {
        userName.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(view.frame.size.height / 36)
            make.left.equalTo(UserImage.snp.right).offset(16)
        }
    }
    
    private func makeSegmentController() {
        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(UserImage.snp.bottom).offset(16)
            make.left.right.equalTo(view)
        }
    }
    
    private func makeLikeCollection() {
        likeListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(0)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalTo(view)
        }
    }
}
