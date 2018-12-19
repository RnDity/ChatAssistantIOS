//
//  MessageChatItemView.swift
//  ChatAssistant
//
//  Created and developed by RnDity sp. z o.o. in 2018.
//  Copyright © 2018 RnDity sp. z o.o. All rights reserved.
//

import Foundation
import UIKit

class MessageChatItemView: ChatItemView {
    
    private var messageLabel = UILabel()
    
    private var viewModel: MessageChatItemViewModel {
        didSet {
            bindData()
        }
    }
    
    override var internalContentViewInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    }
    
    init(viewModel: MessageChatItemViewModel, configuration: ChatUIConfiguration) {
        self.viewModel = viewModel
        super.init(viewModel: viewModel, configuration: configuration)
        configureViewsHierarchy()
        setupLayout()
        configureViews()
        styleViews()
        bindData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createInternalContentView() -> UIView? {
        bindData() // to reload text in case message in cofiguration was updated after creation
        return messageLabel
    }
    
    private func configureViewsHierarchy() {
    }
    
    private func setupLayout() {
    }
    
    private func configureViews() {
        messageLabel.numberOfLines = 0
    }
    
    private func styleViews() {
        messageLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        messageLabel.textColor = viewModel.messageChatItemConfiguration.isBotItem ? UIColor.brownishGrey : UIColor.white
    }
    
    private func bindData() {
        messageLabel.text = viewModel.messageChatItemConfiguration.message
    }
}
