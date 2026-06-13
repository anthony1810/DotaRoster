public protocol VoicePlaying: Sendable {
    func speak(_ line: HeroLine, seed: Int) async
    func stop() async
}
