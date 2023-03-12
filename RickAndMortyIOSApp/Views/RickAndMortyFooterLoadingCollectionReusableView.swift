//
//  RickAndMortyFooterLoadingCollectionReusableView.swift
//  RickAndMortyIOSApp
//
//  Created by Nikos Aggelidis on 1/3/23.
//

import UIKit

final class RickAndMortyFooterLoadingCollectionReusableView: UICollectionReusableView {
    static let identifier = "RickAndMortyFooterLoadingCollectionReusableView"
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    public func startAnimating() {
        spinner.startAnimating()
    }
}

private extension RickAndMortyFooterLoadingCollectionReusableView {
    func setupUI() {
        backgroundColor = .systemBackground
        setupSpinner()
    }
    
    func setupSpinner() {
        addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
