//
//  NetworkManager.swift
//  LoginApp
//
//  Created by Lena Soroka on 21.01.2021.
//

import Foundation
import Alamofire

class NetworkManager {
    func login(url: String, credentials: Parameters, completion: @escaping (_ result: NSDictionary?, _ error: Error?) -> Void) {
        AF.request(url, method: .post, parameters: credentials).response {
            response in
            switch response.result {
            case .success(let data):
                let json = try! JSONSerialization.jsonObject(with: data!,
                                                             options: []) as? NSDictionary
                completion(json, nil) 
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}

