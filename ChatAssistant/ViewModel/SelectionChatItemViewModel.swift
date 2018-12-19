//
//  SelectionChatItemViewModel.swift
//  ChatAssistant
//
//  Created and developed by RnDity sp. z o.o. in 2018.
//  Copyright © 2018 RnDity sp. z o.o. All rights reserved.
//

import Foundation

public typealias SelectionChatItemConfigurationOption = (title: String, enabled: Bool)
public class SelectionChatItemConfiguration: DefaultChatItemConfiguration {
    public private(set) var description: String
    public private(set) var options: [SelectionChatItemConfigurationOption]
    public private(set) var allowMultipleSelection: Bool

    public init(description: String, options: [String], allowMultipleSelection: Bool = false, displayBotAvatar: Bool = false, prependWithTypingAnimation: Bool = false, alignLeft: Bool = true, contentAppearAnimationStyle: ContentAppearAnimationStyle = .fadeIn) {
        self.description = description
        self.options = options.map { SelectionChatItemConfigurationOption(title: $0, enabled: true) }
        self.allowMultipleSelection = allowMultipleSelection
        super.init(displayBotAvatar: displayBotAvatar, prependWithTypingAnimation: prependWithTypingAnimation, alignLeft: alignLeft, contentAppearAnimationStyle: contentAppearAnimationStyle)
    }
    public init(description: String, options: [SelectionChatItemConfigurationOption], allowMultipleSelection: Bool = false, displayBotAvatar: Bool = false, prependWithTypingAnimation: Bool = false, alignLeft: Bool = true, contentAppearAnimationStyle: ContentAppearAnimationStyle = .fadeIn) {
        self.description = description
        self.options = options
        self.allowMultipleSelection = allowMultipleSelection
        super.init(displayBotAvatar: displayBotAvatar, prependWithTypingAnimation: prependWithTypingAnimation, alignLeft: alignLeft, contentAppearAnimationStyle: contentAppearAnimationStyle)
    }
}

public class SelectionChatItemViewModel: ChatItemViewModel {
    
    public private(set) var selectionChatItemConfiguration: SelectionChatItemConfiguration
    
    public private(set) var selectedOptionIndex: Int?
    
    public var optionsCount: Int {
        return selectionChatItemConfiguration.options.count
    }
    
    init(id: String, selectionChatItemConfiguration: SelectionChatItemConfiguration) {
        self.selectionChatItemConfiguration = selectionChatItemConfiguration
        super.init(id: id, chatItemConfiguration: selectionChatItemConfiguration)
    }
    
    public func title(forIndex index: Int) -> String {
        return selectionChatItemConfiguration.options[index].title
    }
    
    public func itemEnabled(at index: Int) -> Bool {
        return selectionChatItemConfiguration.options[index].enabled
    }
    
    public func selectOption(atIndex index: Int) {
        selectedOptionIndex = index
    }
}
