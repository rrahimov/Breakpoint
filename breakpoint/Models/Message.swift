//
//  Message.swift
//  breakpoint
//
//  Created by Ruhullah Rahimov on 09.06.21.
//

import Foundation

class Message {
    //data incapsulation
    private var _content: String
    private var _senderId: String
    
    var content: String {
        return _content
    }
    
    var senderId: String {
        return _senderId
    }
    
    init(content: String, senderId: String) {
        self._content = content
        self._senderId = senderId
    }
}
