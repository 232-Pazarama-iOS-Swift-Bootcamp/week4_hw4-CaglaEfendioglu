//
//  Service.swift
//  odev4
//
//  Created by Cagla Efendioglu on 13.10.2022.
//

import Foundation
import Moya

protocol IServiceProtocol {
    func fetch<T: Codable>(url: URL,
                           completion: @escaping (Result<T, Error>) -> Void)
}

class IService: IServiceProtocol {
    func fetch<T: Codable>(url: URL,
                           completion: @escaping (Result<T, Error>) -> Void) {
        
        URLSession.shared.dataTask(with: url) { (data,respone,error) in
            if error != nil || data == nil { return }
            
            do {
                let photoData = try JSONDecoder().decode(T.self, from: data!)
                completion(.success(photoData))
            } catch {
                completion(.failure(error))
            }
            
        }.resume()
    }
}
