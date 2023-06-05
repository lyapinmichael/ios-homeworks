//
//  NetworkService.swift
//  Navigation
//
//  Created by Ляпин Михаил on 03.06.2023.
//

import Foundation

enum AppConfigutation: String, CaseIterable {
    case starships = "https://swapi.dev/api/starships/"
    case people = "https://swapi.dev/api/people/"
    case planets = "https://swapi.dev/api/planets/"
    
    var url: (String) -> URL? {
        { endpoint in
            URL(string: self.rawValue + endpoint)
        }
    }
}

enum NetworkError: Error {
    case badURL
    case statsusCodeNot200
    case dataNil
    case cannotCastAnswer
}

struct NetworkService {
    
    static func request(requestURL: URL?, completion: @escaping ((Result<[String:Any], Error>) -> Void)) {
        let session = URLSession(configuration: .default)
        
        guard let url = requestURL else {
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
    
    static func requestTodo(number: Int, completion: @escaping ((Result<Todo, Error>) -> Void)) {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/" + String(number)) else {
            assertionFailure("Bad string: cannot initialize URL")
            return
        }
        
        let urlSession = URLSession(configuration: .default)
        
        let dataTask = urlSession.dataTask(with: url) {data, response, error in
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
            }
            
            guard let data else {
                print("No data was returned by API, data = nil")
                completion(.failure(NetworkError.dataNil))
                return
            }
            
            do {
                guard let serializedData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    print("Failed to serialize and cast data")
                    completion(.failure(NetworkError.cannotCastAnswer))
                    return
                }
                
                let completed = serializedData["completed"] as? Bool
                let id = serializedData["id"] as? Int
                let userID = serializedData["userId"] as? Int
                let title = serializedData["title"] as? String
                
                guard let completedSafe = completed,
                      let idSafe = id,
                      let userIDSafe = userID,
                      let titleSafe = title else {
                    print("Unable to parse received data")
                    completion(.failure(NetworkError.cannotCastAnswer))
                    return
                }
                
                let todo = Todo(completed: completedSafe,
                                id: idSafe,
                                title: titleSafe,
                                userID: userIDSafe)

                completion(.success(todo))
                
            } catch {
                print(error)
            }
        }
        
        dataTask.resume()
        
    }
    
    static func requestPlanetData(number: Int, completion: @escaping ((Result<Planet, Error>) -> Void)) {
        
        guard let url = URL(string: "https://swapi.dev/api/planets/" + String(number)) else {
                assertionFailure("Bad string: cannot initialize URL")
                return
        }
        
        let session = URLSession(configuration: .default)
        
        let dataTask = session.dataTask(with: url) {data, response, error in
            if let error {
                print(error.localizedDescription)
                completion(.failure(error))
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("Bad response")
                completion(.failure(NetworkError.statsusCodeNot200))
                return
            }
            
            if response.statusCode != 200 {
                print("Failed to get response from API, status code != 200")
                completion(.failure(NetworkError.statsusCodeNot200))
                return
            }
            
            guard let data else {
                print("No data was returned by API, data = nil")
                completion(.failure(NetworkError.dataNil))
                return
            }
            
            do {
                let planetData = try JSONDecoder().decode(Planet.self, from: data)
                completion(.success(planetData))
            } catch {
                print(error)
            }
        }
        dataTask.resume()
    }
    
    static func requestRezidentsOfPlanet(urlString: String, completion: @escaping ((Result<PlanetResident, Error>) -> Void)) {
        
        guard let url = URL(string: urlString) else {
                assertionFailure("Bad string: cannot initialize URL")
                completion(.failure(NetworkError.badURL))
                return
        }
        
        let session = URLSession(configuration: .default)
        
        let dataTask = session.dataTask(with: url) {data, response, error in
            if let error {
                print(error.localizedDescription)
                completion(.failure(error))
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("Bad response")
                completion(.failure(NetworkError.statsusCodeNot200))
                return
            }
            
            if response.statusCode != 200 {
                print("Failed to get response from API, status code != 200")
                completion(.failure(NetworkError.statsusCodeNot200))
                return
            }
            
            guard let data else {
                print("No data was returned by API, data = nil")
                completion(.failure(NetworkError.dataNil))
                return
            }
            
            do {
                let residentData = try JSONDecoder().decode(PlanetResident.self, from: data)
                completion(.success(residentData))
            } catch {
                print(error)
            }
        }
        dataTask.resume()
    }
}

