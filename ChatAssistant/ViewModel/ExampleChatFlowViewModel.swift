//
//  ExampleChatFlowViewModel.swift
//  ChatAssistant
//
//  Created and developed by RnDity sp. z o.o. in 2018.
//  Copyright © 2018 RnDity sp. z o.o. All rights reserved.
//

import Foundation

public class ExampleChatFlowViewModel: ChatFlowViewModel {
    
    private var userName: String?
    private var email: String?
    
    public override func startChatFlow() {
        showWelcomeMessage()
    }
    
    private func showWelcomeMessage() {
        let messageItemConfiguration = MessageChatItemConfiguration(message: "Cześć jestem Twoim Asystentem.", displayBotAvatar: true, prependWithTypingAnimation: true)
        chatViewModel.showMessageItem(configuration: messageItemConfiguration) { [weak self] in
            self?.showWelcomeMessage2()
        }
    }
    
    private func showWelcomeMessage2() {
        let messageItemConfiguration = MessageChatItemConfiguration(message: "Aby lepiej nam się współpracowało podaj prosze swój nick.", prependWithTypingAnimation: true)
        chatViewModel.showMessageItem(configuration: messageItemConfiguration, withDelay: 0) { [weak self] in
            self?.showUserNameInputMessage()
        }
    }
    
    private func showUserNameInputMessage() {
        let textInputItemConfiguration = TextInputChatItemConfiguration(inputPlaceholder: "Wpisz nick", numericKeyboard: true)
        chatViewModel.showTextInputItem(configuration: textInputItemConfiguration, withDelay: 0) { [weak self] userName in
            if self?.validate(userName: userName) ?? false {
                self?.userName = userName
            } else {
                self?.showUserNameBusyMessage()
            }
        }
    }
    
    private func showUserNameBusyMessage() {
        let messageItemConfiguration = MessageChatItemConfiguration(message: "Hmm", displayBotAvatar: true, prependWithTypingAnimation: true)
        chatViewModel.showMessageItem(configuration: messageItemConfiguration, withDelay: 0.5) { [weak self] in
            self?.showUserNameBusyMessage2()
        }
    }
    
    private func showUserNameBusyMessage2() {
        let messageItemConfiguration = MessageChatItemConfiguration(message: "Niestety ten Nick jest zajęty, proszę wpisz inny:", prependWithTypingAnimation: true)
        chatViewModel.showMessageItem(configuration: messageItemConfiguration, withDelay: 0) { [weak self] in
            self?.chatViewModel.clearChatLeavingLast(numberOfItems: 3) {
                self?.showUserNameInputMessage()
            }
        }
    }
    
    private func validate(userName: String?) -> Bool {
        return (userName?.count ?? 0) > 5 // Dummy check to test both validation result
    }
}
