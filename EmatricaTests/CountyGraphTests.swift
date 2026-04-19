//
//  EmatricaTests.swift
//  EmatricaTests
//
//  Created by Martin on 2026. 04. 14..
//

import Testing
@testable import Ematrica

@Suite struct CountyGraphTests {

    @Test("Empty selection is connected")
    func emptySelectionIsConnected() {
        #expect(CountyGraph().isConnected([]))
    }

    @Test("Single county is connected")
    func singleCountyIsConnected() {
        #expect(CountyGraph().isConnected(["YEAR_11"]))
    }

    @Test("Connected — Bács-Kiskun and Pest")
    func adjacentPairIsConnected() {
        #expect(CountyGraph().isConnected(["YEAR_11", "YEAR_23"]))
    }

    @Test("Connected — Baranya and Somogy")
    func anotherAdjacentPairIsConnected() {
        #expect(CountyGraph().isConnected(["YEAR_12", "YEAR_24"]))
    }

    @Test("Not connected — Bács-Kiskun and Baranya")
    func nonAdjacentPairIsNotConnected() {
        #expect(!CountyGraph().isConnected(["YEAR_11", "YEAR_12"]))
    }

    @Test("Not connected — Győr-Moson-Sopron and Szabolcs")
    func distantCountiesAreNotConnected() {
        #expect(!CountyGraph().isConnected(["YEAR_17", "YEAR_25"]))
    }

    @Test("Connected — Baranya, Tolna, and Bács-Kiskun")
    func chainOfThreeIsConnected() {
        #expect(CountyGraph().isConnected(["YEAR_12", "YEAR_26", "YEAR_11"]))
    }

    @Test("Connected — Győr, Vas, Veszprém, and Zala")
    func westernClusterIsConnected() {
        #expect(CountyGraph().isConnected(["YEAR_17", "YEAR_27", "YEAR_28", "YEAR_29"]))
    }

    @Test("Connected pair plus isolated county is not connected — Baranya has no border with Bács-Kiskun or Pest")
    func connectedPairPlusIsolatedIsNotConnected() {
        #expect(!CountyGraph().isConnected(["YEAR_11", "YEAR_23", "YEAR_12"]))
    }

    @Test("Two separate pairs with no link are not connected")
    func twoPairsWithNoLinkAreNotConnected() {
        #expect(!CountyGraph().isConnected(["YEAR_17", "YEAR_27", "YEAR_25", "YEAR_14"]))
    }
}
