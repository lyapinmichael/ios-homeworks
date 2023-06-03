//
//  NetworkService.swift
//  Navigation
//
//  Created by Ляпин Михаил on 03.06.2023.
//

import Foundation

enum AppConfigutation {
    case starships(String)
    case people(String)
    case planets(String)
}

enum NetworkError: Error {
    case statsusCodeNot200
    case dataNil
    case cannotCastAnswer
}

struct NetworkService {
    
    static func request(forConfiguration config: AppConfigutation, completion: @escaping ((Result<[String:Any], Error>) -> Void)) {
        let session = URLSession(configuration: .default)
        var requestString: String
        
        switch config {
        case .planets(let planetString):
            requestString = planetString
        case .people(let personString):
            requestString = personString
        case .starships(let starshipString):
            requestString = starshipString
            
        }
        
        guard let url = URL(string: requestString) else {
            assertionFailure("Bad string: cannot initialize URL")
            return
        }
        
        let dataTask = session.dataTask(with: url) { data, response, error in
            if let error {
                print(error.localizedDescription)
                completion(.failure(error))
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("Bad response")
                return
            }
            
            if response.statusCode != 200 {
                print("Failed to get response from API, status code != 200")
                completion(.failure(NetworkError.statsusCodeNot200))
                return
            } else {
                print(response.allHeaderFields, "\n\n", response.statusCode)
            }
            
         
            
            guard let data else {
                print("No data was returned by API, data = nil")
                completion(.failure(NetworkError.dataNil))
                return
            }
            
            do {
                
                guard let serializedData = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Failed to serialize and cast data")
                    completion(.failure(NetworkError.cannotCastAnswer))
                    return
                }
                
                completion(.success(serializedData))
                
            } catch {
                print(error)
            }
            
        }
        
        dataTask.resume()
    }
}

