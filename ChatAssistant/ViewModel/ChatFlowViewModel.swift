//
//  ChatFlowViewModel.swift
//  ChatAssistant
//
//  Created and developed by RnDity sp. z o.o. in 2018.
//  Copyright © 2018 RnDity sp. z o.o. All rights reserved.
//

import Foundation

open class ChatFlowViewModel {
    public private(set) var chatViewModel = ChatViewModel()
    open var startChatFlowAutomatically = true
    
    public init() { }
    
    open func startChatFlow() { }
    
    public func onViewLoaded() {
        if startChatFlowAutomatically {
            startChatFlow()
        }
    }
}
