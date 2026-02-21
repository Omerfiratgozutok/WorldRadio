import SwiftUI

struct StationRowView: View {
    let station: Station
    let onPlay: () -> Void
    
    var body: some View {
        Button(action: onPlay) {
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: station.favicon ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Image(systemName: "radio")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(station.name)
                        .font(.headline)
                        .lineLimit(1)
                    
                    HStack(spacing: 8) {
                        Text(station.country)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        if let bitrate = station.bitrate, bitrate > 0 {
                            Text("\(bitrate) kbps")
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                        }
                    }
                }
                
                Spacer()
                
                Image(systemName: "play.circle.fill")
                    .font(.title)
                    .foregroundStyle(.blue)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }
}
