//
//  MoviesViewModel.swift
//  WithCinema
//
//  Created by Serhat  on 14.03.24.
//
import Foundation
import Combine

class MoviesViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var selectedMovie: Movie?
    @Published var youtubeTrailers: [URL] = []
    @Published var selectedMovieCredits: MovieCredits?
    @Published var castMembers: [CastMember] = []
    
    var movieService = MovieService()
    
    init() {
        fetchMovies()
    }
    
    // Fetch movies from the API
    func fetchMovies() {
        movieService.fetchMovies { [weak self] movies, error in
            DispatchQueue.main.async {
                guard let movies = movies else {
                    print(error?.localizedDescription ?? "Unknown error")
                    return
                }
                self?.movies = movies
            }
        }
    }
    // Inside MoviesViewModel
    func fetchCreditsForSelectedMovie() {
        guard let movieId = selectedMovie?.id else { return }
        
        movieService.fetchMovieCredits(movieId: movieId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let credits):
                    self?.selectedMovieCredits = credits
                case .failure(let error):
                    print("Error fetching movie credits: \(error.localizedDescription)")
                }
            }
        }
    }
}

extension MoviesViewModel {
    func fetchTrailersForSelectedMovie() {
        guard let movieId = selectedMovie?.id else { return }

        movieService.fetchMovieTrailers(movieId: movieId) { [weak self] (trailers: [Video]?, error: Error?) in
            DispatchQueue.main.async {
                if let trailers = trailers {
                    // Assuming Video has a property `youtubeURL` of type URL
                    self?.youtubeTrailers = trailers.compactMap { $0.youtubeURL }
                } else {
                    print(error?.localizedDescription ?? "Failed to fetch trailers")
                }
            }
        }
    }

}
