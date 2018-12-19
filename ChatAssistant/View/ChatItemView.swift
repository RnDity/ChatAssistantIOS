//
//  ChatItemView.swift
//  ChatAssistant
//
//  Created and developed by RnDity sp. z o.o. in 2018.
//  Copyright © 2018 RnDity sp. z o.o. All rights reserved.
//

import Foundation
import UIKit
import TinyConstraints
import ViewAnimator

public enum ContentAppearAnimationStyle {
    case none
    case fadeIn
    case slideIn
    case growThenFadeIn
}

open class ChatItemView: UIView {
    
    public private(set) var contentContainer = UIView()
    var avatarImageView: UIImageView?
    
    private var viewModel: ChatItemViewModel
    public private(set) var configuration: ChatUIConfiguration
    private var internalContentView: UIView?
    private var typingAnimationView: TypingAnimationView?
    var contentContainerLeftFixedConstraint: Constraint!
    var contentContainerRightFixedConstraint: Constraint!
    
    open var contentContainerCornerRadius: CGFloat {
        return 20
    }

    open var internalContentViewInsets: UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    open var useSameCornerRadiusForInternalContentAndItsContainer: Bool {
        return false
    }
    
    var contentContainerColor: UIColor {
        return viewModel.chatItemConfiguration.isBotItem ? configuration.botMessageContainerColor : configuration.userMessageContainerColor
    }
    
    var leftPadding: CGFloat {
        var padding = configuration.horizontalPadding
        if let avatarSize = configuration.botAvatarSize, viewModel.chatItemConfiguration.isBotItem {
            padding += avatarSize.width + configuration.horizontalPadding
        }
        return padding
    }
    
    var defaultContentAppearAnimationStyle: ContentAppearAnimationStyle {
        return viewModel.chatItemConfiguration.contentAppearAnimationStyle
    }
    
    public var shrinkContentIfPossible: Bool = true {
        didSet {
            contentContainerLeftFixedConstraint.isActive = !shrinkContentIfPossible || viewModel.chatItemConfiguration.isBotItem
            contentContainerRightFixedConstraint.isActive = !shrinkContentIfPossible || !viewModel.chatItemConfiguration.isBotItem
        }
    }
    
    public init(viewModel: ChatItemViewModel, configuration: ChatUIConfiguration) {
        self.viewModel = viewModel
        self.configuration = configuration
        super.init(frame: .zero)
        viewModel.delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func createInternalContentView() -> UIView? {
        return nil
    }
    
    open func showChatItem(completion: @escaping () -> ()) {
        self.alpha = 0
        configureViewsHierarchy()

        configureInternalContent(completion: completion)
        
        setupLayout()
        configureViews()
        styleViews()
        
        fadeIn(view: self) { }
    }
    
    func updateContentContainerColor() {
        contentContainer.backgroundColor = contentContainerColor
    }
    
    private func configureViewsHierarchy() {
        add(
            contentContainer
        )
        
        if viewModel.chatItemConfiguration.displayBotAvatar {
            avatarImageView = UIImageView()
            add(avatarImageView!)
        }
    }
    
    fileprivate func configureInternalContent(completion: @escaping () -> ()) {
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        if viewModel.chatItemConfiguration.prependWithTypingAnimation {
            typingAnimationView = TypingAnimationView()
            
            // asynchronously to let the view setup layout before animation starts
            DispatchQueue.main.async { [weak self] in
                self?.typingAnimationView?.shouldContinueTypingAnimation = self?.viewModel.shouldContinueTypingAnimation
                self?.typingAnimationView?.startTypingAnimation {
                    self?.embedInternalContentView(animationStyle: .growThenFadeIn, completion: completion)
                }
            }
            contentContainer.add(typingAnimationView!)
        } else {
            embedInternalContentView(animationStyle: defaultContentAppearAnimationStyle, completion: completion)
        }
    }
    
    private func setupLayout() {
        let verticalPadding: CGFloat = 10
        
        contentContainer.edgesToSuperview(excluding: [.right, .left], insets: UIEdgeInsets(top: verticalPadding, left: 0, bottom: 0, right: 0))
        
        contentContainerLeftFixedConstraint = contentContainer.leftToSuperview(offset: leftPadding )
        contentContainer.leftToSuperview(offset: leftPadding, relation: .equalOrGreater)
        
        contentContainerRightFixedConstraint = contentContainer.rightToSuperview(offset: -configuration.horizontalPadding )
        contentContainer.rightToSuperview(offset: -configuration.horizontalPadding, relation: .equalOrLess)
        
        contentContainer.width(contentContainerCornerRadius * 2, relation: .equalOrGreater)
        
        shrinkContentIfPossible = true
        
        contentContainer.height(40, relation: .equalOrGreater)
        
        typingAnimationView?.leadingToSuperview(offset: 15)
        typingAnimationView?.trailingToSuperview(offset: 15)
        typingAnimationView?.centerYToSuperview()
        
        
        if let avatarSize = configuration.botAvatarSize, viewModel.chatItemConfiguration.displayBotAvatar {
            avatarImageView?.size(avatarSize)
            avatarImageView?.topToSuperview(offset: verticalPadding)
            avatarImageView?.leftToSuperview(offset: configuration.horizontalPadding)
        }
    }
    
    private func configureViews() {
        contentContainer.layer.cornerRadius = contentContainerCornerRadius

        applyDefaultShadow(to: contentContainer, shadowOpacity: 0.15)
        
        if let avatarImage = configuration.botAvatarImage, let avatarImageView = avatarImageView, viewModel.chatItemConfiguration.displayBotAvatar {
            applyDefaultShadow(to: avatarImageView, shadowOpacity: 0.25)
            avatarImageView.image = avatarImage
        }
    }
    
    func applyDefaultShadow(to view: UIView, shadowOpacity: Float) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = shadowOpacity
        view.layer.shadowRadius = 10
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
    }
    
