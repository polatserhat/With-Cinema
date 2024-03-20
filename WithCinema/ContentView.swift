//
//  ContentView.swift
//  WithCinema
//
//  Created by Serhat  on 13.03.24.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MoviesViewModel()
    @State private var searchText = ""

    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)

    var body: some View {
        TabView {
            NavigationView {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.movies, id: \.id) { movie in
                            VStack {
                                NavigationLink(destination: MovieDetailView(movie: movie,viewModel: viewModel)) {
                                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)")) { image in
                                        image.resizable()
                                             .aspectRatio(2/3, contentMode: .fit) // Adjusted aspect ratio for portrait-like posters
                                             .cornerRadius(8) // Rounded corners
                                    } placeholder: {
                                       ProgressView()
                                        
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .navigationTitle("Popular Movies")
            }
            .searchable(text: $searchText)
            .tabItem {
                Label("Movies", systemImage: "film")
            }
        
            Text("Settings or other feature")
            .tabItem {
            Label("Settings", systemImage: "gear")
                    }
            
            
        }
        .preferredColorScheme(.dark) // Ensures dark mode
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}






    
    

