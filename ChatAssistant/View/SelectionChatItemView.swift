//
//  SelectionChatItemView.swift
//  ChatAssistant
//
//  Created and developed by RnDity sp. z o.o. in 2018.
//  Copyright © 2018 RnDity sp. z o.o. All rights reserved.
//

import Foundation
import UIKit
import ViewAnimator

class SelectionChatItemView: ChatItemView {
    
    private let selectionTableViewCellIdentifier = "\(SelectionTableViewCell.self)"

    private var internalContentContainer = UIView()
    private var descriptionLabel = UILabel()
    private var optionsTableView = UITableView()
    
    private var showItemCompletion: (() -> ())?
    
    private lazy var prototypeOptionCell: SelectionTableViewCell = {
        return SelectionTableViewCell(frame: .zero)
    }()
    
    private var viewModel: SelectionChatItemViewModel {
        didSet {
            bindData()
        }
    }
    
    override var internalContentViewInsets: UIEdgeInsets {
        return .zero
    }
    
    init(viewModel: SelectionChatItemViewModel, configuration: ChatUIConfiguration) {
        self.viewModel = viewModel
        super.init(viewModel: viewModel, configuration: configuration)
        configureViews()
        styleViews()
        bindData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createInternalContentView() -> UIView? {
        configureInternalContentViewsHierarchy()
        setupInternalContentLayout()

        return internalContentContainer
    }
    
    private func configureInternalContentViewsHierarchy() {
        internalContentContainer.add(
            descriptionLabel,
            optionsTableView
        )
    }
    
    private func setupInternalContentLayout() {
        descriptionLabel.edgesToSuperview(excluding: .bottom, insets: UIEdgeInsets.init(top: 15, left: 20, bottom: 15, right: 20))
        
        optionsTableView.topToBottom(of: descriptionLabel, offset: 15)
        optionsTableView.edgesToSuperview(excluding: .top, insets: .zero)
        
        let tableViewHeight = (0..<viewModel.optionsCount).reduce(0) { $0 + self.heightForOption(atIndex: $1) }
        optionsTableView.height(tableViewHeight)
    }
    
    private func configureViews() {
        descriptionLabel.numberOfLines = 0
        
        optionsTableView.dataSource = self
        optionsTableView.delegate = self
        
        optionsTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.01))
        optionsTableView.separatorStyle = .none
        optionsTableView.allowsSelection = true
        optionsTableView.isScrollEnabled = false
        optionsTableView.estimatedRowHeight = 50
        optionsTableView.register(SelectionTableViewCell.self, forCellReuseIdentifier: selectionTableViewCellIdentifier)
    }
    
    private func styleViews() {
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = UIColor.brownishGrey // TODO: from ChatUIConfiguration
        optionsTableView.backgroundColor = UIColor.clear
    }
    
    private func bindData() {
        descriptionLabel.text = viewModel.selectionChatItemConfiguration.description
    }
    
    override func embedInternalContentView(animationStyle: ContentAppearAnimationStyle, completion: @escaping () -> ()) {
        shrinkContentIfPossible = false
        super.embedInternalContentView(animationStyle: animationStyle) { [weak self] in
            self?.animateCellsAppear()
            completion()
        }
    }
    
    override func showChatItem(completion: @escaping () -> ()) {
        showItemCompletion = completion
        super.showChatItem() { } // custom completion point
    }
    
    private func animateCellsAppear() {
        optionsTableView.layoutIfNeeded()
        let cells = optionsTableView.visibleCells(in: 0)
        let slideInFromTopAnimation = AnimationType.from(direction: .top, offset: 20.0)
        UIView.animate(views: cells, animations: [slideInFromTopAnimation], initialAlpha: 0.0, finalAlpha: 1.0, duration: 0.2)
    }
    
    fileprivate func heightForOption(atIndex index: Int) -> CGFloat {
        let width = self.frame.width - contentContainer.frame.minX - configuration.horizontalPadding
        prototypeOptionCell.titleLabel.text = viewModel.title(forIndex: index)
        prototypeOptionCell.contentView.width(width)
        return prototypeOptionCell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
    }
}

extension SelectionChatItemView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.optionsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: selectionTableViewCellIdentifier) as! SelectionTableViewCell
        cell.titleLabel.text = viewModel.title(forIndex: indexPath.row)
        cell.isEnabled = viewModel.itemEnabled(at: indexPath.row)
        return cell
    }
}

extension SelectionChatItemView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0 // cell will be fade in from animateCellsAppear
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.selectOption(atIndex: indexPath.row)
        if !viewModel.selectionChatItemConfiguration.allowMultipleSelection {
            tableView.allowsSelection = false
        }
        showItemCompletion?()
    }
    
    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return viewModel.itemEnabled(at: indexPath.row)
    }
}
