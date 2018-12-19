//
//  TypingAnimationView.swift
//  ChatAssistant
//
//  Created and developed by RnDity sp. z o.o. in 2018.
//  Copyright © 2018 RnDity sp. z o.o. All rights reserved.
//

import Foundation
import UIKit
import EasyAnimation

class TypingAnimationView: UIButton {
    
    private let dotSize: CGFloat = 6
    private let dotsNumber = 3
    
    private let dotAnimationDuration = 0.3
    private let typingAnimationDelay = 0.3
    
    private var stackView = UIStackView()
    
    public var shouldContinueTypingAnimation: (()->(Bool))?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    public func startTypingAnimation(completion: @escaping () -> ()) {

        for (index, dotView) in stackView.arrangedSubviews.enumerated() {

            let animationDelay = typingAnimationDelay + Double(index) * dotAnimationDuration/2.5
            let dotMovementDistance: CGFloat = 8
            
            UIView.animateAndChain(withDuration: dotAnimationDuration/2, delay: animationDelay, options: [.curveEaseIn], animations: {
                dotView.center.y -= dotMovementDistance
            }, completion: nil).animate(withDuration: dotAnimationDuration/2, delay: 0, options: [.curveEaseIn], animations: {
                dotView.center.y += dotMovementDistance
            }) { [weak self, dotsNumber, typingAnimationDelay] _ in
                if index == dotsNumber - 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Int(typingAnimationDelay * 1000))) {
                        if self?.shouldContinueTypingAnimation?() ?? false {
                            self?.startTypingAnimation(completion: completion)
                        } else {
                            completion()
                        }
                    }
                }
            }
        }
    }
    
    private func sharedInit() {
        createViewsChierarchy()
        setupLayout()
        configureViews()
    }
    
    private func createViewsChierarchy() {
        add(stackView)
        
        for _ in 1...dotsNumber {
            stackView.addArrangedSubview(createDotView())
        }
    }
    
    private func setupLayout() {
        stackView.edgesToSuperview(insets: UIEdgeInsets(top: dotSize, left: 0, bottom: 0, right: 0))
    }
    
    private func configureViews() {
        stackView.axis = .horizontal
        stackView.spacing = dotSize
    }
    
    private func createDotView() -> UIView {
        let dotView = UIView()
        dotView.backgroundColor = UIColor.royalBlue
        dotView.layer.cornerRadius = dotSize/2
        dotView.size(CGSize(width: dotSize, height: dotSize))
        return dotView
    }
}
