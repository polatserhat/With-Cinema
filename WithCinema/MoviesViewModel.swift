//
//  MoviesViewModel.swift
//  WithCinema
//
//  Created by Serhat  on 13.03.24.
//


import Foundation
import Combine

class MoviesViewModel: ObservableObject {
    @Published var movies: [Movie] = [] // Fetched movies
    @Published var filteredMovies: [Movie] = [] // Movies after applying search and/or sort
    
    private var movieService = MovieService()
    private var cancellables = Set<AnyCancellable>()

    // Properties for search and sorting
    @Published var searchTerm: String = ""
    @Published var isAlphabetical: Bool = false
    
    init() {
        setupBindings()
        fetchMovies()
    }

    func fetchMovies() {
        movieService.fetchMovies { [weak self] (movies, error) in
            DispatchQueue.main.async {
                if let movies = movies {
                    self?.movies = movies
                    self?.applyFiltersAndSorting()
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func setupBindings() {
        // React to changes in search term or sort preference to filter/sort movies
        $searchTerm.combineLatest($isAlphabetical)
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { [weak self] searchTerm, isAlphabetical in
                self?.applyFiltersAndSorting()
            }
            .store(in: &cancellables)
    }
    
    private func applyFiltersAndSorting() {
        var result = movies
        
        // Filter by search term
        if !searchTerm.isEmpty {
            result = result.filter { $0.title.localizedCaseInsensitiveContains(searchTerm) }
        }
        
        // Sort if needed
        if isAlphabetical {
            result.sort { $0.title.lowercased() < $1.title.lowercased() }
        }
        
        // Update the filtered movies
        filteredMovies = result
    }
    func toggleAlphabeticalSorting() {
        self.isAlphabetical.toggle()
        // Potentially additional logic to sort movies
    }

}
