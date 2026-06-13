import Foundation

enum HeroLines {
    static func lines(for hero: Hero) -> [HeroLine] {
        let curated = catalog[hero.slug] ?? generic
        return curated.map { HeroLine($0) }
    }

    private static let generic = [
        "For battle!",
        "I am ready.",
        "The enemy approaches.",
        "Victory will be ours.",
        "None shall stand before me."
    ]

    private static let catalog: [String: [String]] = [
        "antimage": [
            "Magic is a crutch.",
            "You should not have provoked me.",
            "Mana void!",
            "The mind controls the body."
        ],
        "juggernaut": [
            "Master Yurnero!",
            "My blade hungers.",
            "How will history remember this?",
            "An honorable death."
        ],
        "pudge": [
            "Fresh meat!",
            "Get over here!",
            "Hooked!",
            "So hungry."
        ],
        "axe": [
            "Axe is here!",
            "Axe happy. Happy Axe!",
            "Feel the chop!",
            "Cowards, all of you!"
        ],
        "lina": [
            "Too hot to handle!",
            "Burn, baby, burn!",
            "Feel the heat.",
            "Light them up!"
        ],
        "crystal_maiden": [
            "Ah, the chill of conflict!",
            "Brace yourself.",
            "Winter is unforgiving.",
            "Freeze!"
        ],
        "sniper": [
            "Just a headshot away.",
            "Kardel Sharpeye, ready to go.",
            "Take the shot.",
            "Right between the eyes."
        ],
        "invoker": [
            "Reality is mine to shape.",
            "Have you any concept of whom you face?",
            "A trifling demonstration.",
            "Behold."
        ],
        "nevermore": [
            "The souls of the dead strengthen me.",
            "Requiem.",
            "Ahh, raze them.",
            "I am the shadow."
        ],
        "phantom_assassin": [
            "Mortred, reporting.",
            "The Black Lotus Order.",
            "A coup de grace.",
            "I never miss the killing blow."
        ],
        "storm_spirit": [
            "I am the storm that is approaching!",
            "Raijin Thunderkeg!",
            "Crackle and boom!",
            "Riding the lightning."
        ],
        "skeleton_king": [
            "I shall return!",
            "All I have, I gladly give to the king. Me!",
            "The reaper waits.",
            "Bow before the Wraith King."
        ],
        "drow_ranger": [
            "Traxex, here.",
            "A flawless shot.",
            "The frost claims you.",
            "Silence is golden."
        ],
        "earthshaker": [
            "The earth will swallow you!",
            "Aftershock!",
            "Tremble before me.",
            "Raise the stakes."
        ]
    ]
}
