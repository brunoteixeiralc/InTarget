//
//  ChatViewController.swift
//  ChatViewController
//
//  Created by Bruno Corrêa on 28/07/21.
//

import UIKit
import MessageKit
import Firebase

class ChatViewController: MessagesViewController {

    private var messages: [Message] = []
    private var messageListener: ListenerRegistration?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ChatViewController: MessagesDataSource{
    func currentSender() -> SenderType {
        return Sender(senderId: "xxxxx", displayName: "TESTE")
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }

    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(
          string: name,
          attributes: [
            .font: UIFont.preferredFont(forTextStyle: .caption1),
            .foregroundColor: UIColor(white: 0.3, alpha: 1)
          ])
      }
}
