//
// UserLinks.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation


public struct UserLinks: Codable {

    public var _self: String?

    public init(_self: String? = nil) {
        self._self = _self
    }

    public enum CodingKeys: String, CodingKey, CaseIterable { 
        case _self = "self"
    }

}
