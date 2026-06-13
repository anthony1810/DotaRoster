import SwiftUI

struct HeroListView: View {
    @State private var store = HeroStore()
    @State private var query = ""

    private let columns = [GridItem(.adaptive(minimum: 96), spacing: 12)]

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Dota Roster")
                .task { await store.load() }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch store.state {
        case .idle, .loading:
            ProgressView("Summoning heroes…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .failed(let message):
            errorView(message)
        case .loaded(let heroes):
            grid(filtered(heroes))
        }
    }

    private func grid(_ heroes: [Hero]) -> some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(heroes) { hero in
                    NavigationLink(value: hero) {
                        HeroCell(hero: hero)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .searchable(text: $query, prompt: "Search heroes")
        .navigationDestination(for: Hero.self) { hero in
            HeroDetailView(hero: hero)
        }
    }

    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "wifi.exclamationmark")
                .font(.largeTitle)
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            Button("Retry") { Task { await store.reload() } }
                .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func filtered(_ heroes: [Hero]) -> [Hero] {
        guard !query.isEmpty else { return heroes }
        return heroes.filter { $0.localizedName.localizedCaseInsensitiveContains(query) }
    }
}

struct HeroCell: View {
    let hero: Hero

    var body: some View {
        VStack(spacing: 6) {
            AsyncImage(url: hero.portraitURL) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Rectangle().fill(.quaternary)
            }
            .frame(width: 92, height: 52)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(hero.attributeTint.color, lineWidth: 2)
            )

            Text(hero.localizedName)
                .font(.caption2)
                .lineLimit(1)
                .foregroundStyle(.primary)
        }
    }
}

extension AttributeTint {
    var color: Color {
        switch self {
        case .strength: return .red
        case .agility: return .green
        case .intelligence: return .blue
        case .universal: return .purple
        }
    }
}
