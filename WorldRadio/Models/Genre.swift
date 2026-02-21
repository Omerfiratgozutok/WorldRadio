struct Genre: Identifiable, Hashable {
    let id: String
    let name: String
    
    static let all: [Genre] = [
        Genre(id: "pop", name: "Pop"),
        Genre(id: "rock", name: "Rock"),
        Genre(id: "jazz", name: "Jazz"),
        Genre(id: "classical", name: "Classical"),
        Genre(id: "electronic", name: "Electronic"),
        Genre(id: "news", name: "News"),
        Genre(id: "talk", name: "Talk"),
        Genre(id: "sports", name: "Sports"),
        Genre(id: "hiphop", name: "Hip Hop"),
        Genre(id: "country", name: "Country"),
        Genre(id: "latin", name: "Latin"),
        Genre(id: "world", name: "World"),
        Genre(id: "ambient", name: "Ambient"),
        Genre(id: "reggae", name: "Reggae"),
        Genre(id: "blues", name: "Blues")
    ]
}
