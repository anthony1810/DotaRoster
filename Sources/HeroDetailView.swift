import SwiftUI

struct HeroDetailView: View {
    let hero: Hero

    @State private var player = VoicePlayer()
    @State private var lines: [HeroLine] = []
    @State private var spoken: HeroLine?
    @State private var index = 0

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                portrait
                attributes
                quoteBubble
                speakButton
                lineList
            }
            .padding()
        }
        .navigationTitle(hero.localizedName)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { lines = HeroLines.lines(for: hero) }
        .onDisappear { player.stop() }
    }

    private var portrait: some View {
        AsyncImage(url: hero.portraitURL) { image in
            image.resizable().scaledToFit()
        } placeholder: {
            Rectangle().fill(.quaternary)
        }
        .frame(height: 130)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(hero.attributeTint.color, lineWidth: 3)
        )
    }

    private var attributes: some View {
        HStack(spacing: 8) {
            Label(hero.attributeLabel, systemImage: "bolt.fill")
                .foregroundStyle(hero.attributeTint.color)
            Text("·")
            Text(hero.attackType)
        }
        .font(.subheadline)
        .foregroundStyle(.secondary)
    }

    private var quoteBubble: some View {
        Text(spoken?.text ?? "Tap below to hear \(hero.localizedName) speak.")
            .font(.title3)
            .italic()
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, minHeight: 70)
            .padding()
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }

    private var speakButton: some View {
        Button {
            speakNext()
        } label: {
            Label(player.isSpeaking ? "Speaking…" : "Say a line",
                  systemImage: player.isSpeaking ? "waveform" : "speaker.wave.2.fill")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .tint(hero.attributeTint.color)
    }

    private var lineList: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("All lines")
                .font(.headline)
            ForEach(lines) { line in
                Button {
                    speak(line)
                } label: {
                    HStack {
                        Image(systemName: "quote.opening")
                            .foregroundStyle(.secondary)
                        Text(line.text)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .padding(.vertical, 6)
                }
                .buttonStyle(.plain)
                Divider()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func speakNext() {
        guard !lines.isEmpty else { return }
        let line = lines[index % lines.count]
        index += 1
        speak(line)
    }

    private func speak(_ line: HeroLine) {
        spoken = line
        player.speak(line, heroSeed: hero.id)
    }
}
