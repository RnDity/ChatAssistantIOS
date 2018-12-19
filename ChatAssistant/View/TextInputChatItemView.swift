//
//  TextInputChatItemView.swift
//  ChatAssistant
//
//  Created and developed by RnDity sp. z o.o. in 2018.
//  Copyright © 2018 RnDity sp. z o.o. All rights reserved.
//

import Foundation
import UIKit

class TextInputChatItemView: ChatItemView {
    
    private let noBreakSpace = "\u{00a0}"

    private var textField = UITextField()
    private var togglePasswordVisibilityButton = UIButton()
    private var messageLabel = UILabel()
    
    private var showItemCompletion: (() -> ())?
    
    private lazy var textInputFont: UIFont = {
        return UIFont.systemFont(ofSize: 17, weight: .regular) // TODO: from configuration
    }()
    
    private lazy var monoSpaceFont: UIFont? = {
        return UIFont(name: "Menlo", size: 17)
    }()
    
    private var viewModel: TextInputChatItemViewModel {
        didSet {
            bindData()
        }
    }
    
    override var internalContentViewInsets: UIEdgeInsets {
        return viewModel.isTextCommited ? UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15) : UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override var contentContainerColor: UIColor {
        return viewModel.isTextCommited ? super.contentContainerColor : UIColor.clear
    }
    
    init(viewModel: TextInputChatItemViewModel, configuration: ChatUIConfiguration) {
        self.viewModel = viewModel
        super.init(viewModel: viewModel, configuration: configuration)
        self.viewModel.textInputDelegate = self
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
        return viewModel.isTextCommited ? messageLabel : textField
    }
    
    private func configureViewsHierarchy() {
    }
    
    private func setupLayout() {
    }
    
    private func configureViews() {
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center

        // for now only right alginment supported
        textField.textAlignment = .right
        textField.delegate = self
        
        if viewModel.textInputChatItemConfiguration.passwordMode {
            textField.isSecureTextEntry = true
            
            let image = UIImage(named: "Password.Visiblity.On", in: Bundle(for: type(of: self)), compatibleWith: nil)
            togglePasswordVisibilityButton.setImage(image, for: .normal)
            togglePasswordVisibilityButton.addTarget(self, action: #selector(togglePasswordVisiblity), for: .touchUpInside)
            
            togglePasswordVisibilityButton.sizeToFit()
            textField.leftViewMode = .whileEditing
            textField.leftView = togglePasswordVisibilityButton
            
            if let placeholderText = viewModel.placeholderText {
                let fontAttributes = [NSAttributedString.Key.font: textInputFont]
                let size = (placeholderText as NSString).size(withAttributes: fontAttributes)
                textField.width(size.width + togglePasswordVisibilityButton.frame.width + 10, relation: .equalOrGreater)
            }
        }
        
        if viewModel.textInputChatItemConfiguration.numericKeyboard {
            textField.keyboardType = .numberPad
            textField.addDoneToolbar(onDone: (target: self, action: #selector(doneButtonTapped)))
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        let placeholderText = viewModel.placeholderText ?? ""
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor : UIColor.steel, NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.font : textInputFont])
        textField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        textField.becomeFirstResponder()
    }
    
    private func styleViews() {
        contentContainer.backgroundColor = UIColor.clear
        textField.tintColor = UIColor.clear
        textField.font = textInputFont
        messageLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        messageLabel.textColor = UIColor.white
    }
    
    private func bindData() {
        messageLabel.text = viewModel.textInputChatItemConfiguration.passwordMode ? viewModel.commitedText?.replaceWithDots() : viewModel.commitedText
    }
    
    override func showChatItem(completion: @escaping () -> ()) {
        showItemCompletion = completion
        super.showChatItem() { } // custom completion point

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {  // for some reason on startup cursor blinks on the left side for some reason, this is workaround for the problem
            self.textField.tintColor = self.configuration.userMessageContainerColor
        }
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        updateTextFieldFont()

        if #available(iOS 11, *){ } else {
            // On IOS 10 text entered by user doesn't cause UITextField to grow
            let text = textField.text
            textField.text = ""
            textField.text = text
        }
    }
    
    @objc private func togglePasswordVisiblity() {
        textField.isSecureTextEntry = !textField.isSecureTextEntry
        let image = UIImage(named: textField.isSecureTextEntry ? "Password.Visiblity.On" : "Password.Visiblity.Off", in: Bundle(for: type(of: self)), compatibleWith: nil)
        togglePasswordVisibilityButton.setImage(image, for: .normal)
        updateTextFieldFont()
    }
    
    private func updateTextFieldFont() {
        if viewModel.textInputChatItemConfiguration.passwordMode, !(textField.text?.isEmpty ?? true), textField.isSecureTextEntry {
            textField.font = monoSpaceFont
        } else {
            textField.font = textInputFont
        }
    }
    
    @objc func doneButtonTapped() {
        textField.resignFirstResponder()
        viewModel.handleTextCommited(text: textField.text?.replacingOccurrences(of: noBreakSpace, with: " "))
    }
}

extension TextInputChatItemView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === self.textField {
            textField.resignFirstResponder()
            viewModel.handleTextCommited(text: textField.text?.replacingOccurrences(of: noBreakSpace, with: " "))
            return false
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        // fix for issue: https://stackoverflow.com/questions/19569688/right-aligned-uitextfield-spacebar-does-not-advance-cursor-in-ios-7/50989179#50989179
        if var text = textField.text, range.location == text.count, string == " " {
            text.append(noBreakSpace)
            textField.text = text
            return false
        }
        
        if let text = textField.text, let maxCharacters = viewModel.textInputChatItemConfiguration.maxCharacters {
            let newText = (text as NSString).replacingCharacters(in: range, with: string)
            return newText.count <= maxCharacters
        }
        return true
    }
}

extension TextInputChatItemView: TextInputChatItemViewModelDelegate {
    func onTextCommited() {
        updateContentContainerColor()
        shrinkContentIfPossible = true
        contentContainer.layer.shadowOpacity = 0.25 // to make the shadow more visible in constrast with darker color, should be configurable as user item color is configurable
        messageLabel.text = viewModel.textInputChatItemConfiguration.passwordMode ? viewModel.commitedText?.replaceWithDots() : viewModel.commitedText

        embedInternalContentView(animationStyle: .fadeIn) {}
        
        contentContainer.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            self.contentContainer.alpha = 1
        }) { [weak self] _ in
            self?.showItemCompletion?()
        }
    }
}

extension String {
    public func replaceWithDots() -> String {
        return String(repeating: "•", count: self.count)
    }
}

extension UITextField {
    func addDoneToolbar(onDone: (target: Any, action: Selector)? = nil) {
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: NSLocalizedString("Done", bundle: Bundle(for: TextInputChatItemView.self), comment: ""), style: .plain, target: onDone.target, action: onDone.action)
        ]
        toolbar.tintColor = UIColor.royalBlue
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    // Default actions:
    @objc func doneButtonTapped() { self.resignFirstResponder() }
}
