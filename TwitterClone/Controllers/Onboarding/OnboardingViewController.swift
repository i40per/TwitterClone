//
//  OnboardingViewController.swift
//  TwitterClone
//
//  Created by Евгений Лукин on 06.06.2023.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "See what's happening in the world right now."
        label.font = .systemFont(ofSize: 32, weight: .heavy)
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
       return label
    }()
    
    private let createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create account", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.backgroundColor = .twitterBlueCollor
        button.layer.masksToBounds = true
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.translatesAutoresizingMaskIntoConstraints = false
       return button
    }()
    
    private let promptLabel: UILabel = {
        let label = UILabel()
        label.tintColor = .gray
        label.text = "Have an account already?"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
       return label
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.tintColor = .twitterBlueCollor
        button.translatesAutoresizingMaskIntoConstraints = false
       return button
    }()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(welcomeLabel)
        view.addSubview(createAccountButton)
        view.addSubview(promptLabel)
        view.addSubview(loginButton)
        
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        
        configureConstraints()
    }
    
    @objc private func didTapLogin() {
        let vc = LoginViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapCreateAccount() {
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - configureConstraints
    private func configureConstraints() {
        let welcomeLabelConstraimts = [
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        let createAccountButtonConstraints = [
            createAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createAccountButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            createAccountButton.widthAnchor.constraint(equalTo: welcomeLabel.widthAnchor, constant: -20),
            createAccountButton.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        let promptLabelConstraints = [
            promptLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            promptLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)
        ]
        
        let loginButtonConstraints = [
            loginButton.centerYAnchor.constraint(equalTo: promptLabel.centerYAnchor),
            loginButton.leadingAnchor.constraint(equalTo: promptLabel.trailingAnchor, constant: 10)
        ]
        
        NSLayoutConstraint.activate(welcomeLabelConstraimts)
        NSLayoutConstraint.activate(createAccountButtonConstraints)
        NSLayoutConstraint.activate(promptLabelConstraints)
        NSLayoutConstraint.activate(loginButtonConstraints)
    }
}
