//
//  UserCollectionViewCell.swift
//  odev4
//
//  Created by Cagla Efendioglu on 12.10.2022.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Views

    private lazy var  favOrLibImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 8
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
        favOrLibImage.image = UIImage(named: "")
    }

    private func configure() {
        contentView.addSubview(favOrLibImage)
    
        contentView.backgroundColor = .white
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.layer.cornerRadius = 8
        
        configureConstraints()
    }
    
    private func configureConstraints() {
        makeImage()
    }
    
    private func setImage(jpg: String) {
    
        if let url = URL(string: jpg) {
            DispatchQueue.global().async {
                let data  = try? Data(contentsOf: url)

                DispatchQueue.main.async {
                    guard let dataTwo = data else { return }
                    self.favOrLibImage.image = UIImage(data: dataTwo)
                }
            }
        }
    }
    
    func saveModel(jpg: String) {
       setImage(jpg: jpg)
    }
}

//MARK: - Constraints

extension  UserCollectionViewCell {
    private func makeImage() {
        NSLayoutConstraint.activate([
            favOrLibImage.heightAnchor.constraint(equalToConstant: contentView.frame.size.height),
            favOrLibImage.widthAnchor.constraint(equalToConstant: contentView.frame.size.width),
        ])
    }
}

