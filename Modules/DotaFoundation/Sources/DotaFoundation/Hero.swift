public struct Hero: Identifiable, Hashable, Sendable {
    public let id: Int
    public let slug: String
    public let localizedName: String
    public let primaryAttr: PrimaryAttribute
    public let attackType: String
    public let roles: [String]

    public init(
        id: Int,
        slug: String,
        localizedName: String,
        primaryAttr: PrimaryAttribute,
        attackType: String,
        roles: [String]
    ) {
        self.id = id
        self.slug = slug
        self.localizedName = localizedName
        self.primaryAttr = primaryAttr
        self.attackType = attackType
        self.roles = roles
    }
}
