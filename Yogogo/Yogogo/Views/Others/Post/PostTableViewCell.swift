//
//  PostTableViewCell.swift
//  Yogogo
//
//  Created by prince on 2020/12/3.
//

import UIKit
import Kingfisher

protocol PostTableViewCellPresentAlertDelegate: AnyObject {
    func presentAlert(postId: String)
}

protocol PostTableViewCellPresentUserDelegate: AnyObject {
    func presentUser()
}

// MARK: -

class PostTableViewCell: UITableViewCell {
    
    static let identifier = "PostTableViewCell"
    
    let userManager = UserManager.shared
    
    private var currentPost: Post?
    
    private var currentUser: User?
    
    // MARK: - delegate
    
    weak var delegatePresentAlert: PostTableViewCellPresentAlertDelegate?
    
    weak var delegatePresentUser: PostTableViewCellPresentUserDelegate?
    
    weak var delegateReloadView: ButtonDidTapReloadDelegate?
    
    // MARK: - @IBOutlet
    
    @IBOutlet weak var profileImage: UIImageView! {
        didSet {
            profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
            profileImage.layer.masksToBounds = true
            profileImage.translatesAutoresizingMaskIntoConstraints = false
            profileImage.contentMode = .scaleAspectFill
        }
    }
    
    @IBOutlet weak var usernameButton: UIButton!
    
    @IBOutlet weak var moreActionsButton: UIButton!
    
    @IBOutlet weak var likeButton: UIButton! {
        didSet {
            configureLikeButton()
        }
    }
    
    @IBOutlet weak var commentButton: UIButton! {
        didSet {
            let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
            let image = UIImage(systemName: "message", withConfiguration: config)
            commentButton.setImage(image, for: .normal)
            commentButton.tintColor = .label
        }
    }
    
    @IBOutlet weak var shareButton: UIButton! {
        didSet {
            let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
            let image = UIImage(systemName: "paperplane", withConfiguration: config)
            shareButton.setImage(image, for: .normal)
            shareButton.tintColor = .label
            shareButton.isHidden = true
        }
    }
    
    @IBOutlet weak var bookmarkButton: UIButton! {
        didSet {
            let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
            let image = UIImage(systemName: "bookmark", withConfiguration: config)
            bookmarkButton.setImage(image, for: .normal)
            bookmarkButton.tintColor = .label
            bookmarkButton.isHidden = true
        }
    }
    
    @IBOutlet weak var moreContentButton: UIButton!
    
    @IBOutlet weak var viewCommentsButton: UIButton!
    
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var postImageView: UIImageView! {
        didSet {
            postImageView.layer.cornerRadius = 4
            postImageView.layer.masksToBounds = true
            postImageView.translatesAutoresizingMaskIntoConstraints = false
            postImageView.contentMode = .scaleAspectFit
        }
    }

    // MARK: - @IBAction
    
    @IBAction func moreActionsButtonDidTap(_ sender: UIButton) {
        guard let postId = currentPost?.postId else { return }
        self.delegatePresentAlert?.presentAlert(postId: postId)
    }
    
    @IBAction func usernameButtonDidTap(_ sender: UIButton) {
        self.delegatePresentUser?.presentUser()
    }
    
    @IBAction func moreCaptionButtonDidTap(_ sender: UIButton) {
        captionLabel.numberOfLines = 0
        moreContentButton.isHidden = true
        delegateReloadView?.reloadView(cell: self)
    }
    
    @IBAction func likeButtonDidTap(_ sender: UIButton) {
        // Change local view
        sender.isSelected.toggle()
        configureLikeButton()
        
        // HUD
        if likeButton.isSelected {
            WrapperProgressHUD.showHeart()
        }
        
        // Data
        guard let currentPost = currentPost else { return }
        PostManager.shared.updateUserDidLike(post: currentPost)
    }
    
    // MARK: -
    
    private func configureLikeCount(with currentPost: Post) {
        let count = currentPost.userDidLike.filter { $0 != "" }.count
        switch count {
        case 0:
            self.likeButton.setTitle("", for: .normal)
        default:
            self.likeButton.setTitle(" \(count)", for: .normal)
        }
    }
    
    private func configureLikeButton() {
        let size: CGFloat = 19
        
        if likeButton.isSelected {
            let config = UIImage.SymbolConfiguration(pointSize: size, weight: .medium)
            let image = UIImage(systemName: "heart.fill", withConfiguration: config)
            likeButton.setImage(image, for: .selected)
            likeButton.tintColor = .systemRed
            
        } else {
            let config = UIImage.SymbolConfiguration(pointSize: size, weight: .medium)
            let image = UIImage(systemName: "heart", withConfiguration: config)
            likeButton.setImage(image, for: .normal)
            likeButton.tintColor = .label
        }
    }
    
    private func setupLikeButton(with currentPost: Post) {
        guard let userId = self.userManager.currentUser?.userId else { return }
        self.likeButton.isSelected = currentPost.userDidLike.contains(userId)
        self.configureLikeButton()
        self.configureLikeCount(with: currentPost)
    }
    
    private func setupViewCommentsButton(with currentPost: Post) {
        var comments: [String] = []
        if let ignoreList = UserManager.shared.currentUser?.ignoreList {
            for userId in ignoreList {
                comments = currentPost.comments.filter { $0 != userId }.filter { $0 != "" }
            }
        }
        let count = comments.count
        switch count {
        case 0:
            viewCommentsButton.isHidden = true
        case 1:
            viewCommentsButton.isHidden = false
            viewCommentsButton.setTitle("View \(count) comment", for: .normal)
        default:
            viewCommentsButton.isHidden = false
            viewCommentsButton.setTitle("View \(count) comments", for: .normal)
        }
    }
    
    private func setupCaptionLabel(with currentPost: Post) {
        captionLabel.text = currentPost.caption
    }
    
    private func setupMoreContentButton() {
        let isHidden = self.captionLabel.numberOfLines == 0 ? true : self.captionLabel.textCount <= 1
        self.moreContentButton.isHidden = isHidden
    }
    
    private func setupAuthorInfo(with currentPost: Post) {
        userManager.getAuthorInfo(userId: currentPost.userId) { [weak self] (user) in
            self?.currentUser = user
            self?.usernameButton.setTitle(user.username, for: .normal)
            let url = URL(string: user.profileImage)
            self?.profileImage.kf.setImage(with: url)
        }
    }
    
    private func setupPostImage(with currentPost: Post) {
        let url = URL(string: currentPost.imageFileURL)
        postImageView.kf.setImage(with: url)
    }
    
    private func setupTimestampLabel(with currentPost: Post) {
        let stringTimestamp = String(currentPost.timestamp / 1000)
        let date = DateClass.compareCurrentTime(str: stringTimestamp)
        timestampLabel.text = "\(date)"
    }

    // MARK: -
    
    func setup(post: Post) {
        selectionStyle = .none
        
        PostManager.shared.observeUserPost(postId: post.postId) { [weak self] (currentPost) in
            
            self?.currentPost = currentPost
            self?.setupLikeButton(with: currentPost)
            self?.setupViewCommentsButton(with: currentPost)
            self?.setupCaptionLabel(with: currentPost)
            self?.setupMoreContentButton()
            self?.setupAuthorInfo(with: currentPost)
            self?.setupPostImage(with: currentPost)
            self?.setupTimestampLabel(with: currentPost)
        }
    }
}
