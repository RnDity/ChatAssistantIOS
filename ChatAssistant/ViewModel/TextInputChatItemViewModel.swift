//
//  TextInputChatItemViewModel.swift
//  ChatAssistant
//
//  Created and developed by RnDity sp. z o.o. in 2018.
//  Copyright © 2018 RnDity sp. z o.o. All rights reserved.
//

import Foundation

public class TextInputChatItemConfiguration: DefaultChatItemConfiguration {
    var inputPlaceholder: String?
    var passwordMode: Bool
    var numericKeyboard: Bool
    var maxCharacters: Int?
    public init(inputPlaceholder: String? = nil, passwordMode: Bool = false, displayBotAvatar: Bool = false, prependWithTypingAnimation: Bool = false, alignLeft: Bool = false, contentAppearAnimationStyle: ContentAppearAnimationStyle = .fadeIn, numericKeyboard: Bool = false, maxCharacters: Int? = nil) {
        self.inputPlaceholder = inputPlaceholder
        self.passwordMode = passwordMode
        self.numericKeyboard = numericKeyboard
        self.maxCharacters = maxCharacters
        super.init(displayBotAvatar: displayBotAvatar, prependWithTypingAnimation: prependWithTypingAnimation, alignLeft: alignLeft, contentAppearAnimationStyle: contentAppearAnimationStyle)
    }
}

public protocol TextInputChatItemViewModelDelegate: class {
    func onTextCommited()
}

public class TextInputChatItemViewModel: ChatItemViewModel {
    
    public private(set) var textInputChatItemConfiguration: TextInputChatItemConfiguration
    
    public weak var textInputDelegate: TextInputChatItemViewModelDelegate?
    
    public var commitedText: String?
    
    public var isTextCommited: Bool {
        return commitedText != nil
    }
    
    public var placeholderText: String? {
        return textInputChatItemConfiguration.inputPlaceholder
    }
    
    init(id: String, textInputChatItemConfiguration: TextInputChatItemConfiguration) {
        self.textInputChatItemConfiguration = textInputChatItemConfiguration
        super.init(id: id, chatItemConfiguration: textInputChatItemConfiguration)
    }
    
    func handleTextCommited(text: String?) {
        commitedText = text
        textInputDelegate?.onTextCommited()
    }
}
