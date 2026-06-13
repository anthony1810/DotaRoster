public extension Hero {
    static func mock(
        id: Int = 1,
        slug: String = "antimage",
        localizedName: String = "Anti-Mage",
        primaryAttr: PrimaryAttribute = .agility,
        attackType: String = "Melee",
        roles: [String] = ["Carry", "Escape", "Nuker"]
    ) -> Hero {
        Hero(
            id: id,
            slug: slug,
            localizedName: localizedName,
            primaryAttr: primaryAttr,
            attackType: attackType,
            roles: roles
        )
    }

    static var mocks: [Hero] {
        [
            .mock(id: 1, slug: "antimage", localizedName: "Anti-Mage", primaryAttr: .agility),
            .mock(id: 2, slug: "axe", localizedName: "Axe", primaryAttr: .strength, roles: ["Initiator", "Durable"]),
            .mock(id: 5, slug: "crystal_maiden", localizedName: "Crystal Maiden", primaryAttr: .intelligence, roles: ["Support", "Disabler"])
        ]
    }
}
