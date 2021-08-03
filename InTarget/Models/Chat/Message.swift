//
//  Message.swift
//  Message
//
//  Created by Bruno Corrêa on 28/07/21.
//

import Foundation
import UIKit
import MessageKit
import Firebase
import FirebaseFirestore

struct Message: MessageType {

    var kind: MessageKind{
        return .text(content)
    }

    let id: String?
    var messageId: String {
      return id ?? UUID().uuidString
    }

    let content: String
    let sentDate: Date
    let sender: SenderType

    init(user: User, content: String) {
      //TODO
      sender = Sender(senderId: "xxxxx", displayName: "TESTE")
      self.content = content
      sentDate = Date()
      id = nil
    }

    init?(document: QueryDocumentSnapshot) {
      let data = document.data()
      guard
        let sentDate = data["created"] as? Timestamp,
        let senderId = data["senderId"] as? String,
        let senderName = data["senderName"] as? String,
        let content = data["content"] as? String
      else {
        return nil
      }

      id = document.documentID

      self.sentDate = sentDate.dateValue()
      self.content = content
      sender = Sender(senderId: senderId, displayName: senderName)

    }
}

// MARK: - Comparable
extension Message: Comparable {
  static func == (lhs: Message, rhs: Message) -> Bool {
    return lhs.id == rhs.id
  }

  static func < (lhs: Message, rhs: Message) -> Bool {
    return lhs.sentDate < rhs.sentDate
  }
}

