//
//  String+Extension.swift
//  Ematrica
//
//  Created by Martin on 2026. 04. 15..
//

import Foundation

extension String {
    var vignetteDisplayName: String {
        switch self {
        case "DAY":   return "D1 - napi (1 napos)"
        case "WEEK":  return "D1 - heti (10 napos)"
        case "MONTH": return "D1 - havi"
        default:      return self
        }
    }
}
