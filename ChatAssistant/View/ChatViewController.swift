//
//  ChatExampleViewController.swift
//  ChatAssistant
//
//  Created and developed by RnDity sp. z o.o. in 2018.
//  Copyright © 2018 RnDity sp. z o.o. All rights reserved.
//

import Foundation
import UIKit
import TinyConstraints
import EasyAnimation

public struct ChatUIConfiguration {
    public var mainTopPadding: CGFloat
    public var horizontalPadding: CGFloat
    public var verticalPadding: CGFloat
    public var botAvatarSize: CGSize?
    public var botAvatarImage: UIImage?
    public var botMessageContainerColor: UIColor
    public var userMessageContainerColor: UIColor
    
    public init(mainTopPadding: CGFloat, horizontalPadding: CGFloat, verticalPadding: CGFloat, botAvatarSize: CGSize?, botAvatarImage: UIImage?, botMessageContainerColor: UIColor, userMessageContainerColor: UIColor) {
        self.mainTopPadding = mainTopPadding
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.botAvatarSize = botAvatarSize
        self.botAvatarImage = botAvatarImage
        self.botMessageContainerColor = botMessageContainerColor
        self.userMessageContainerColor = userMessageContainerColor
    }
}

open class ChatViewController: UIViewController {
    private var chatFlowViewModel: ChatFlowViewModel!
    private var viewModel: ChatViewModel {
        return chatFlowViewModel.chatViewModel
    }
    private var configuration: ChatUIConfiguration!
    
    private var chatPageContainer = UIView()
    private var snapshotImageView = UIImageView()
    private var externalOptionsContainer = UIView()
    private var externalOptionsStackView = UIStackView()
    
    private var snapshotImageViewTopConstraint: Constraint!
    public var externalOptionsBottomConstraint: Constraint!
    
    public var customChatItemFactory: ChatItemFactory?
    
    public convenience init(chatFlowViewModel: ChatFlowViewModel, configuration: ChatUIConfiguration) {
        self.init(nibName: nil, bundle: nil)
        self.chatFlowViewModel = chatFlowViewModel
        self.viewModel.delegate = self
        self.configuration = configuration
    }
    
    open override func viewDidLoad() {
        crateViewsChierarchy()
        setupLayout()
        configureViews()
        styleViews()
        
        chatFlowViewModel.onViewLoaded()
    }
    
    private func crateViewsChierarchy() {
        view.add(
            chatPageContainer,
            snapshotImageView,
            externalOptionsContainer.add(
                externalOptionsStackView
            )
        )
    }
    
    private func setupLayout() {
        if #available(iOS 11, *){
            chatPageContainer.topToSuperview(offset: configuration.mainTopPadding, usingSafeArea: true)
        } else {
            // possible using TinyConstraints ???
            NSLayoutConstraint(item: chatPageContainer,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: topLayoutGuide,
                               attribute: .bottom,
                               multiplier: 1,
                               constant: configuration.mainTopPadding).isActive = true
        }
        
        chatPageContainer.leadingToSuperview()
        chatPageContainer.trailingToSuperview()
        chatPageContainer.bottomToSuperview()
        
        snapshotImageViewTopConstraint = snapshotImageView.top(to: chatPageContainer)
        snapshotImageView.leading(to: chatPageContainer)
        snapshotImageView.trailing(to: chatPageContainer)
        snapshotImageView.height(to: chatPageContainer)
        
        externalOptionsContainer.leadingToSuperview()
        externalOptionsContainer.trailingToSuperview()
        externalOptionsContainer.topToBottom(of: self.view, priority: UILayoutPriority(rawValue: 749))
        externalOptionsBottomConstraint = externalOptionsContainer.bottomToSuperview()
        
