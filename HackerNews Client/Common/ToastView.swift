//
//  ToastView.swift
//  HackerNews Client
//
//  Created by Divyansh Jain on 13/11/19.
//  Copyright © 2019 Divyansh  Jain. All rights reserved.
//

import UIKit

public class ToastView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    public var isVisible: Bool = false
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        createViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setMessage(_ message: String?) {
        titleLabel.text = message
    }
}

private extension ToastView {
    
    func createViews() {
        clipsToBounds = true
        layer.cornerRadius = UIConstants.cornerRadius
        
        addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                            constant: UIConstants.sidePadding).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                             constant: -UIConstants.sidePadding).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor,
                                        constant: UIConstants.verticalPadding).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor,
                                           constant: -UIConstants.verticalPadding).isActive = true
    }
    
    
}
