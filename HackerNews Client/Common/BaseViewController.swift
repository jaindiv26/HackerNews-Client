//
//  BaseViewController.swift
//  HackerNews Client
//
//  Created by Divyansh Jain on 13/11/19.
//  Copyright © 2019 Divyansh  Jain. All rights reserved.
//

import UIKit

public class BaseViewController: UIViewController, ErrorViewDelegate {
    
    private static let toastVisibleTime: TimeInterval = 2.0
    
    private lazy var toastView: ToastView = .init(frame: .zero)
    private lazy var errorView: ErrorView = .init(frame: .zero)
    private var toastViewBottomConstraint: NSLayoutConstraint?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        createViews()
    }
    
    public func showErrorView(_ errorMessage: String?) {
        view.bringSubviewToFront(errorView)
        if let errorMessage = errorMessage, !errorMessage.isEmpty {
            errorView.setMessage(errorMessage)
        }
        else {
            errorView.setMessage("👨‍🔧\nSomething went wrong!\nPlease try again later.")
        }
        errorView.isHidden = false
        errorView.hideRetryButton(false)
    }
    
    public func hideErrorView() {
        errorView.isHidden = true
    }
    
    public func hideRetryButton(_ isHidden: Bool) {
        errorView.hideRetryButton(isHidden)
    }
    
    public func showErrorMessage(_ errorMessage: String?) {
        toastView.backgroundColor = .red
        if let errorMessage = errorMessage, !errorMessage.isEmpty {
            toastView.setMessage(errorMessage)
        }
        else {
            toastView.setMessage("👨‍🔧\nSomething went wrong!")
        }
        showToastView()
    }
    
    public func didTapRetryButton(_ errorView: ErrorView) {
        //To be overriden if needed
    }
    
}

private extension BaseViewController {
    
    func createViews() {
        errorView.delegate = self
        errorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(errorView)
        errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                           constant: UIConstants.sidePadding).isActive = true
        errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                            constant: -UIConstants.sidePadding).isActive = true
        errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        toastView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toastView)
        toastView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                            constant: UIConstants.sidePadding).isActive = true
        toastView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                             constant: -UIConstants.sidePadding).isActive = true
        toastViewBottomConstraint = toastView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                                      constant: 200)
        toastViewBottomConstraint?.isActive = true
        
        
    }
    
    private func showToastView() {
        if toastView.isVisible {
            return
        }
        toastView.isVisible = true
        view.bringSubviewToFront(toastView)
        self.view.layoutIfNeeded()
        toastViewBottomConstraint?.constant = -UIConstants.verticalPadding
        UIView.animate(withDuration: 0.35,
                       delay: 0,
                       usingSpringWithDamping: 0.88,
                       initialSpringVelocity: 0.4,
                       options: .curveEaseInOut,
                       animations: {
                        self.view.layoutIfNeeded()
        }) { (_) in
            DispatchQueue.main.asyncAfter(deadline: .now() + BaseViewController.toastVisibleTime) {
                self.hideToastView()
            }
        }
    }
    
    private func hideToastView() {
        self.view.layoutIfNeeded()
        toastViewBottomConstraint?.constant = 200
        UIView.animate(withDuration: 0.35,
                      delay: 0,
                      usingSpringWithDamping: 0.88,
                      initialSpringVelocity: 0.4,
                      options: .curveEaseInOut,
                      animations: {
                       self.view.layoutIfNeeded()
        }) { (_) in
            self.toastView.isVisible = false
        }
    }
    
}



