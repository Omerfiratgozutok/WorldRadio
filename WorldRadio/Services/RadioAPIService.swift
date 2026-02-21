import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(Error)
    case networkError(Error)
    case allServersFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let statusCode):
            return "HTTP error: \(statusCode)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .allServersFailed:
            return "All servers failed. Please check your internet connection."
        }
    }
}

actor RadioAPIService {
    static let shared = RadioAPIService()
    
    private let servers = [
        "https://de1.api.radio-browser.info/json",
        "https://at1.api.radio-browser.info/json", 
        "https://nl1.api.radio-browser.info/json",
        "https://fr1.api.radio-browser.info/json",
        "https://radio-browser.gaetan.info/json",
        "https://api.radio-browser.info/json"
    ]
    
    private var currentServerIndex = 0
    
    private var baseURL: String {
        servers[currentServerIndex]
    }
    
    private let headers = ["User-Agent": "WorldRadio/1.0 (iOS App; https://github.com/barancanercan/WorldRadio)"]
    
    private init() {}
    
    private func performRequest<T: Decodable>(_ urlRequest: URLRequest, attempt: Int = 0) async throws -> T {
        let serverURL = servers[attempt % servers.count]
        
        var modifiedRequest = urlRequest
        if let originalURL = urlRequest.url {
            let path = originalURL.path
            let query = originalURL.query ?? ""
            let newURLString = "\(serverURL)\(path)" + (query.isEmpty ? "" : "?\(query)")
            if let newURL = URL(string: newURLString) {
                modifiedRequest = URLRequest(url: newURL)
                modifiedRequest.allHTTPHeaderFields = urlRequest.allHTTPHeaderFields
            }
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: modifiedRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                if attempt < servers.count - 1 {
                    return try await performRequest(urlRequest, attempt: attempt + 1)
                }
                throw APIError.httpError(statusCode: httpResponse.statusCode)
            }
            
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw APIError.decodingError(error)
            }
        } catch let error as APIError {
            if attempt < servers.count - 1 {
                try await Task.sleep(nanoseconds: 500_000_000)
                return try await performRequest(urlRequest, attempt: attempt + 1)
            }
            throw error
        } catch {
            if attempt < servers.count - 1 {
                try await Task.sleep(nanoseconds: 500_000_000)
                return try await performRequest(urlRequest, attempt: attempt + 1)
            }
            if let urlError = error as? URLError {
                throw APIError.networkError(urlError)
            }
            throw APIError.networkError(error)
        }
    }
    
    func fetchCountries() async throws -> [Country] {
        guard let url = URL(string: "\(baseURL)/countries") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.timeoutInterval = 30
        
        let rawCountries: [RawCountry] = try await performRequest(request)
        
        return rawCountries
            .filter { $0.iso3166_1.count == 2 && $0.stationcount > 10 }
            .map { Country(id: $0.iso3166_1, name: $0.name, stationCount: $0.stationcount) }
            .sorted { $0.stationCount > $1.stationCount }
    }
    
    func fetchStations(byCountry countryCode: String, limit: Int = 100) async throws -> [Station] {
        let encoded = countryCode.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? countryCode
        guard let url = URL(string: "\(baseURL)/stations/bycountrycodeexact/\(encoded)?limit=\(limit)&order=votes&reverse=true&hidebroken=true") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.timeoutInterval = 30
        
        return try await performRequest(request)
    }
    
    func searchStations(query: String, limit: Int = 50) async throws -> [Station] {
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        guard let url = URL(string: "\(baseURL)/stations/byname/\(encoded)?limit=\(limit)&order=votes&reverse=true&hidebroken=true") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.timeoutInterval = 30
        
        return try await performRequest(request)
    }
    
    func fetchStations(byTag tag: String, limit: Int = 100) async throws -> [Station] {
        let encoded = tag.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? tag
        guard let url = URL(string: "\(baseURL)/stations/bytag/\(encoded)?limit=\(limit)&order=votes&reverse=true&hidebroken=true") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.timeoutInterval = 30
        
        return try await performRequest(request)
    }
    
    func fetchTopStations(limit: Int = 100) async throws -> [Station] {
        guard let url = URL(string: "\(baseURL)/stations/topvote/\(limit)?hidebroken=true") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.timeoutInterval = 30
        
        return try await performRequest(request)
    }
    
    func recordStationClick(stationUUID: String) async throws {
        let encoded = stationUUID.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? stationUUID
        guard let url = URL(string: "\(baseURL)/url/\(encoded)") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }
    }
}

private struct RawCountry: Codable {
    let iso3166_1: String
    let name: String
    let stationcount: Int
}
