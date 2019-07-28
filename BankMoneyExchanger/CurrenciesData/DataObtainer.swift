//
//  DataObtainer.swift
//  BankMoneyExchanger
//
//  Created by Vladimir on 7/21/19.
//  Copyright © 2019 Volodymyr. All rights reserved.
//

import Foundation
import Alamofire

class DataObtainer {
    typealias InputJSON = CurrenciesData
    
    // MARK: -
    // MARK: Properties
    
    public var readedData : InputJSON? = nil
    private var parameters: [String: String]
    
    // MARK: -
    // MARK: Init and Deinit
    
    init() {
        self.parameters = ["json" : "", "date" : ""]
    }
    
    // MARK: -
    // MARK: Public methods
    
    public func readFileJSON<T: Decodable>(from path: String) -> T? {
        let text = self.pathToText(inputString: path)
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(T.self, from: text.data(using: .utf8) ?? Data())
        } catch {
            print("error in decoding JSON file")
            return nil
        }
    }
    
    public func readHttpData(site: String, at dateString: String, toDo: @escaping (InputJSON) -> () ) {
        self.parameters["date"] = dateString
        Alamofire.request(site,
                          method: .get,
                          parameters: self.parameters)
            .responseString{[weak self] response in
                guard let this = self else {return}
                switch response.result {
                case .success:
                    guard let rawJSON = response.value else { return }
                    let decoderNames = JSONDecoder()
                    do {
                        this.readedData = try decoderNames.decode(InputJSON.self, from: rawJSON.data(using: .utf8)!)
                    } catch {
                        print("error in decoding JSON")
                    }
                    guard let newData = this.readedData else {return}
                    toDo(newData)
                case .failure:
                    print(response)
                }
        }
        
    }
    
    // MARK: -
    // MARK: Private methods
    
    private func pathToText(inputString str: String) -> String{
        guard let path = Bundle.main.path(forResource: "\(str)", ofType: "json") else {
            print("File JSON not found")
            return ""
        }
        let expandedPath = URL(fileURLWithPath: path)
        return try! String(contentsOf: expandedPath)
    }
}
