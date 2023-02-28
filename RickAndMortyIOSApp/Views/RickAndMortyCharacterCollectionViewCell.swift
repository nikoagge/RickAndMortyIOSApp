//
//  RickAndMortyCharacterCollectionViewCell.swift
//  RickAndMortyIOSApp
//
//  Created by Nikos Aggelidis on 26/2/23.
//

import UIKit

final class RickAndMortyCharacterCollectionViewCell: UICollectionViewCell {
    static let identifier = "RickAndMortyCharacterCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 18, weight: .medium)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return nameLabel
    }()
    
    private let statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.font = .systemFont(ofSize: 16, weight: .regular)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return statusLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        initializeValues()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupContentViewLayer()
    }
    
    public func configure(with rickAndMortyCharacterCollectionViewCellViewModel: RickAndMortyCharacterCollectionViewCellViewModel) {
        nameLabel.text = rickAndMortyCharacterCollectionViewCellViewModel.characterName
        statusLabel.text = rickAndMortyCharacterCollectionViewCellViewModel.characterStatusText
        rickAndMortyCharacterCollectionViewCellViewModel.fetchImage { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self?.imageView.image = image
                }
                
            case .failure(let error):
                debugPrint(String(describing: error))
                break
            }
        }
    }
}

private extension RickAndMortyCharacterCollectionViewCell {
    func setupUI() {
        setupContentView()
        addConstraints()
    }
    
    func setupContentView() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubviews(imageView, nameLabel, statusLabel)
        setupContentViewLayer()
    }
    
    func setupContentViewLayer() {
        contentView.layer.cornerRadius = 8
        contentView.layer.shadowColor = UIColor.label.cgColor
        contentView.layer.cornerRadius = 4
        contentView.layer.shadowOffset = CGSize(width: -4, height: 4)
        contentView.layer.shadowOpacity = 0.3
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 3),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            nameLabel.heightAnchor.constraint(equalToConstant: 30),
            
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),
            statusLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func initializeValues() {
        imageView.image = nil
        nameLabel.text = nil
        statusLabel.text = nil
    }
}
