
import SwiftUI

import SwiftUI

struct MovieDetailView: View {
    @ObservedObject var viewModel: MoviesViewModel
        let movie: Movie


    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 10) { 
                HStack {
                    Spacer()
                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)")) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(8)
                        case .failure:
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(width: 200, height: 300)
                    .cornerRadius(8)
                    Spacer()
                }
                .padding(.bottom, 10)
                
                // Other details...
                
                Text(movie.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                // Trailer Part
                if let firstTrailerURL = viewModel.youtubeTrailers.first {
                    VStack(alignment: .center, spacing: 5) {
                        Text("Trailer")
                            .font(.headline)
                            .padding(5)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5)
                        
                        Link(destination: firstTrailerURL){
                            HStack {
                                Image(systemName: "play.circle")
                                    .foregroundColor(.red)
                                Text("Watch on YouTube")
                                    .foregroundColor(.blue)
                            }
                            .padding(5)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(5)
                        }
                    }
                }
                
              
                
             
                
                Text(String(format: "Popularity: %.2f", movie.popularity))
                    .font(.subheadline)
                
                Text(movie.overview)
                    .font(.body)
                // Credits Section
                if let credits = viewModel.selectedMovieCredits {
                    VStack{
                        Text("Cast")
                            .font(.headline)
                            .padding(.top)
                        ForEach(credits.cast.prefix(10), id: \.id) { castMember in
                            Text(castMember.name)
                                .font(.subheadline)
                        }

                        Text("Crew")
                            .font(.headline)
                            .padding(.top)
                        ForEach(credits.crew.prefix(5), id: \.id) { crewMember in
                            Text("\(crewMember.job): \(crewMember.name)")
                                .font(.subheadline)
                        }
                    }
                    Spacer()
                }
                Text("Release Date: \(movie.releaseDate)")
                    .padding(3)
                    .foregroundColor(.blue)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(6)
                   

                
          
            }
            .padding()
                        }
                        .navigationTitle("Details")
                        .navigationBarTitleDisplayMode(.inline)
                        .preferredColorScheme(.dark)
                        .onAppear {
                           
                            viewModel.selectedMovie = movie
                            viewModel.fetchTrailersForSelectedMovie()
                            viewModel.fetchCreditsForSelectedMovie() 

                        }
                    }
                }

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = MoviesViewModel()
        let mockMovie = Movie(
            id: 123,
            adult: false,
            title: "Interstellar",
            overview: "A team of explorers travel through a wormhole in space in an attempt to ensure humanity's survival.",
            popularity: 8.3,
            releaseDate: "2014-11-07",
            posterPath: "/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg", 
            originalLanguage: "EN"
            
        )

        MovieDetailView(viewModel: viewModel, movie: mockMovie)
    }
}



