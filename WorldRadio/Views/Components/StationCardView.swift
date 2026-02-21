import SwiftUI

struct StationCardView: View {
    let station: Station
    let onPlay: () -> Void
    
    var body: some View {
        Button(action: onPlay) {
            VStack(alignment: .leading, spacing: 8) {
                AsyncImage(url: URL(string: station.favicon ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Image(systemName: "radio")
                        .font(.title)
                        .foregroundStyle(.secondary)
                }
                .frame(width: 140, height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Text(station.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(2)
                    .frame(width: 140, alignment: .leading)
                
                Text(station.country)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .buttonStyle(.plain)
    }
}
