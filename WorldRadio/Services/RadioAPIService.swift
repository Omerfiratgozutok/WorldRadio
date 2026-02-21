import Foundation

actor RadioAPIService {
    static let shared = RadioAPIService()
    
    private let baseURL = "https://de1.api.radio-browser.info/json"
    private let headers = ["User-Agent": "WorldRadio/1.0"]
    
    private init() {}
    
    func fetchCountries() async throws -> [Country] {
        let url = URL(string: "\(baseURL)/countries")!
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let rawCountries = try JSONDecoder().decode([RawCountry].self, from: data)
        
        return rawCountries
            .filter { $0.iso3166_1.count == 2 }
            .map { Country(id: $0.iso3166_1, name: $0.name, stationCount: $0.stationcount) }
            .sorted { $0.name < $1.name }
    }
    
    func fetchStations(byCountry countryCode: String, limit: Int = 100) async throws -> [Station] {
        let encoded = countryCode.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? countryCode
        let url = URL(string: "\(baseURL)/stations/bycountrycodeexact/\(encoded)?limit=\(limit)&order=votes&reverse=true")!
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode([Station].self, from: data)
    }
    
    func searchStations(query: String, limit: Int = 50) async throws -> [Station] {
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let url = URL(string: "\(baseURL)/stations/byname/\(encoded)?limit=\(limit)&order=votes&reverse=true")!
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode([Station].self, from: data)
    }
    
    func fetchStations(byTag tag: String, limit: Int = 100) async throws -> [Station] {
        let encoded = tag.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? tag
        let url = URL(string: "\(baseURL)/stations/bytag/\(encoded)?limit=\(limit)&order=votes&reverse=true")!
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode([Station].self, from: data)
    }
    
    func fetchTopStations(limit: Int = 100) async throws -> [Station] {
        let url = URL(string: "\(baseURL)/stations/topvote/\(limit)")!
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode([Station].self, from: data)
    }
    
    func recordStationClick(stationUUID: String) async {
        let url = URL(string: "\(baseURL)/url/\(stationUUID)")!
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        _ = try? await URLSession.shared.data(for: request)
    }
}

private struct RawCountry: Codable {
    let iso3166_1: String
    let name: String
    let stationcount: Int
}
