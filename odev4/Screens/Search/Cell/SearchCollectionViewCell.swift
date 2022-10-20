//
//  SearchCollectionViewCell.swift
//  odev4
//
//  Created by Cagla Efendioglu on 12.10.2022.
//

import UIKit
import SnapKit
//import AlamofireImage

class SearchCollectionViewCell: UICollectionViewCell {

    //MARK: - Views

    private lazy var  searchImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        //image.layer.cornerRadius = 8
        //image.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return image
    }()
    
    enum Identifier: String {
        case path = "Cell"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
       
    }

    private func configure() {
        contentView.addSubview(searchImage)
    
        contentView.backgroundColor = .white
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.layer.cornerRadius = 8
        
        configureConstraints()
    }
    
    private func configureConstraints() {
        makeImage()
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
                    self.searchImage.image = UIImage(data: dataTwo)
                }
            }
        }
    }
    
    func saveModel(item: Photo) {
        setImage(value: item)
    }
}

//MARK: - Constraints

extension  SearchCollectionViewCell {
    private func makeImage() {
        NSLayoutConstraint.activate([
            searchImage.heightAnchor.constraint(equalToConstant: contentView.frame.size.height),
            searchImage.widthAnchor.constraint(equalToConstant: contentView.frame.size.width),
        ])
    }
}

