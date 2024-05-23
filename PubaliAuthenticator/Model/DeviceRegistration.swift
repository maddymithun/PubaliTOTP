//
//  DeviceRegistration.swift
//  PubaliAuthenticator
//
//  Created by pblsdd-mac3 on 27/3/24.
//

import Foundation
struct DeviceRequest: Codable {
    let baseurl: String
    let apiendpoint: String
    let method: String
    let apicode: String
    let headerkeyval: [HeaderKeyVal]
    let bodyobject: BodyObject
}

struct HeaderKeyVal: Codable {
    let headerKey: String
    let headerVal: String
}

struct BodyObject: Codable {
    let email: String
    let mac: String
    let activationcode: String
    let modulename: String
    let product: String
    let platform: String
    let instance: String
    let datasign: String
    let message: String
    let status: String
    let ip: String
    let reqref: String
}

struct ResponseTOTP: Codable {
        let status: String?
        let message: String?
        let instanceid: String?
        let totp: String?
        let email: String?
        let mac: String?// Optional since it's null
        let code: String? // Optional since it's null
        let ip: String?
}
struct ResponseDevice: Codable {
    let status: String // Represents the "status" value, which is a String
    let message: String // Represents the "message" value, which is a String
    let instanceid: String? // Optional because it could be null
    let totp: String? // Optional
    let email: String? // Optional
    let mac: String? // Optional
    let code: String? // Optional
    let ip: String? // Optional
}

struct AccessTokenResponse: Codable {
    let accesstoken: String
    let status: String
    let message: String
    let dev_message: String?
}

struct AccessTokenRequestBody:Codable{
   
        let product: String
        let modulename: String
        let platform: String
        let username: String
        let password: String
        let datasign: String
    }

struct AccessTokenRequest: Codable {
        let baseUrl: String
        let apiEndpoint: String
        let method: String
        let apiCode: String
        let HeaderKeyVal: [HeaderKeyVal]
        let bodyObject: AccessTokenRequestBody
    
}
struct TOTPRequest: Codable {
    let baseurl: String
    let apiendpoint: String
    let method: String
    let apicode: String
    let headerkeyval: [HeaderKeyVal]
    let bodyobject: BodyTOTP
}
struct BodyTOTP: Codable {
    let email: String
    let mac: String
    let modulename: String
    let product: String
    let platform: String
    let instanceid: String
    let datasign: String
    let message: String
    let status: String
    let ip: String
    let reqref: String
}
