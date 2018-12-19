//
//  MessageChatItemViewModel.swift
//  ChatAssistant
//
//  Created and developed by RnDity sp. z o.o. in 2018.
//  Copyright © 2018 RnDity sp. z o.o. All rights reserved.
//

import Foundation

public class MessageChatItemConfiguration: DefaultChatItemConfiguration {
    public var message: String
    
    public init(message: String, displayBotAvatar: Bool = false, prependWithTypingAnimation: Bool = false, alignLeft: Bool = true, contentAppearAnimationStyle: ContentAppearAnimationStyle = .fadeIn) {
        self.message = message
        super.init(displayBotAvatar: displayBotAvatar, prependWithTypingAnimation: prependWithTypingAnimation, alignLeft: alignLeft, contentAppearAnimationStyle: contentAppearAnimationStyle)
    }
}

public class MessageChatItemViewModel: ChatItemViewModel {
    
    public private(set) var messageChatItemConfiguration: MessageChatItemConfiguration
    
    public init(id: String, messageChatItemConfiguration: MessageChatItemConfiguration) {
        self.messageChatItemConfiguration = messageChatItemConfiguration
        super.init(id: id, chatItemConfiguration: messageChatItemConfiguration)
    }
}
