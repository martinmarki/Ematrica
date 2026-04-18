//
//  CountySelectionViewModel.swift
//  Ematrica

import Foundation

@Observable
@MainActor
final class CountySelectionViewModel {
    private let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }

    var counties: [County] = []
    var vehicle: VehicleInfoResponse?
    var countyVignette: HighwayVignette?
    var selectedIDs: Set<String> = []
    var isLoading = false
    var errorMessage: String?

    var selectedCounties: [County] {
        counties.filter { selectedIDs.contains($0.id) }
    }

    var totalAmount: Int {
        selectedIDs.count * Int(countyVignette?.cost ?? 0)
    }

    var isSelectionConnected: Bool {
        guard selectedIDs.count > 1, let start = selectedIDs.first else { return true }
        var visited: Set<String> = [start]
        var queue = [start]
        while !queue.isEmpty {
            let current = queue.removeFirst()
            for neighbor in countyNeighborhood[current] ?? [] where selectedIDs.contains(neighbor) && !visited.contains(neighbor) {
                visited.insert(neighbor)
                queue.append(neighbor)
            }
        }

        return visited == selectedIDs
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            async let vehicleResult = apiService.getVehicleInfo()
            async let infoResult = apiService.getHighwayInfo()
            vehicle = try await vehicleResult
            let info = try await infoResult
            counties = info.payload.counties
            countyVignette = info.payload.highwayVignettes.first { $0.vignetteType.contains { $0.hasPrefix("YEAR_") } }
        } catch {
            errorMessage = error.localizedDescription
        }
    }


    private let countyNeighborhood: [String: Set<String>] = [
        // Bács-Kiskun
        "YEAR_11": ["YEAR_23", "YEAR_16", "YEAR_26", "YEAR_15", "YEAR_20"],
        // Baranya
        "YEAR_12": ["YEAR_24", "YEAR_26"],
        // Békés
        "YEAR_13": ["YEAR_15", "YEAR_20", "YEAR_18"],
        // Borsod-Abaúj-Zemplén
        "YEAR_14": ["YEAR_25", "YEAR_18", "YEAR_20", "YEAR_19", "YEAR_22"],
        // Csongrád
        "YEAR_15": ["YEAR_11", "YEAR_13", "YEAR_20"],
        // Fejér
        "YEAR_16": ["YEAR_23", "YEAR_21", "YEAR_28", "YEAR_24", "YEAR_26", "YEAR_11"],
        // Győr-Moson-Sopron
        "YEAR_17": ["YEAR_21", "YEAR_28", "YEAR_27"],
        // Hajdú-Bihar
        "YEAR_18": ["YEAR_25", "YEAR_14", "YEAR_20", "YEAR_13"],
        // Heves
        "YEAR_19": ["YEAR_14", "YEAR_20", "YEAR_23", "YEAR_22"],
        // Jász-Nagykun-Szolnok
        "YEAR_20": ["YEAR_19", "YEAR_23", "YEAR_11", "YEAR_15", "YEAR_13", "YEAR_18", "YEAR_14"],
        // Komárom-Esztergom
        "YEAR_21": ["YEAR_17", "YEAR_28", "YEAR_16", "YEAR_23", "YEAR_22"],
        // Nógrád
        "YEAR_22": ["YEAR_23", "YEAR_19", "YEAR_14", "YEAR_21"],
        // Pest
        "YEAR_23": ["YEAR_22", "YEAR_19", "YEAR_20", "YEAR_11", "YEAR_16", "YEAR_21"],
        // Somogy
        "YEAR_24": ["YEAR_12", "YEAR_26", "YEAR_16", "YEAR_28", "YEAR_29"],
        // Szabolcs-Szatmár-Bereg
        "YEAR_25": ["YEAR_14", "YEAR_18"],
        // Tolna
        "YEAR_26": ["YEAR_12", "YEAR_11", "YEAR_16", "YEAR_24"],
        // Vas
        "YEAR_27": ["YEAR_17", "YEAR_29", "YEAR_28"],
        // Veszprém
        "YEAR_28": ["YEAR_17", "YEAR_21", "YEAR_16", "YEAR_24", "YEAR_29", "YEAR_27"],
        // Zala
        "YEAR_29": ["YEAR_27", "YEAR_28", "YEAR_24"],
    ]
}
