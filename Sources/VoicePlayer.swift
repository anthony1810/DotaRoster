import AVFoundation
import Foundation

@Observable
@MainActor
final class VoicePlayer {
    private(set) var isSpeaking = false

    private let synthesizer = AVSpeechSynthesizer()
    private var player: AVPlayer?
    private let delegate = SpeechDelegate()

    init() {
        synthesizer.delegate = delegate
        delegate.onFinish = { [weak self] in self?.isSpeaking = false }
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
}

private final class SpeechDelegate: NSObject, AVSpeechSynthesizerDelegate {
    var onFinish: (() -> Void)?

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        Task { @MainActor in self.onFinish?() }
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        Task { @MainActor in self.onFinish?() }
    }
}
