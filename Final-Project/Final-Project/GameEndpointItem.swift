//
//  HomeEndpointItem.swift
//  Final-Project
//
//  Created by Doğuş  Kaynak on 24.05.2021.
//

import Foundation
import CoreApi

//MARK: - GameEndpointItem
enum GameEndpointItem: Endpoint {
    case gamepage(query: String)
    
    var baseUrl: String { "https://api.rawg.io/api/" }
    
    var path: String {
        switch self {
        case .gamepage(let query): return "games?\(query)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .gamepage:
            return .get
        }
    }
}

//MARK: - PlatformTagEndpointItem
enum PlatformTagEndpointItem: Endpoint {
    case platforms
    
    var baseUrl: String { "https://api.rawg.io/api/" }
    
    var path: String {
        switch self {
        case .platforms: return "platforms/lists/parents?key=b306e5dd547c4e80840a4afe9a876069"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .platforms:
            return .get
        }
    }
}

//MARK: - GameDetailEndpointItem
enum GameDetailEndpointItem: Endpoint {
    case gameId(query: Int)
    
    var baseUrl: String { "https://api.rawg.io/api/" }
    
    var path: String {
        switch self {
        case .gameId(let query): return "games/\(query)?key=b306e5dd547c4e80840a4afe9a876069"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .gameId:
            return .get
        }
    }
}

//MARK: - SearchEndPointItem
enum SearchEndPointItem: Endpoint {
    case search(query: String)
    
    var baseUrl: String { "https://api.rawg.io/api/" }
    
    var path: String {
        switch self {
        case .search(let query): return "games?key=b306e5dd547c4e80840a4afe9a876069&search=\(query)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .search:
            return .get
        }
    }
}

//MARK: - FilterEndPointItem
enum FilterEndPointItem: Endpoint {
    case filter(query: String)
    
    var baseUrl: String { "https://api.rawg.io/api/" }
    
    var path: String {
        switch self {
        case .filter(let query): return "games?key=b306e5dd547c4e80840a4afe9a876069&parent_platforms=\(query)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .filter:
            return .get
        }
    }
}