        externalOptionsStackView.edgesToSuperview(insets: UIEdgeInsets(top: configuration.verticalPadding, left: configuration.horizontalPadding, bottom: configuration.verticalPadding, right: configuration.horizontalPadding))
    }
    
    private func configureViews() {
        externalOptionsStackView.axis = .vertical
        externalOptionsStackView.spacing = configuration.horizontalPadding
    }
    
    private func styleViews() {
        self.view.backgroundColor = UIColor.paleGrey
        chatPageContainer.backgroundColor = UIColor.paleGrey
        snapshotImageView.backgroundColor = UIColor.clear
    }
    
    fileprivate func add(chatItemView: ChatItemView) {
        let lastView = chatPageContainer.subviews.last
        
        chatPageContainer.addSubview(chatItemView)
        
        if let lastView = lastView {
            chatItemView.topToBottom(of: lastView)
        } else {
            chatItemView.topToSuperview()
        }
        chatItemView.leadingToSuperview()
        chatItemView.trailingToSuperview()
    }
    
    fileprivate func resetSnapshotImageView() {
        snapshotImageView.image = nil
        snapshotImageView.alpha = 1
        snapshotImageViewTopConstraint.constant = 0
    }
    
    private func configureExternalOptionSelectionButton(button: UIButton) {
        let buttonHeight: CGFloat = 45
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        button.setTitleColor(UIColor.royalBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.royalBlue.cgColor
        button.layer.cornerRadius = buttonHeight / 2
        button.height(buttonHeight, relation: .equalOrGreater )
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.baselineAdjustment = .alignCenters
    }
    
    fileprivate func showExternalOptionsSelectionBar(show: Bool, completion: @escaping ()->() ) {
        externalOptionsBottomConstraint.isActive = show
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }) { _ in
            completion()
        }
    }
}


extension ChatViewController: ChatViewModelDelegate {

    public func onMessageChatItemAdded(viewModel: MessageChatItemViewModel) {
        add(chatItemView: MessageChatItemView(viewModel: viewModel, configuration: configuration))
    }
    
    public func onTextInputChatItemAdded(viewModel: TextInputChatItemViewModel) {
        add(chatItemView: TextInputChatItemView(viewModel: viewModel, configuration: configuration))
    }
    
    public func onSelectionChatItemAdded(viewModel: SelectionChatItemViewModel) {
        add(chatItemView: SelectionChatItemView(viewModel: viewModel, configuration: configuration))
    }
    
    public func onCustomChatItemAdded(viewModel: ChatItemViewModel) {
        guard let chatItemView = customChatItemFactory?.createChatItemView(viewModel: viewModel, configuration: configuration) else {
            return
        }
        add(chatItemView: chatItemView)
    }
    
    public func clearChatItems(tillItemAtIndex index: Int?, completion: @escaping ()->()) {
        let snapshot = chatPageContainer.takeSnapshot()
        snapshotImageView.image = snapshot
        
        var firstChatItemViewToStay: UIView? = nil
        
        if let index = index, index < chatPageContainer.subviews.count {
            firstChatItemViewToStay = chatPageContainer.subviews[index]
        }
        
        let offsetToSlide = firstChatItemViewToStay?.frame.minY ?? chatPageContainer.subviews.last?.frame.maxY ?? 0
        
        for (subviewIndex, subview) in chatPageContainer.subviews.enumerated() {
            if (index != nil && subviewIndex < index!) || index == nil {
                subview.removeFromSuperview()
            }
        }
        
        firstChatItemViewToStay?.topToSuperview()
        view.layoutIfNeeded()

        snapshotImageViewTopConstraint.constant = -offsetToSlide

        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.view.layoutIfNeeded()
        }) { [weak self] _ in
            completion()
            UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
                self?.snapshotImageView.alpha = 0
            }) { _ in
                self?.resetSnapshotImageView()
            }
        }
    }
    
    public func onShowExternalOptionsSelection(viewModel: ExternalOptionsSelectionViewModel, completion: @escaping (IndexPath)->()) {
        externalOptionsBottomConstraint.isActive = false
        externalOptionsStackView.arrangedSubviews.forEach{ $0.removeFromSuperview() }
        
        viewModel.options.enumerated().forEach{ [weak self] sectionIndex, section in
            let sectionStackView = UIStackView()
            
            sectionStackView.axis = .horizontal
            sectionStackView.distribution = .fillEqually
            sectionStackView.spacing = configuration.horizontalPadding
            
            section.enumerated().forEach{
                let button = TappableButton(frame: .zero)
                button.setTitle($0.element, for: .normal)
                self?.configureExternalOptionSelectionButton(button: button)
                sectionStackView.addArrangedSubview(button)
                let index = $0.offset
                button.onTapped = {
                    if viewModel.allowDismissOption(atIndex: index) {
                        self?.showExternalOptionsSelectionBar(show: false) {
                            completion(IndexPath(row: index, section: sectionIndex))
                        }
                    }
                }
            }
            externalOptionsStackView.addArrangedSubview(sectionStackView)
        }
        
        self.view.layoutIfNeeded()
        
        DispatchQueue.main.async { [weak self] in
            self?.showExternalOptionsSelectionBar(show: true) { }
        }
    }
    public func hideExternalOptionsBar() {
        showExternalOptionsSelectionBar(show: false) { }
    }
    
    public func onChangeBotAvatarImage(image: UIImage) {
        configuration.botAvatarImage = image
    }
}