    private func styleViews() {
        updateContentContainerColor()
    }
    
    open func embedInternalContentView(animationStyle: ContentAppearAnimationStyle, completion: @escaping () -> ()) {
        typingAnimationView?.removeFromSuperview()

        if let view = createInternalContentView() {
            internalContentView?.removeFromSuperview()

            internalContentView = view
            
            if useSameCornerRadiusForInternalContentAndItsContainer {
                internalContentView?.layer.cornerRadius = contentContainer.layer.cornerRadius
            }

            contentContainer.add(internalContentView!)
            internalContentView?.edgesToSuperview(insets: internalContentViewInsets)
            
            switch animationStyle {
            case .none:
                completion()
            case .fadeIn:
                fadeIn(view: contentContainer, completion: completion)
            case .growThenFadeIn:
                internalContentView?.alpha = 0
                animateLayoutChange { [weak self] in
                    self?.fadeIn(view: self?.internalContentView, completion: completion)
                }
            case .slideIn:
                slideInContent(completion: completion)
            }
        }
    }
    
    func fadeIn(view: UIView?, completion: @escaping () -> ()) {
        view?.alpha = 0
        UIView.animate(withDuration: 0.15, delay: 0, options: [], animations: {
            view?.alpha = 1
        }) { _ in
            completion()
        }
    }
    
    func animateLayoutChange(completion: @escaping () -> ()) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
            self.superview?.layoutIfNeeded()
        }) { _ in
            completion()
        }
    }
    
    func slideInContent(completion: @escaping () -> ()) {
        contentContainer.alpha = 0
        self.superview?.layoutIfNeeded()
        
        DispatchQueue.main.async {
            let leftAligned = self.viewModel.chatItemConfiguration.isBotItem
            
            let offset: CGFloat
                
            if leftAligned {
                offset = self.frame.width - self.contentContainer.frame.minX + self.contentContainer.frame.width
            } else {
                offset = self.frame.width - self.contentContainer.frame.maxX  + self.contentContainer.frame.width
            }

            let slideInAnimation = AnimationType.from(direction: leftAligned ? .left : .right, offset: offset)
            UIView.animate(views: [self.contentContainer], animations: [slideInAnimation], initialAlpha: 1, duration: 0.3, options: [.curveEaseOut]) {
                completion()
            }
        }
    }
}

extension ChatItemView: ChatItemViewModelDelegate {
    public func showItem(completion: @escaping () -> ()) {
        showChatItem(completion: completion)
    }
}
