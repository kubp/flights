//
//  searchResult.swift
//  flights
//
//  Created by user on 4/24/18.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation
//struct Route: Decodable {
//    let latFrom: Float
//    let lngTo: Float
//    let latTo: Float
//    let lngFrom: Float
//}
//
//
//struct FlightData: Decodable {
//    let mapIdfrom: String
//    let flyFrom: String
//    let fly_duration: String
//    let flyTo: String
//    let aTime: Int
//    let dTime: Int
//    let price: Int
//    let cityFrom: String
//    let cityTo: String
//



class Route{
    public var  latFrom: Float
    public var  lngTo: Float
    public var  latTo: Float
    public var  lngFrom: Float
    
    init(latFrom: Float, lngTo: Float, latTo: Float, lngFrom: Float) {
        self.latTo = latTo
        self.latFrom = latFrom
        self.lngTo=lngTo
        self.lngFrom = lngFrom
    }
}

// struct maybe?
class Flight {
    
    public var mapIdfrom: String
    public var  flyFrom: String
    public var  fly_duration: String
    public var  flyTo: String
    public var  aTime: Date
    public var  dTime: Date
    public var  price: Int
    public var  cityFrom: String
    public var  cityTo: String
    public var route: [Route]
    
    init(mapIdfrom: String, flyFrom: String,fly_duration: String,flyTo: String,aTime: Date,dTime: Date,price: Int,cityFrom: String,cityTo: String, route: [Route]) {
        self.flyFrom = flyFrom
        self.mapIdfrom = mapIdfrom
        self.flyTo = flyTo
        self.flyFrom = flyFrom
        self.aTime = aTime
        self.dTime = dTime
        self.price = price
        self.cityFrom = cityFrom
        self.cityTo = cityTo
        self.fly_duration = fly_duration
        self.route = route
        
    }
    
}

// antipattern
class searchResult {
    static let shared = searchResult()
    
    var data: [Flight] = []
}

