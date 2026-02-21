import Foundation

struct Station: Identifiable, Codable, Hashable {
    var id: String
    var name: String
    var url: String
    var urlResolved: String?
    var favicon: String?
    var country: String
    var countryCode: String
    var state: String?
    var language: String?
    var tags: String?
    var codec: String?
    var bitrate: Int?
    var votes: Int?
    var clickCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "stationuuid"
        case name
        case url
        case urlResolved = "url_resolved"
        case favicon
        case country
        case countryCode = "countrycode"
        case state
        case language
        case tags
        case codec
        case bitrate
        case votes
        case clickCount = "clickcount"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? "Unknown"
        url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
        urlResolved = try container.decodeIfPresent(String.self, forKey: .urlResolved)
        favicon = try container.decodeIfPresent(String.self, forKey: .favicon)
        country = try container.decodeIfPresent(String.self, forKey: .country) ?? ""
        countryCode = try container.decodeIfPresent(String.self, forKey: .countryCode) ?? ""
        state = try container.decodeIfPresent(String.self, forKey: .state)
        language = try container.decodeIfPresent(String.self, forKey: .language)
        tags = try container.decodeIfPresent(String.self, forKey: .tags)
        codec = try container.decodeIfPresent(String.self, forKey: .codec)
        bitrate = try container.decodeIfPresent(Int.self, forKey: .bitrate)
        votes = try container.decodeIfPresent(Int.self, forKey: .votes)
        clickCount = try container.decodeIfPresent(Int.self, forKey: .clickCount)
    }
    
    init(id: String, name: String, url: String, urlResolved: String? = nil, favicon: String? = nil, 
         country: String, countryCode: String, state: String? = nil, language: String? = nil, 
         tags: String? = nil, codec: String? = nil, bitrate: Int? = nil, votes: Int? = nil, clickCount: Int? = nil) {
        self.id = id
        self.name = name
        self.url = url
        self.urlResolved = urlResolved
        self.favicon = favicon
        self.country = country
        self.countryCode = countryCode
        self.state = state
        self.language = language
        self.tags = tags
        self.codec = codec
        self.bitrate = bitrate
        self.votes = votes
        self.clickCount = clickCount
    }
    
    var streamURL: URL? {
        let urlString = urlResolved ?? url
        guard !urlString.isEmpty else { return nil }
        return URL(string: urlString)
    }
    
    var faviconURL: URL? {
        guard let urlString = favicon, !urlString.isEmpty else { return nil }
        return URL(string: urlString)
    }
    
    var tagsArray: [String] {
        tags?.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) } ?? []
    }
}
