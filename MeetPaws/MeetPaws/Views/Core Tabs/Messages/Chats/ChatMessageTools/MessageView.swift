//
//  MessageView.swift
//  Insdogram
//
//  Created by prince on 2020/12/21.
//

import UIKit
import Kingfisher

class MessageView: UIView {

    var userName: String!
    
    var cell: ChatCell!
    
    var message: Messages!
    
    let messageView = UILabel()
    
    let mediaMessage = UIImageView()
    
    let responseLine = UIView()
    
    let responseNameLabel = UILabel()
    
    let responseTextMessage = UILabel()
    
    let responseMediaMessage = UIImageView()
    
    // MARK: -
    
    init(frame: CGRect, cell: ChatCell, message: Messages, userName: String) {
        super.init(frame: frame)
        self.cell = cell
        self.message = message
        self.userName = userName
        showMessageMenu()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    
    private func showMessageMenu() {
        layer.cornerRadius = 12
        layer.masksToBounds = true
        backgroundColor = cell.messageBackground.backgroundColor
        if message.message != nil {
            addSubview(setupMsgText())
            if message.repMID != nil {
                setupResponseView()
            }
        } else if message.mediaUrl != nil {
            addSubview(setupMsgMedia())
        }
    }
    
    // MARK: -
    
    private func setupResponseView() {
        setupRepLine()
        setupRepName(name: message.repSender)
        if message.repMessage != nil {
            setupRepTextMessage(text: message.repMessage)
        } else if message.repMediaMessage != nil {
            setupRepMediaMessage(message.repMediaMessage)
        }
    }
    
    // MARK: -
    
    private func setupMsgText() -> UILabel {
        messageView.text = message.message
        messageView.numberOfLines = 0
        messageView.backgroundColor = .clear
        messageView.textColor = cell.message.textColor
        addSubview(messageView)
        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageView.font = UIFont(name: "Helvetica Neue", size: 16)
        if message.repMID != nil {
            messageView.topAnchor.constraint(equalTo: topAnchor, constant: 50).isActive = true
        } else {
            messageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        }
        let constraints = [
            messageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            messageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            messageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ]
        NSLayoutConstraint.activate(constraints)
        return messageView
    }
    
    // MARK: -
    
    private func setupMsgMedia() -> UIImageView {
        let url = URL(string: message.mediaUrl)
        mediaMessage.kf.setImage(with: url)
        
        addSubview(mediaMessage)
        mediaMessage.translatesAutoresizingMaskIntoConstraints = false
        mediaMessage.layer.cornerRadius = 16
        mediaMessage.layer.masksToBounds = true
        mediaMessage.contentMode = .scaleAspectFill
        let constraints = [
            mediaMessage.topAnchor.constraint(equalTo: topAnchor),
            mediaMessage.centerYAnchor.constraint(equalTo: centerYAnchor),
            mediaMessage.widthAnchor.constraint(equalTo: widthAnchor),
            mediaMessage.heightAnchor.constraint(equalTo: heightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        return mediaMessage
    }
    
    // MARK: -
    
    private func setupRepLine() {
        responseLine.backgroundColor = .systemBackground
        addSubview(responseLine)
        responseLine.translatesAutoresizingMaskIntoConstraints = false
        responseLine.backgroundColor = cell.responseLine.backgroundColor
        let constraints = [
            responseLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            responseLine.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            responseLine.bottomAnchor.constraint(equalTo: messageView.topAnchor, constant: -2),
            responseLine.widthAnchor.constraint(equalToConstant: 2)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: -
    
    private func setupRepName(name: String) {
        responseNameLabel.text = name
        responseNameLabel.textColor = cell.responseNameLabel.textColor
        responseNameLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        responseNameLabel.adjustsFontSizeToFitWidth = true
    }
    
    // MARK: -
    
    private func setupRepTextMessage(text: String) {
        responseTextMessage.text = text
        responseTextMessage.textColor = cell.responseTextMessage.textColor
        responseTextMessage.font = UIFont(name: "Helvetica Neue", size: 15)
        addSubview(responseTextMessage)
        responseTextMessage.translatesAutoresizingMaskIntoConstraints = false
        responseTextMessage.addSubview(responseNameLabel)
        responseNameLabel.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            responseTextMessage.leadingAnchor.constraint(equalTo: responseLine.leadingAnchor, constant: 8),
            responseTextMessage.bottomAnchor.constraint(equalTo: responseLine.bottomAnchor, constant: -4),
            responseTextMessage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            responseNameLabel.leadingAnchor.constraint(equalTo: responseLine.leadingAnchor, constant: 8),
            responseNameLabel.topAnchor.constraint(equalTo: responseLine.topAnchor, constant: 2),
            responseNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: -
    
    private func setupRepMediaMessage(_ url: String) {
        let replyMediaLabel = UILabel()
        replyMediaLabel.text = "Media"
        replyMediaLabel.textColor = cell.isIncoming ? .lightGray : .lightText
        replyMediaLabel.font = UIFont(name: "Helvetica Neue", size: 15)
        addSubview(responseMediaMessage)
        responseMediaMessage.translatesAutoresizingMaskIntoConstraints = false
        responseMediaMessage.addSubview(responseNameLabel)
        responseNameLabel.translatesAutoresizingMaskIntoConstraints = false
        responseMediaMessage.addSubview(replyMediaLabel)
        replyMediaLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let url = URL(string: url)
        responseMediaMessage.kf.setImage(with: url)
        
        let constraints = [
            responseMediaMessage.topAnchor.constraint(equalTo: responseLine.topAnchor, constant: 2),
            responseMediaMessage.bottomAnchor.constraint(equalTo: responseLine.bottomAnchor, constant: -2),
            responseMediaMessage.widthAnchor.constraint(equalToConstant: 30),
            responseMediaMessage.leadingAnchor.constraint(equalTo: responseLine.trailingAnchor, constant: 4),
            replyMediaLabel.centerYAnchor.constraint(equalTo: responseMediaMessage.centerYAnchor, constant: 8),
            replyMediaLabel.leadingAnchor.constraint(equalTo: responseMediaMessage.trailingAnchor, constant: 4),
            responseNameLabel.leadingAnchor.constraint(equalTo: responseMediaMessage.trailingAnchor, constant: 4),
            responseNameLabel.centerYAnchor.constraint(equalTo: responseMediaMessage.centerYAnchor, constant: -8),
            responseNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
