import Foundation

@Observable
@MainActor
final class HeroStore {
    enum LoadState {
        case idle, loading, loaded([Hero]), failed(String)
    }

    private(set) var state: LoadState = .idle

    private let loader: HeroLoading

    init(loader: HeroLoading = OpenDotaClient()) {
        self.loader = loader
    }

    func load() async {
        if case .loading = state { return }
        if case .loaded = state { return }
        state = .loading
        do {
            let heroes = try await loader.loadHeroes()
            state = .loaded(heroes)
        } catch {
            state = .failed(error.localizedDescription)
        }
    }

    func reload() async {
        state = .idle
        await load()
    }
}
