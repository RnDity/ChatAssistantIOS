//
//  ExternalOptionsSelection]ViewModel.swift
//  ChatAssistant
//
//  Created and developed by RnDity sp. z o.o. in 2018.
//  Copyright © 2018 RnDity sp. z o.o. All rights reserved.
//

import Foundation

public class ExternalOptionsSelectionConfiguration {
    public private(set) var options: [[String]]
    
    public init(options: [[String]]) {
        self.options = options
    }
}

public class ExternalOptionsSelectionViewModel {
    
    public private(set) var configuration: ExternalOptionsSelectionConfiguration
    
    public private(set) var selectedOptionIndex: IndexPath?
    
    public var shouldDismiss: ((Int) -> Bool)?
        
    public var options: [[String]] {
        return configuration.options
    }
    
    init(id: String, configuration: ExternalOptionsSelectionConfiguration) {
        self.configuration = configuration
    }
    
    public func title(forRow row: Int, inSection section: Int) -> String {
        return configuration.options[section][row]
    }
    
    public func selectOption(fromSection section: Int, inRow row: Int) {
        selectedOptionIndex = IndexPath(row: row, section: section)
    }
    
    public func allowDismissOption(atIndex index: Int) -> Bool {
        return shouldDismiss?(index) ?? true
    }
}
