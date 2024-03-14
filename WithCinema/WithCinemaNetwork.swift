import Foundation

class MovieService {
    func fetchMovies(completion: @escaping ([Movie]?, Error?) -> Void) {
        let headers = [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5YTUzZWEzYTMzY2VjYmJhYjg4NmNkMWVmN2MwNTY1YyIsInN1YiI6IjY1ZWYxOWZkZjVjYjIxMDE2MjQ1NjU3NCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.y2RkIboYCWxqVLb1k3fPy9G9t4__0zrk62atLHqNkBk"
        ]
        
        guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc") else {
            completion(nil, nil) // Handle invalid URL
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error) // Handle error scenario
                return
            }
            
            guard let data = data else {
                completion(nil, nil) // Handle no data scenario
                return
            }
            
            do {
                // Customize the JSONDecoder instance to support snake_case to camelCase conversion
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                // Decode the JSON response into our Swift model using the customized decoder
                let decodedResponse = try decoder.decode(ApiResponse.self, from: data)
                completion(decodedResponse.results, nil)
            } catch let jsonError {
                completion(nil, jsonError) // Handle JSON decoding error
            }
        }
        
        dataTask.resume() // Start the network request
    }
}
