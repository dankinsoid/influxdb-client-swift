//
// Label.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation


public struct Label: Codable {

    public var id: String?
    public var orgID: String?
    public var name: String?
    /** Key/Value pairs associated with this label. Keys can be removed by sending an update with an empty value. */
    public var properties: [String:String]?

    public init(id: String? = nil, orgID: String? = nil, name: String? = nil, properties: [String:String]? = nil) {
        self.id = id
        self.orgID = orgID
        self.name = name
        self.properties = properties
    }

}
