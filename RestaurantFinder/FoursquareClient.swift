//
//  FoursquareClient.swift
//  RestaurantFinder
//
//  Created by Kevin VanEvery on 7/30/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import Foundation

enum Foursquare: Endpoint{
    case Venues(VenueEndpoint)
    
    enum VenueEndpoint: Endpoint {
        case Search(clientID: String, clientSecret: String, coordinate: Coordinate, category: Category, query: String?, searchRadius: Int?, limit: Int?)
        
        enum Category {
            case Food([FoodCategory]?)
            
            enum FoodCategory: String {
                case American = "4bf58dd8d48988d14e941735"
            }
            
            var description: String {
                switch self {
                case .Food(let categories):
                    if let categories = categories {
                        let commaSeparatedString = categories.reduce("") { categoryString, category in
                            "\(categoryString),\(category.rawValue)"
                        }
                        return commaSeparatedString.substringFromIndex(commaSeparatedString.startIndex.advancedBy(1))
                    } else {
                        return "4d4b7105d754a06374d81259"  // DEFAULT FOOD CATEGORY ID
                    }
                }
            }
        }
        
        var baseURL: String {
            return "https://api.foursquare.com"
        }
        
        var path: String {
            switch self {
                case .Search: return "/v2/venues/search"
            }
        }
        
        private struct ParameterKeys {
            static let clientID = "client_id"
            static let clientSecret = "client_secret"
            static let version = "v"
            static let category = "categoryId"
            static let location = "ll"
            static let query = "query"
            static let limit = "limit"
            static let searchRadius = "radius"
        }
        
        private struct DefaultValues {
            static let version = "20160301"
            static let limit = "50"
            static let searchRadius = "2000"
        }
        
        var parameters: [String : AnyObject] {
            switch self {
            case .Search(let clientID, let clientSecret, let coordinate, let category, let query, let searchRadius, let limit):
                
                var parameters: [String: AnyObject] = [
                    ParameterKeys.clientID: clientID,
                    ParameterKeys.clientSecret: clientSecret,
                    ParameterKeys.version: DefaultValues.version,
                    ParameterKeys.location: coordinate.description,
                    ParameterKeys.category: category.description
                ]
                
                if let searchRadius = searchRadius {
                    parameters[ParameterKeys.searchRadius] = searchRadius
                } else {
                    parameters[ParameterKeys.searchRadius] = DefaultValues.searchRadius
                }
                
                if let limit = limit{
                    parameters[ParameterKeys.limit] = limit
                } else {
                    parameters[ParameterKeys.limit] = DefaultValues.limit
                }
                
                if let query = query {
                    parameters[ParameterKeys.query] = query
                }
                
                return parameters
            }
        }
    }
    
    var baseURL: String {
        switch self {
        case .Venues(let endpoint):
            return endpoint.baseURL
        }
    }
    
    var path: String {
        switch self {
        case .Venues(let endpoint):
            return endpoint.path
        }
    }
    
    var parameters: [String : AnyObject]{
        switch self {
        case .Venues(let endpoint):
            return endpoint.parameters
        }
    }
}

final class FoursquareClient: APIClient {
    let configuration: NSURLSessionConfiguration
    
    lazy var session: NSURLSession = {
        return NSURLSession(configuration: self.configuration)
    }()
    
    let clientID: String
    let clientSecret: String
    
    init(configuration: NSURLSessionConfiguration, clientID: String, clientSecret: String) {
        self.configuration = configuration
        self.clientID = clientID
        self.clientSecret = clientSecret
    }
    
    convenience init(clientID: String, clientSecret: String) {
        self.init(configuration: .defaultSessionConfiguration(), clientID:  clientID, clientSecret:  clientSecret)
    }
    
    func fetchRestaurantsFor(
    location: Coordinate,
    category: Foursquare.VenueEndpoint.Category,
    query: String? = nil,
    searchRadius: Int? = nil,
    limit: Int? = nil,
    completion: APIResult<[Venue]> -> Void) {
        let searchEndpoint = Foursquare.VenueEndpoint.Search(clientID: self.clientID, clientSecret: self.clientSecret, coordinate: location, category: category, query: query, searchRadius: searchRadius, limit: limit)
        let endpoint = Foursquare.Venues(searchEndpoint)
        
        fetch(endpoint, parse: { json -> [Venue]? in
            
            guard let venues = json["response"]?["venues"] as? [[String : AnyObject]] else {
                return nil
            }
            
            return venues.flatMap { venueDict in
                return Venue(JSON: venueDict)
            }
            
        }, completion: completion)
    }
}
