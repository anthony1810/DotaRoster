import AVFoundation
import Foundation

@Observable
@MainActor
final class VoicePlayer: NSObject, AVSpeechSynthesizerDelegate {
    private(set) var isSpeaking = false

    private let synthesizer = AVSpeechSynthesizer()
    private var player: AVPlayer?

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func speak(_ line: HeroLine, heroSeed: Int) {
        stop()
        if let url = line.audioURL {
            playRemote(url)
        } else {
            speakSynthesized(line.text, heroSeed: heroSeed)
        }
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        player?.pause()
        player = nil
        isSpeaking = false
    }

    private func speakSynthesized(_ text: String, heroSeed: Int) {
        configureSession()
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.46
        utterance.pitchMultiplier = 0.75 + Float(heroSeed % 6) * 0.1
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        isSpeaking = true
        synthesizer.speak(utterance)
    }

    private func playRemote(_ url: URL) {
        configureSession()
        let item = AVPlayerItem(url: url)
        let player = AVPlayer(playerItem: item)
        self.player = player
        isSpeaking = true
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: item,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in self?.isSpeaking = false }
        }
        player.play()
    }

    private func configureSession() {
        #if os(iOS)
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback, mode: .default)
        try? session.setActive(true)
        #endif
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        Task { @MainActor in self.isSpeaking = false }
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        Task { @MainActor in self.isSpeaking = false }
    }
}
