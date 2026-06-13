import Testing
import Foundation
import DotaFoundation
import OpenDotaAPI

struct HeroMapperTests {
    @Test func map_on200_deliversHeroesWithStrippedSlug() throws {
        let data = try fixtureData(named: "heroes_200")

        let heroes = try HeroMapper.map(data, response: makeHTTPResponse(statusCode: 200))

        #expect(heroes.count == 4)
        #expect(heroes[0].id == 1)
        #expect(heroes[0].slug == "antimage")
        #expect(heroes[0].localizedName == "Anti-Mage")
        #expect(heroes[0].attackType == "Melee")
        #expect(heroes[0].roles == ["Carry", "Escape", "Nuker"])
    }

    @Test func map_mapsPrimaryAttributeCodes() throws {
        let data = try fixtureData(named: "heroes_200")

        let heroes = try HeroMapper.map(data, response: makeHTTPResponse(statusCode: 200))

        #expect(heroes[0].primaryAttr == .agility)
        #expect(heroes[1].primaryAttr == .strength)
        #expect(heroes[2].primaryAttr == .intelligence)
        #expect(heroes[3].primaryAttr == .universal)
    }

    @Test func map_non200_throwsInvalidResponse() throws {
        let data = try fixtureData(named: "heroes_200")

        #expect(throws: HeroMapper.Error.invalidResponse) {
            try HeroMapper.map(data, response: makeHTTPResponse(statusCode: 500))
        }
    }

    @Test func map_invalidJSON_throwsInvalidJSON() {
        let data = Data("not json".utf8)

        #expect(throws: HeroMapper.Error.invalidJSON) {
            try HeroMapper.map(data, response: makeHTTPResponse(statusCode: 200))
        }
    }
}
