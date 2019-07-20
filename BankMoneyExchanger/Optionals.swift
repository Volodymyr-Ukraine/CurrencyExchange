//
//  Optionals.swift
//  BankMoneyExchanger
//
//  Created by Vladimir on 7/13/19.
//  Copyright © 2019 Volodymyr. All rights reserved.
//

import Foundation

public extension Optional {
    func `do` (_ action: (Wrapped) -> ()) {
        self.map(action)
    }
}
