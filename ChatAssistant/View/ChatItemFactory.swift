//
//  ChatItemFactory.swift
//  ChatAssistant
//
//  Created and developed by RnDity sp. z o.o. in 2018.
//  Copyright © 2018 RnDity sp. z o.o. All rights reserved.
//

import Foundation

public protocol ChatItemFactory {
    func createChatItemView(viewModel: ChatItemViewModel, configuration: ChatUIConfiguration) -> ChatItemView?
}
