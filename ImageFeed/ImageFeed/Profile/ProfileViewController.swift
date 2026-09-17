//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by никита on 06.07.2026.
//

import UIKit
import Kingfisher

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
        
        addObserver()
        
        if let profile = ProfileService.shared.profile {
            updateProfileDetails(profile: profile)
        }
        updateAvatar()
    }
    deinit {
        removeObserver()
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateAvatar),
            name: ProfileImageService.didChangeNotification,
            object: nil
        )
    }
    
    private func removeObserver() {
        NotificationCenter.default.removeObserver(
            self,
            name: ProfileImageService.didChangeNotification,
            object: nil
        )
    }
    
    @objc
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let imageUrl = URL(string: profileImageURL)
        else { return }
        
        let placeholderImage = UIImage(systemName: "person.crop.circle.fill")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 70, weight: .regular, scale: .large))
        
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        avatarImageView.kf.indicatorType = .activity
        avatarImageView.kf.setImage(
            with: imageUrl,
            placeholder: placeholderImage,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ]
        )
    }
    
    private func updateProfileDetails(profile: Profile) {
        nameLabel.text = (profile.name?.isEmpty ?? true) ? "Имя не указано" : profile.name
        loginNameLabel.text = (profile.loginName?.isEmpty ?? true) ? "@неизвестный_пользователь" : profile.loginName
        descriptionLabel.text = (profile.bio?.isEmpty ?? true) ? "Профиль не заполнен" : profile.bio
    }
    
    private func addAvatarImageView() {
        let imageView = UIImageView()
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        self.avatarImageView = imageView
    }
    
    private func addNameLabel() {
        let label = UILabel()
        label.textColor = .ypWhiteIOS
        label.font = .systemFont(ofSize: 23, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            label.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        self.nameLabel = label
    }
    
    private func addLoginNameLabel() {
        let label = UILabel()
        label.textColor = .ypGrayIOS
        label.font = .systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            label.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
        ])
        
        self.loginNameLabel = label
    }
    
    private func addDescriptionLabel() {
        let label = UILabel()
        label.textColor = .ypWhiteIOS
        label.font = .systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: loginNameLabel.leadingAnchor),
            label.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: loginNameLabel.trailingAnchor)
        ])
        
        self.descriptionLabel = label
    }
    
    private func addLogoutButton() {
        guard let image = UIImage(systemName: "ipad.and.arrow.forward") else { return }
        let button = UIButton.systemButton(with: image, target: self, action: #selector(didTapLogoutButton))
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            button.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor)
        ])
        
        self.logoutButton = button
    }
    
    @objc private func didTapLogoutButton() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert
        )
        let confirmAction = UIAlertAction(title: "Да", style: .default) { _ in
            ProfileLogoutService.shared.logout()
        }
        let cancelAction = UIAlertAction(title: "Нет", style: .cancel)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}
