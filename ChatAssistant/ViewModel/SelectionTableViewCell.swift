//
//  SelectionTableViewCell.swift
//  ChatAssistant
//
//  Created and developed by RnDity sp. z o.o. in 2018.
//  Copyright © 2018 RnDity sp. z o.o. All rights reserved.
//

import Foundation
import UIKit

class SelectionTableViewCell: UITableViewCell {
    
    public var topSeprator = UIView()
    public var titleLabel = UILabel()
    public var isEnabled = true {
        didSet {
            configureViews()
            styleViews()
        }
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createViewHierarchy()
        configureViews()
        styleViews()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createViewHierarchy()
        setupLayout()
        configureViews()
        styleViews()
    }

    func createViewHierarchy() {
        contentView.add(
            topSeprator,
            titleLabel
        )
    }
    
    func setupLayout() {
        topSeprator.edgesToSuperview(excluding: .bottom)
        topSeprator.height(1/UIScreen.main.scale)

        titleLabel.edgesToSuperview(insets: UIEdgeInsets.init(top: 15, left: 20, bottom: 15, right: 20))
    }
    
    func configureViews() {
        self.isUserInteractionEnabled = isEnabled
        titleLabel.numberOfLines = 0
        backgroundColor = UIColor.clear
        selectionStyle = .gray
    }
    
    func styleViews(){
        topSeprator.backgroundColor = UIColor.silver
        
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = isEnabled ? UIColor.royalBlue : UIColor.steel
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.layoutIfNeeded()
        titleLabel.preferredMaxLayoutWidth = titleLabel.frame.width
    }
}
