//
//  ChatViewModel.swift
//  ChatAssistant
//
//  Created and developed by RnDity sp. z o.o. in 2018.
//  Copyright © 2018 RnDity sp. z o.o. All rights reserved.
//

import Foundation
import UIKit

public protocol ChatViewModelDelegate: class {
    func onMessageChatItemAdded(viewModel: MessageChatItemViewModel)
    func onTextInputChatItemAdded(viewModel: TextInputChatItemViewModel)
    func onSelectionChatItemAdded(viewModel: SelectionChatItemViewModel)
    func onCustomChatItemAdded(viewModel: ChatItemViewModel)
    
    func onShowExternalOptionsSelection(viewModel: ExternalOptionsSelectionViewModel, completion: @escaping (IndexPath)->())
    func hideExternalOptionsBar()
    
    func clearChatItems(tillItemAtIndex index: Int?, completion: @escaping ()->())
    
    func onChangeBotAvatarImage(image: UIImage)
}

public protocol ChatItemConfiguration {
    var displayBotAvatar: Bool { get }
    var prependWithTypingAnimation: Bool { get }
    var isBotItem: Bool { get }
    var contentAppearAnimationStyle: ContentAppearAnimationStyle { get}
}

open class DefaultChatItemConfiguration: ChatItemConfiguration {
    public var displayBotAvatar: Bool
    public var prependWithTypingAnimation: Bool
    public var isBotItem: Bool
    public var contentAppearAnimationStyle: ContentAppearAnimationStyle
    
    public init(displayBotAvatar: Bool, prependWithTypingAnimation: Bool, alignLeft: Bool, contentAppearAnimationStyle: ContentAppearAnimationStyle) {
        self.displayBotAvatar = displayBotAvatar
        self.prependWithTypingAnimation = prependWithTypingAnimation
        self.isBotItem = alignLeft
        self.contentAppearAnimationStyle = contentAppearAnimationStyle
    }
}

public class ChatViewModel {
    
    public weak var delegate: ChatViewModelDelegate?
    
    public private(set) var currentChatItemsViewModels = [ChatItemViewModel]()
    
    init() {
        
    }
    
    public func changeBotImage(image: UIImage) {
        delegate?.onChangeBotAvatarImage(image: image)
    }
    
    @discardableResult
    public func showMessageItem(configuration: MessageChatItemConfiguration, withDelay delay: TimeInterval = 0, shouldContinueTypingAnimation: (()->(Bool))? = nil, completion: (() -> ())? = nil) -> ChatItemViewModel {
        let viewModel = MessageChatItemViewModel(id: "1", messageChatItemConfiguration: configuration)
        viewModel.shouldContinueTypingAnimation = shouldContinueTypingAnimation
        delegate?.onMessageChatItemAdded(viewModel: viewModel)
        showChatItem(viewModel: viewModel, withDelay: delay, completion: completion)
        return viewModel
    }
    
    @discardableResult
    public func showTextInputItem(configuration: TextInputChatItemConfiguration, withDelay delay: TimeInterval = 0, completion: ((String?) -> ())? = nil) -> ChatItemViewModel{
        let textInputViewModel = TextInputChatItemViewModel(id: "1", textInputChatItemConfiguration: configuration)
        delegate?.onTextInputChatItemAdded(viewModel: textInputViewModel)
        showChatItem(viewModel: textInputViewModel, withDelay: delay) {
            completion?(textInputViewModel.commitedText)
        }
        return textInputViewModel
    }
    
    @discardableResult
    public func showSelectionItem(configuration: SelectionChatItemConfiguration, withDelay delay: TimeInterval = 0, completion: ((Int?) -> ())? = nil) -> ChatItemViewModel {
        let viewModel = SelectionChatItemViewModel(id: "1", selectionChatItemConfiguration: configuration)
        delegate?.onSelectionChatItemAdded(viewModel: viewModel)
        showChatItem(viewModel: viewModel, withDelay: delay) { 
            completion?(viewModel.selectedOptionIndex)
        }
        return viewModel
    }
    
    @discardableResult
    public func showCustomItem(viewModel: ChatItemViewModel, withDelay delay: TimeInterval = 0, completion: (() -> ())? = nil) -> ChatItemViewModel {
        delegate?.onCustomChatItemAdded(viewModel: viewModel)
        showChatItem(viewModel: viewModel, withDelay: delay) {
            completion?()
        }
        return viewModel
    }
    
    @discardableResult
    public func showExternalOptionsSelection(configuration: ExternalOptionsSelectionConfiguration, withDelay delay: TimeInterval = 0, shouldDismiss: ((Int) -> Bool)? = nil, completion: ((IndexPath?) -> ())? = nil) -> ExternalOptionsSelectionViewModel {
        let viewModel = ExternalOptionsSelectionViewModel(id: "1", configuration: configuration)
        viewModel.shouldDismiss = shouldDismiss
        delegate?.onShowExternalOptionsSelection(viewModel: viewModel) {
            completion?($0)
        }

        return viewModel
    }
    
    public func hideExternalOptionsBar() {
        delegate?.hideExternalOptionsBar()
    }
    
    public func clearChat(tillItem: ChatItemViewModel? = nil, withDelay delay: TimeInterval = 0, completion: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Int(delay * 1000))) {
            let index = self.currentChatItemsViewModels.index(where: { $0 === tillItem})
            if let index = index {
                self.currentChatItemsViewModels = Array(self.currentChatItemsViewModels[index..<self.currentChatItemsViewModels.count])
            } else {
                self.currentChatItemsViewModels = []
            }
            
            self.delegate?.clearChatItems(tillItemAtIndex: index, completion: completion)
        }
    }
    
    public func clearChatLeavingLast(numberOfItems: Int, withDelay delay: TimeInterval = 0, completion: @escaping ()->()) {
        if currentChatItemsViewModels.count >= numberOfItems {
            clearChat(tillItem: currentChatItemsViewModels[currentChatItemsViewModels.count - numberOfItems], withDelay: delay, completion: completion)
        } else {
            clearChat(tillItem: nil, withDelay: delay, completion: completion)
        }
    }
    
    public func showChatItem(viewModel: ChatItemViewModel, withDelay delay: TimeInterval = 0, completion: (() -> ())? = nil) {
        self.currentChatItemsViewModels.append(viewModel)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Int(delay * 1000))) {
            viewModel.showItem {
                completion?()
            }
        }
    }
}
