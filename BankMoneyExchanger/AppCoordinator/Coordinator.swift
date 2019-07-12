//
//  Coordinator.swift
//  BankMoneyExchanger
//
//  Created by Vladimir on 7/11/19.
//  Copyright © 2019 Volodymyr. All rights reserved.
//

import UIKit

class Coordinator {
    private var navigationController: UINavigationController
    
    public var model: CurrencyModel?
    
    
    init(navigationController navContr: UINavigationController) {
        self.navigationController = navContr
        let model = CurrencyModel()
    }
    
    public func start(){
        showTablePB()
    }
    
    public func showTablePB() {
        
        /*let controller = CurrencyPBTableViewController(model: model)
        model.eventRouting
            .take(during: self.lifetime)
            .observeValues{ [weak self] event in
                _ = self?.navigationController?.popViewController(animated: false)
                switch event {
                case .archive:
                    self?.showArchiveScreen()
                case .photo:
                    self?.showPhotoScreen()
                }
        }
        self.navigationController?.pushViewController(controller, animated: false) */
    }
}
