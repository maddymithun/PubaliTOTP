//
//  AllURL.swift
//  PubaliAuthenticator
//
//  Created by pblsdd-mac3 on 27/3/24.
//

import Foundation
class AllURL{
    static var BASE_URL : String = "http://172.25.22.19/picbtotp"
    
    static let  FM_DETAILS : String =  BASE_URL+"/CBBaseRouter/v1/portable"
    static let  ENCKEY : String =  "tuqwojtweo5784306749ghl"
    static let specificKeyHex = "00112233445566778899aabbccddeeff00112233445566778899aabbccddeeff"
    static let specificIvHex = "00112233445566778899aabbccddeeff" 
}

