import Testing
import OpenDotaAPI

struct OpenDotaEndpointTests {
    @Test func heroes_buildsHeroesURL() {
        #expect(OpenDotaEndpoint.heroes.url.absoluteString == "https://api.opendota.com/api/heroes")
    }

    @Test func heroStats_buildsHeroStatsURL() {
        #expect(OpenDotaEndpoint.heroStats.url.absoluteString == "https://api.opendota.com/api/heroStats")
    }
}
