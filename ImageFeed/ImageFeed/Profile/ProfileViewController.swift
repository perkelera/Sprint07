//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by никита  on 06.07.2026.
//

import UIKit
final class ProfileViewController: UIViewController {
    private var avatarImageView: UIImageView!
    private var nameLabel: UILabel!
    private var loginNameLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YP Black") ?? .ypBlackIOS
        addAvatarImageView()
        addNameLabel()
        addLoginNameLabel()
        addDescriptionLabel()
        addLogoutButton()
    }
    
    private func addAvatarImageView() {
        let profileImage = UIImage(named: "Photo") ?? UIImage(systemName: "person.crop.circle.fill")
        let imageView = UIImageView(image: profileImage)
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.avatarImageView = imageView
    }
    
    private func addNameLabel() {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.textColor = .ypWhiteIOS
        label.font = .systemFont(ofSize: 23, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8).isActive = true
        label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        self.nameLabel = label
    }
    
    private func addLoginNameLabel() {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.textColor = .ypGrayIOS
        label.font = .systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        label.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        self.loginNameLabel = label
    }
    private func addDescriptionLabel() {
        let label = UILabel()
        label.text = "Hello, world!"
        label.textColor = .ypWhiteIOS
        label.font = .systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.leadingAnchor.constraint(equalTo: loginNameLabel.leadingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8).isActive = true
        label.trailingAnchor.constraint(equalTo: loginNameLabel.trailingAnchor).isActive = true
        self.descriptionLabel = label
    }
    private func addLogoutButton() {
        let button = UIButton.systemButton(with: UIImage( systemName: "ipad.and.arrow.forward")!, target: self, action: #selector(Self.didTapLogoutButton)
        )
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        button.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor).isActive = true
        self.logoutButton = button
    }
    @objc
    private func didTapLogoutButton() {
    }
}
