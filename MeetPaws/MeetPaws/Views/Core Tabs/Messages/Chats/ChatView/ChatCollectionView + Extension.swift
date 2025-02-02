//
//  ChatCollectionView + Extension.swift
//  MeetPaws
//
//  Created by prince on 2020/12/20.
//

import UIKit
import AVFoundation

extension ChatViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        let message = messages[indexPath.row]
        if let msg = message.message {
            height = calculateFrameInText(message: msg).height + 10
            if message.repMID != nil { height += 50 }
        } else if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue {
            height = CGFloat(imageHeight / imageWidth * 200)
        } else if message.audioUrl != nil {
            height = 40
        }
        return CGSize(width: collectionView.frame.width, height: height)
    }
    
    // MARK: -
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    // MARK: -
    
    func calculateFrameInText(message: String) -> CGRect {
        return NSString(string: message).boundingRect(with: CGSize(width: 200, height: 9999999), options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 16)!], context: nil)
    }
    
    // MARK: -
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatCell", for: indexPath) as? ChatCell else { return UICollectionViewCell() }
        let message = messages[indexPath.row]
        cell.chatVC = self
        cell.message.text = message.message
        cell.msg = message
        return cell
    }
    
    // MARK: -
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let sView = scrollView as? UICollectionView else { return }
        if sView.contentOffset.y + sView.adjustedContentInset.top == 0 {
            if !chatNetworking.loadMore && !chatNetworking.lastMessageReached {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                fetchMessages()
            }
        }
    }
}
