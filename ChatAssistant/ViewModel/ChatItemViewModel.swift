//
//  ChatItem.swift
//  ChatAssistant
//
//  Created and developed by RnDity sp. z o.o. in 2018.
//  Copyright © 2018 RnDity sp. z o.o. All rights reserved.
//

import Foundation

public protocol ChatItemViewModelDelegate: class {
    func showItem(completion: @escaping () -> ())
}

open class ChatItemViewModel {
    private(set) var id: String
    let chatItemConfiguration: ChatItemConfiguration

    public weak var delegate: ChatItemViewModelDelegate?
    
    public var shouldContinueTypingAnimation: (()->(Bool))?
    
    public init(id: String, chatItemConfiguration: ChatItemConfiguration) {
        self.id = id
        self.chatItemConfiguration = chatItemConfiguration
    }
    
    public func showItem(completion: @escaping () -> ()) {
        delegate?.showItem {
            completion()
        }
    }
}
