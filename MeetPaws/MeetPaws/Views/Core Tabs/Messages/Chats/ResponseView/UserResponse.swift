//
//  UserResponse.swift
//  MeetPaws
//
//  Created by prince on 2020/12/20.
//

import UIKit

class UserResponse {
    
    var responseStatus = false
    
    var repliedMessage: Messages?
    
    var messageToForward: Messages?
    
    var messageSender: String?
    
    let lineView = UIView()
    
    let nameLabel = UILabel()
    
    var nameLabelConstraint: NSLayoutConstraint!
    
    let messageLabel = UILabel()
    
    let mediaMessage = UIImageView()
    
    let audioMessage = UILabel()
    
    let exitButton = UIButton(type: .system)
}
