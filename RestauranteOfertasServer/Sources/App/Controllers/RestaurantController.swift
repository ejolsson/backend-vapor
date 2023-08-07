//
//  File.swift
//  
//
//  Created by Alberto Junquera Ramírez on 7/8/23.
//

import Vapor
import Fluent

struct RestaurantController : RouteCollection{
    func boot(routes: Vapor.RoutesBuilder) throws {
        routes.group(JWTToken.authenticator(),JWTToken.guardMiddleware()) { builder in
            builder.post("addRestaurant", use: addRestaurant)
        }
    }
    
     //MARK: - Routes -
    //Companies can add restaurants.
    //  func addRestaurant(req: Request) async throws -> Restaurant.Public {
    func addRestaurant(req: Request) async throws -> String {
        //TODO: Where should be checked if the user is a company?
        try Restaurant.Create.validate(content: req)
        
        //Decode
        let restaurantCreate = try req.content.decode(Restaurant.Create.self)
        
        //Save restaurant
        let restaurant = Restaurant(idCompany: restaurantCreate.idCompany, name: restaurantCreate.name, type: restaurantCreate.type, idAddress: restaurantCreate.idAddress, idCoordinates: restaurantCreate.idCoordinates, idSchedule: restaurantCreate.idSchedule)
        
        try await restaurant.create(on: req.db)
        
        
        return "Restaurant Added"
        
    }
    
}
