
import SwiftUI

struct MovieDetailView: View {
    let movie: Movie

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 10) { // Changed alignment to .center
                // Use HStack with Spacers to center the poster horizontally
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

                Text(movie.adult ? "Adult" : "Family Friendly")
                    .foregroundColor(movie.adult ? .red : .green)
                    .padding(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(movie.adult ? Color.red : Color.green, lineWidth: 2)
                    )

                Text("Release Date: \(movie.releaseDate)")
                    .font(.subheadline)

                Text(String(format: "Popularity: %.2f", movie.popularity))
                    .font(.subheadline)

                Text(movie.overview)
                    .font(.body)
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let mockMovie = Movie(
            id: 123,
            adult: false,
            title: "Interstellar",
            overview: "A team of explorers travel through a wormhole in space in an attempt to ensure humanity's survival.",
            popularity: 8.3,
            releaseDate: "2014-11-07",
            posterPath: "/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg" // Added a sample poster path
        )

        MovieDetailView(movie: mockMovie)
    }
}
