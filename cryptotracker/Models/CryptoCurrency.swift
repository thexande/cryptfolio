//
//  CryptoCurrency.swift
//  cryptotracker
//
//  Created by Alexander Murphy on 11/24/17.
//  Copyright © 2017 Alexander Murphy. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class RealmCryptoCurrency: Object {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var symbol = ""
    @objc dynamic var rank = 0
    @objc dynamic var dollarPrice = 0.0
    @objc dynamic var bitcoinPrice = 0.0
    @objc dynamic var twentyFourHourVolumeUsd = 0.0
    @objc dynamic var marketCapUsd = 0.0
    @objc dynamic var availableSupply = 0.0
    @objc dynamic var totalSupply = 0.0
    @objc dynamic var maxSupply = 0.0
    @objc dynamic var percentChangeOneHour = 0.0
    @objc dynamic var percentChangeTwentyFourHour = 0.0
    @objc dynamic var percentChangeSevenDays = 0.0
    @objc dynamic var lastUpdated = ""
    @objc dynamic var iconUrl = ""
    @objc dynamic var currencyDescription = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}


struct CryptoWorldInformation: Codable {
    let totalMarketCapUsd: Float
    let totalTwentyFourHourVolumeUsd: Float
    let bitcoinPercentageOfMarketCap: Float
    
    enum CodingKeys: String, CodingKey {
        case totalMarketCapUsd = "total_market_cap_usd"
        case bitcoinPercentageOfMarketCap = "bitcoin_percentage_of_market_cap"
        case totalTwentyFourHourVolumeUsd = "total_24h_volume_usd"
    }
}

struct CryptoCurrency: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case rank
        case priceUsd = "price_usd"
        case priceBtc = "price_btc"
        case twentyFourHourVolumeUsd = "24h_volume_usd"
        case marketCapUsd = "market_cap_usd"
        case availableSupply = "available_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case percentChangeOneHour = "percent_change_1h"
        case percentChangeTwentyFourHour = "percent_change_24h"
        case percentChangeSevenDays = "percent_change_7d"
        case lastUpdated = "last_updated"
    }
    
    let id: String
    let name: String
    let symbol: String
    let rank: String
    let priceUsd: String
    let priceBtc: String
    let twentyFourHourVolumeUsd: String
    let marketCapUsd: String
    let availableSupply: String
    let totalSupply: String
    let maxSupply: String?
    let percentChangeOneHour: String
    let percentChangeTwentyFourHour: String
    let percentChangeSevenDays: String?
    let lastUpdated: String
}
