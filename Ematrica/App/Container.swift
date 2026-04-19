//
//  Container.swift
//  Ematrica

import Factory

extension Container {
    var apiService: Factory<APIServiceProtocol> {
        self { APIService() }
    }

    var countyGraph: Factory<CountyGraphProtocol> {
        self { CountyGraph() }
    }
}
