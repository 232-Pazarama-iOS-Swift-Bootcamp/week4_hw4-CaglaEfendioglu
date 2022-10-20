//
//  HomeTableViewCell.swift
//  odev4
//
//  Created by Cagla Efendioglu on 12.10.2022.
//

import UIKit

protocol cellFavoriteDelegate: AnyObject {
    func clickFavoriteButton(with item: IndexPath)
    func clickLibraryButton(with item: IndexPath)
}


class HomeTableViewCell: UITableViewCell {
    
    private lazy var UserImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = contentView.frame.size.width / 14
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
    
    private lazy var flickrImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 10.0
        return image
    }()
    
    private lazy var addFavoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.backgroundColor = .white
        return button
    }()
    
    
    private lazy var addLibraryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "books.vertical.fill"), for: .normal)
        return button
    }()
    
    weak var delegate: cellFavoriteDelegate?
    var cellIndexPath: IndexPath?
    
    enum Identifier: String {
        case path = "Cell"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func prepareForReuse() {
        if let url = URL(string: "") {
            DispatchQueue.global().async {
                let data  = try? Data(contentsOf: url)

                DispatchQueue.main.async {
                    guard let dataTwo = data else { return }
                    self.flickrImage.image = UIImage(data: dataTwo)
                }
            }
        }
    }
    
    private func configure() {
        contentView.addSubview(UserImage)
        contentView.addSubview(userName)
        contentView.addSubview(flickrImage)
        contentView.addSubview(addFavoriteButton)
        contentView.addSubview(addLibraryButton)
    
        makeUserImage()
        makeUserName()
        makeFlickrImage()
        makeFavoriteButton()
        makeLibraryButton()
        
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 1
        
        addFavoritePhoto()
        addLibraryPhoto()
    }


        private func setImage(value: Photo) {
            let serverID = value.server ?? ""
            let id = value.id ?? ""
            let secretID = value.secret ?? "" 
    
            if let url = URL(string: "https://live.staticflickr.com/\(serverID)/\(id)_\(secretID).jpg") {
                DispatchQueue.global().async {
                    let data  = try? Data(contentsOf: url)
    
                    DispatchQueue.main.async {
                        guard let dataTwo = data else { return }
                        self.flickrImage.image = UIImage(data: dataTwo)
                    }
                }
            }
        }
    
    private func addFavoritePhoto() {
        addFavoriteButton.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
    }
    
    @objc func click(_ addFavoriteButton: UIButton) {
        if let index = cellIndexPath {
            delegate?.clickFavoriteButton(with: index)
        }
    }
    
    private func addLibraryPhoto() {
        addLibraryButton.addTarget(self, action: #selector(clickLibrary(_:)), for: .touchUpInside)
    }
    
    @objc func clickLibrary(_ addLibraryButton: UIButton) {
        if let index = cellIndexPath {
            delegate?.clickLibraryButton(with: index)
        }
    }
    
    func saveModel(value: Photo) {
        UserImage.image = UIImage(named: "UnknownUser")
        userName.text = "Unknown"
        setImage(value: value)

        
    }
}


extension HomeTableViewCell {
    private func makeUserImage() {
        UserImage.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(8)
            make.left.equalTo(contentView).offset(8)
            make.width.equalTo(contentView.frame.size.width / 7)
            make.height.equalTo(contentView.frame.size.width / 7)
        }
    }
    
    private func makeUserName() {
        userName.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(contentView.frame.size.width / 21 + 8)
            make.left.equalTo(UserImage.snp.right).offset(16)
        }
    }
    
    private func makeFlickrImage() {
        flickrImage.snp.makeConstraints { make in
            make.top.equalTo(UserImage.snp.bottom).offset(16)
            make.centerX.equalTo(contentView.snp.centerX)
            make.width.equalTo(contentView.frame.size.width)
            make.height.equalTo(contentView.frame.size.height * 5)
        }
    }
    
    private func makeFavoriteButton() {
        addFavoriteButton.snp.makeConstraints { make in
            make.top.equalTo(flickrImage.snp.bottom).offset(8)
            make.left.equalTo(contentView).offset(24)
            make.width.equalTo(contentView.frame.size.width / 6)
            make.height.equalTo(contentView.frame.size.height)
        }
    }
    
    private func makeLibraryButton() {
        addLibraryButton.snp.makeConstraints { make in
            make.top.equalTo(flickrImage.snp.bottom).offset(8)
            make.right.equalTo(contentView).offset(-24)
            make.width.equalTo(contentView.frame.size.width / 6)
            make.height.equalTo(contentView.frame.size.height)
        }
    }
}
