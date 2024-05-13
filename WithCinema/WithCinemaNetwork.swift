import Foundation

class MovieService {
    private let headers = [
        "accept": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5YTUzZWEzYTMzY2VjYmJhYjg4NmNkMWVmN2MwNTY1YyIsInN1YiI6IjY1ZWYxOWZkZjVjYjIxMDE2MjQ1NjU3NCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.y2RkIboYCWxqVLb1k3fPy9G9t4__0zrk62atLHqNkBk"
    ]

    func fetchMovies(completion: @escaping ([Movie]?, Error?) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc") else {
            completion(nil, MovieServiceError.invalidURL)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, MovieServiceError.invalidData)
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedResponse = try decoder.decode(ApiResponse.self, from: data)
                completion(decodedResponse.results, nil)
            } catch {
                completion(nil, MovieServiceError.decodingError(error))
            }
        }
        dataTask.resume() // Start the network request
    }

    func fetchMovieTrailers(movieId: Int, completion: @escaping ([Video]?, Error?) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)/videos?language=en-US") else {
            completion(nil, MovieServiceError.invalidURL)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, MovieServiceError.invalidData)
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedResponse = try decoder.decode(VideoApiResponse.self, from: data)
                completion(decodedResponse.results, nil)
            } catch {
                completion(nil, MovieServiceError.decodingError(error))
            }
        }
        dataTask.resume() // Start the network request
    }
}

extension MovieService {
    func fetchMovieCredits(movieId: Int, completion: @escaping (Result<MovieCredits, Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)/credits"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5YTUzZWEzYTMzY2VjYmJhYjg4NmNkMWVmN2MwNTY1YyIsInN1YiI6IjY1ZWYxOWZkZjVjYjIxMDE2MjQ1NjU3NCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.y2RkIboYCWxqVLb1k3fPy9G9t4__0zrk62atLHqNkBk", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "accept")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let credits = try decoder.decode(MovieCredits.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(credits))
                }
            } catch let error {
                completion(.failure(error))
            }
        }.resume()
    }
}




   

