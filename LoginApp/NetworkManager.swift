//
//  NetworkManager.swift
//  LoginApp
//
//  Created by Lena Soroka on 21.01.2021.
//

import Foundation
import Alamofire

class NetworkManager {
    
    enum AuthConstants {
        enum MockCredentials {
            //static let email = "junior-ios-developer@mailinator.com"
            //static let password = "s4m8AJDbVvX4H8aF"
            static let projectId = "58b3193b-9f15-4715-a1e3-2e88e375f62b"
        }
        enum RequestParameters {
            static let email = "email"
            static let password = "password"
            static let projectId = "project_id"
        }
        static let url = "https://api-qa.mvpnow.io/v1/sessions"
    }
    
    func login(email: String, password: String, completion: @escaping (_ result: String?, _ error: Error?) -> Void) {
        let parameters: Parameters = [AuthConstants.RequestParameters.email: email, AuthConstants.RequestParameters.password: password, AuthConstants.RequestParameters.projectId: AuthConstants.MockCredentials.projectId]
        AF.request(AuthConstants.url, method: .post, parameters: parameters).response {
            response in
            switch response.result {
            case .success(let data):
                let json = try! JSONSerialization.jsonObject(with: data!,
                                                             options: []) as? NSDictionary
                let token = json?.object(forKey: "access_token") as? String
                completion(token, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}

