//
//  CalendarViewController.swift
//  BankMoneyExchanger
//
//  Created by Vladimir on 7/12/19.
//  Copyright © 2019 Volodymyr. All rights reserved.
//

import UIKit
import SnapKit

class CalendarViewController: UIViewController {
    
    // MARK: -
    // MARK: Properties
    
    var calendarButton = UIButton()
    var label: UILabel = UILabel()
    
    public var onClick: ( () -> () )? = nil
    
    // MARK: -
    // MARK: Init and Deinit
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(imageLiteralResourceName: "calendar-1_32")
        self.calendarButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        self.calendarButton.setImage(image, for: .normal)
        self.calendarButton.addTarget(self, action: #selector(onDataPick), for: .touchDown)
        self.view.addSubview(self.calendarButton)
        self.label.text = "10.07.2019"
        self.label.frame = CGRect(x: 0,y: 0,width: 50,height: 50)
        self.view.addSubview(label)
    }

    override func viewDidLayoutSubviews() {
        self.label.snp.makeConstraints{ (make) -> () in
            make.right.equalToSuperview().offset(-5)
            make.centerY.equalToSuperview()
        }
        self.calendarButton.snp.makeConstraints{ (make) -> Void in
            make.right.equalTo(self.label.snp.left).offset(-5)
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: -
    // MARK: Methods
    
    @objc func onDataPick() {
        let actionController = UIAlertController(title: " ", message: " ", preferredStyle: .alert)
        
        let data = UIDatePicker.init(frame: CGRect(x:0, y: 0, width: 270, height: 80))
        data.maximumDate = Date(timeIntervalSinceNow: 0)
        let time = TimeInterval(exactly: -2*(365*24*60*60))
        data.minimumDate = Date(timeIntervalSinceNow: time ?? -5000)
        data.datePickerMode = .date
        actionController.view.addSubview(data)
        
        let popover = actionController.popoverPresentationController
        popover?.sourceView = view
        //popover?.sourceRect = CGRect(x: 0, y: 0, width: 300, height: 500)
        present(actionController, animated: true){
            
        }
        
        
        if onClick != nil {
            onClick!()
        }
    }
    
}
