import SwiftUI

struct CountryRowView: View {
    let country: Country
    
    var body: some View {
        HStack(spacing: 12) {
            Text(country.flag)
                .font(.title)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(country.name)
                    .font(.headline)
                Text("\(country.stationCount) stations")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }
}
