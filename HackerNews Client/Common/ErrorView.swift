//
//  ErrorView.swift
//  HackerNews Client
//
//  Created by Divyansh Jain on 13/11/19.
//  Copyright © 2019 Divyansh  Jain. All rights reserved.
//

import UIKit

public protocol ErrorViewDelegate: class {

    func didTapRetryButton(_ errorView: ErrorView)
    
}

public class ErrorView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var retryButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle("Retry", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return button
    }()
    
    public weak var delegate: ErrorViewDelegate?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        createViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func setMessage(_ message: String) {
        titleLabel.text = message
    }
}

private extension ErrorView {
    
    func createViews() {
        addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                            constant: UIConstants.sidePadding).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                             constant: -UIConstants.sidePadding).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor,
                                        constant: UIConstants.verticalPadding).isActive = true
        
        retryButton.addTarget(self, action: #selector(didTapRetryButton), for: .touchUpInside)
        addSubview(retryButton)
        retryButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        retryButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                         constant: UIConstants.betweenPadding).isActive = true
        retryButton.bottomAnchor.constraint(equalTo: bottomAnchor,
                                         constant: -UIConstants.verticalPadding).isActive = true
        
    }
    
    @objc func didTapRetryButton() {
        delegate?.didTapRetryButton(self)
    }
    
    
}
