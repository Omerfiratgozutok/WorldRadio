struct Country: Identifiable, Hashable {
    let id: String  // ISO country code
    let name: String
    let stationCount: Int
    
    var flag: String {
        let base: UInt32 = 127397
        var flag = ""
        for scalar in id.uppercased().unicodeScalars {
            if let unicode = UnicodeScalar(base + scalar.value) {
                flag.append(String(unicode))
            }
        }
        return flag
    }
}
