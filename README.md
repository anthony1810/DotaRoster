# DotaRoster

A Dota 2 hero browser for iOS — browse every hero, see their info, and tap to hear their voice lines. Built as the **reference sample app for [ScreenStateKit](https://github.com/anthony1810/ScreenStateKit)**, demonstrating the *Three Pillars* state pattern inside a modular, protocol-driven clean architecture.

> This project supersedes **Definery** as the canonical ScreenStateKit example. Where Definery splits packages per entity, DotaRoster mirrors the richer **OnDeck** layout: a single `DotaFoundation` core, role-based infrastructure packages, feature-as-package modules, and `pointfreeco/Dependencies` for dependency injection.

## Status

Early WIP. A working single-file SwiftUI proof-of-concept lives in `Sources/`; the modular package structure (`Modules/`) is scaffolded and the app builds on top of it. The codebase is being migrated layer-by-layer into the packages (see [Roadmap](#roadmap)).

- ✅ **Phase 0** — modular project structure, package graph, checked-in `.xcodeproj`, DI via swift-dependencies.
- ⏳ **Phase 1+** — migrate the POC into `DotaFoundation` → `OpenDotaAPI` → cache → features (TDD).

## Tech stack

- **iOS 17+ / macOS 14+**, SwiftUI, Swift 5.9, Swift Concurrency (actors, async/await), strict-concurrency-friendly.
- **State management:** [ScreenStateKit](https://github.com/anthony1810/ScreenStateKit) — `ScreenState` + `ScreenActionStore` + `ActionLocker`.
- **DI:** [pointfreeco/swift-dependencies](https://github.com/pointfreeco/swift-dependencies).
- **Persistence:** SwiftData (offline-first hero cache).
- **Testing:** Swift Testing, [swift-concurrency-extras](https://github.com/pointfreeco/swift-concurrency-extras) (`LockIsolated` spies), [swift-snapshot-testing](https://github.com/pointfreeco/swift-snapshot-testing), [swift-clocks](https://github.com/pointfreeco/swift-clocks).

## Architecture

DotaRoster is split into small Swift packages, each with one job. **The governing rule: all dependencies point inward to `DotaFoundation`.** Features and infrastructure are *siblings that never import each other* — a feature depends on a **protocol**, and only the app's composition root knows the concrete implementation. That inversion is what makes features testable without a network or database, infrastructure swappable, and packages buildable in isolation.

```
                 ┌─────────────────────────────────────────────┐
                 │  DotaRoster (app) · Composer/                │  ← composition root:
                 │  DI keys, liveValue/testValue, App.swift     │    the ONLY place that
                 └─────────────────────────────────────────────┘    knows both sides
                                      │ wires (composition)
                                      ▼
        ┌───────────────────────────────────────────────────────────────┐
        │  DotaFeature  (meta-feature: tab / navigation host, no logic)   │
        │   ┌─────────────────────┐   ┌──────────────────────┐            │
        │   │   HeroListFeature   │   │   HeroDetailFeature   │  Features  │
        │   │ State·Store·View    │   │ State·Store·View      │            │
        │   └─────────────────────┘   └──────────────────────┘            │
        └───────────────────────────────────────────────────────────────┘
                                      │ depend on models & PROTOCOLS
                                      ▼
        ┌───────────────────────────────────────────────────────────────┐
        │  DotaFoundation  — the Core                                     │
        │  ALL domain models (Hero, Ability, HeroLine, HeroStats)         │
        │  + ALL service protocols (HeroLoaderProtocol, …, VoicePlaying)  │
        │  depends on nothing                                             │
        └───────────────────────────────────────────────────────────────┘
                                      ▲ IMPLEMENT those protocols
                                      │
   ┌──────────────┬──────────────────┴───────────┬────────────────────────┐
   │ OpenDotaAPI  │  DotaConstantsAPI             │ HeroCacheInfrastructure │ VoiceInfrastructure
   │ RemoteHero   │  abilities / patch notes      │ SwiftData store         │ SystemVoicePlayer
   │ Loader, …    │  (raw dotaconstants JSON)     │ (offline-first)         │ (AVSpeech + AVPlayer)
   └──────────────┴──────────────────────────────┴─────────────────────────┘
                              Infrastructure (concrete implementations)
```

### Packages

| Package | Layer | Role |
|---|---|---|
| **DotaFoundation** | Core | Shared vocabulary — all domain models + all service protocols. Zero outward dependencies. |
| **OpenDotaAPI** | Infrastructure | HTTP loaders for `api.opendota.com` (heroes, stats). |
| **DotaConstantsAPI** | Infrastructure | Loaders for abilities + patch notes (raw `odota/dotaconstants` JSON). |
| **HeroCacheInfrastructure** | Infrastructure | SwiftData persistence → offline-first hero list. |
| **VoiceInfrastructure** | Infrastructure | Device service that speaks hero lines (TTS now; bundled/remote audio later). |
| **HeroListFeature** | Feature | The hero grid — `HeroListState` / `HeroListStore` / `HeroListSUView`. |
| **HeroDetailFeature** | Feature | Hero detail + voice — `HeroDetailState` / `HeroDetailStore` / `HeroDetailSUView`. |
| **DotaFeature** | Meta-feature | Hosts the features in tabs / navigation. No business logic. |
| **DotaRoster** (app) | Composition root | Binds concrete infra to protocols (DI) and assembles each screen. |

### How a feature is composed

1. **`DotaFoundation`** declares the contract — the domain model + a protocol:
   ```swift
   public protocol HeroLoaderProtocol: Sendable { func loadHeroes() async throws -> [Hero] }
   ```
2. **Infrastructure** fulfills it independently — e.g. `RemoteHeroLoader` (OpenDotaAPI) and `SwiftDataHeroStore` (HeroCacheInfrastructure).
3. **The feature** builds the screen against the *abstraction* — `HeroListStore` holds `any HeroLoaderProtocol` and imports only `DotaFoundation` + `ScreenStateKit`.
4. **The app's Composer** binds the concrete type to the protocol (`HeroLoaderKey.liveValue = RemoteHeroLoader(...)`) and assembles `State + Store + View`.
5. **Tests** swap `liveValue` for a `LockIsolated` spy — the same store runs with no network or DB.

> A "feature" isn't one package — it's the feature package + the `DotaFoundation` protocols it speaks to + the infrastructure that satisfies them, fused by the Composer.

## Data sources

| Purpose | Source | Endpoint |
|---|---|---|
| Hero list + base stats | OpenDota | `api.opendota.com/api/heroes` |
| Win/pick rates | OpenDota | `api.opendota.com/api/heroStats` |
| Hero portraits | Valve CDN | `cdn.cloudflare.steamstatic.com/.../heroes/{slug}.png` |
| Abilities + patch notes | odota/dotaconstants | `raw.githubusercontent.com/odota/dotaconstants/master/build/*.json` |

Voice lines are currently spoken via on-device text-to-speech; the model carries an `audioURL` seam for real audio once a hostable source is available.

> ⚠️ Hero art, voice audio, and ability media are Valve intellectual property — fine for personal/portfolio/learning use, but not for App Store publication.

## Requirements & running

- Xcode 26+, iOS 17+ simulator or device.
- Open `DotaRoster.xcodeproj`, select the **DotaRoster** scheme, and run. Swift Package Manager resolves all dependencies automatically.

## Roadmap

**Refactor (parity with the POC, but layered + tested + offline-first):**
`P0` structure → `P1` DotaFoundation → `P2` OpenDotaAPI → `P3` cache → `P4` voice → `P5` Hero List → `P6` Hero Detail → `P7` composition → `P8` test plans + CI.

**Future features:** Hero skills/abilities · win-rate & pick stats · patch notes ("What's New") · per-hero skill changes · skill demo video & real voice lines.

## Credits

State management by **[ScreenStateKit](https://github.com/anthony1810/ScreenStateKit)**. Hero data from **[OpenDota](https://www.opendota.com/)** and **[odota/dotaconstants](https://github.com/odota/dotaconstants)**. Dota 2 is a trademark of Valve Corporation; this is an unofficial, non-commercial project.
