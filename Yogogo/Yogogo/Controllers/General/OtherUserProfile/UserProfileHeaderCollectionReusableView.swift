//
//  UserProfileHeaderCollectionReusableView.swift
//  Yogogo
//
//  Created by prince on 2020/12/14.
//

import UIKit
import Kingfisher

class UserProfileHeaderCollectionReusableView: UICollectionReusableView {
        
    let userManager = UserManager.shared
    
    var isFollowing = false
        
    static let identifier = "UserProfileHeaderCollectionReusableView"
    
    @IBOutlet weak var profileImageView: UIImageView! {
        didSet {
            profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
            
            let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/yogogo-ddcf9.appspot.com/o/profilePhotos%2FybdK3sBSu8d6gx3XNrsvgf8HLBo2.jpg?alt=media&token=acfe0404-0247-4e44-a261-bd64436b55ff")
            profileImageView.kf.setImage(with: url)
        }
    }
    
    @IBOutlet weak var followButton: UIButton! {
        didSet {
            followButton.setTitle("Follow", for: .normal)
            followButton.setTitleColor(.white, for: .normal)
            followButton.backgroundColor = .systemBlue
            followButton.layer.borderWidth = 0
            followButton.layer.cornerRadius = 4
            followButton.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var messageButton: UIButton! {
        didSet {
            messageButton.layer.borderWidth = 0.5
            messageButton.layer.borderColor = UIColor.lightGray.cgColor
            messageButton.layer.cornerRadius = 4
            messageButton.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.text = "來自北一の阿雙"
        }
    }
    
    @IBOutlet weak var bioLabel: UILabel! {
        didSet {
            bioLabel.text = "如果我沒在笑，那就是在準備笑🐱"
        }
    }
    
    @IBOutlet weak var postsCountButton: UIButton!
    
    @IBOutlet weak var followersCountButton: UIButton!
    
    @IBOutlet weak var followingCountButton: UIButton!
    
    @IBAction func postsButtonDidTap(_ sender: UIButton) {
    }
    
    @IBAction func followersButtonDidTap(_ sender: UIButton) {
    }
    
    @IBAction func followingButtonDidTap(_ sender: UIButton) {
    }
    
    @IBAction func followButtonDidTap(_ sender: UIButton) {
        
        isFollowing ? unfollow() : follow()
        isFollowing.toggle()
    }
    
    @IBAction func messageButtonDidTap(_ sender: UIButton) {
    }
    
    func setup() {
        
//        guard let profileImage = userManager.currentUser?.profileImage else { return }
//        let url = URL(string: profileImage)
//        profileImageView.kf.setImage(with: url)
//
//        nameLabel.text = userManager.currentUser?.fullName
//        bioLabel.text = userManager.currentUser?.bio
//
//        let postsCount = String((userManager.currentUser?.posts.count ?? 1) - 1)
//            postsCountButton.setTitle(postsCount, for: .normal)
//
//        let followersCount = String((userManager.currentUser?.followers.count ?? 1) - 1)
//        followersCountButton.setTitle(followersCount, for: .normal)
//
//        let followingCount = String((userManager.currentUser?.following.count ?? 1) - 1)
//        followingCountButton.setTitle(followingCount, for: .normal)
    }
}

extension UserProfileHeaderCollectionReusableView {
    
    func follow() {
        followButton.setTitle("Following", for: .normal)
        followButton.setTitleColor(.label, for: .normal)
        followButton.backgroundColor = .clear
        followButton.layer.borderWidth = 0.5
        followButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func unfollow() {
        followButton.setTitle("Follow", for: .normal)
        followButton.setTitleColor(.white, for: .normal)
        followButton.backgroundColor = .systemBlue
        followButton.layer.borderWidth = 0
    }
}
