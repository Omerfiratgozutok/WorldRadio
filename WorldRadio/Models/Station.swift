struct Station: Identifiable, Codable, Hashable {
    let id: String  // stationuuid
    let name: String
    let url: String
    let urlResolved: String?
    let favicon: String?
    let country: String
    let countryCode: String
    let state: String?
    let language: String?
    let tags: String?
    let codec: String?
    let bitrate: Int?
    let votes: Int?
    let clickCount: Int?
    
    var streamURL: URL? {
        URL(string: urlResolved ?? url)
    }
    
    var tagsArray: [String] {
        tags?.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) } ?? []
    }
}
