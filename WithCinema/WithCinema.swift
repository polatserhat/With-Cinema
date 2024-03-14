//
//  WithCinema.swift
//  WithCinema
//
//  Created by Serhat  on 13.03.24.
//

import Foundation

// Define the Movie model to capture the properties of each movie we're interested in.
struct Movie: Identifiable,Decodable{
    let id: Int
    let adult: Bool
    let title: String
    let overview: String
    let popularity: Double
    let releaseDate: String
    let posterPath: String
}

// Define the API response model that captures the array of movies.
struct ApiResponse: Decodable {
    let results: [Movie]
}
