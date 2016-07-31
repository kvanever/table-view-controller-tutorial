//
//  FoursquareClient.swift
//  RestaurantFinder
//
//  Created by Kevin VanEvery on 7/30/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import Foundation

enum Foursquare {
    case Venues(VenueEndpoint)
    
    enum VenueEndpoint {
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
                        return "4d4b7105d754a06374d81259"
                    }
                }
            }
        }
    }
}