//
//  ContentView.swift
//  WithCinema
//
//  Created by Serhat  on 13.03.24.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MoviesViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.movies, id: \.id) { movie in
                VStack(alignment: .leading, spacing: 8) {
                    Text(movie.title)
                        .font(.title)
                        .bold()
                    
                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)")) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 100, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    Text(movie.adult ? "Adult" : "Family Friendly")
                        .font(.subheadline)
                        .foregroundColor(movie.adult ? .red : .green)
                    
                    Text(truncateOverview(overview: movie.overview))
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                        Text("See Details")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Popular Movies")
            
            .preferredColorScheme(.dark)
            .onAppear {
                viewModel.fetchMovies()
            }
        }
    }
    
    private func truncateOverview(overview: String) -> String {
        let sentences = overview.components(separatedBy: ". ").prefix(3)
        return sentences.joined(separator: ". ") + (sentences.count >= 3 ? "..." : "")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


    
    

