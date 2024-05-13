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
    let originalLanguage: String
   // let videos: [Video]?
}

// Define the API response model that captures the array of movies.
struct ApiResponse: Decodable {
    let results: [Movie]
}

enum MovieServiceError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case decodingError(Error)
}


struct Video: Identifiable, Decodable {
    let id: String
    let key: String
    let site: String
    
    var youtubeURL: URL? {
        guard site == "YouTube" else { return nil }
        return URL(string: "https://youtube.com/watch?v=\(key)")
    }
}

struct VideoApiResponse: Decodable {
    let results: [Video]
}

struct MovieCredits: Codable {
    let cast: [CastMember]
    let crew: [CrewMember]
}

struct CastMember: Codable, Identifiable {
    let id: UUID = UUID()
    let name: String
    let character: String
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case name, character
        case profilePath = "profile_path"
    }
}

struct CrewMember: Codable,Identifiable {
    let id: UUID = UUID()
    let name: String
    let job: String
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case name, job
        case profilePath = "profile_path"
    }
}
