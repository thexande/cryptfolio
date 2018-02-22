import RealmSwift
import Realm

class RealmCrudHelper {
    static func addRealmObjects(_ objects: [Object]) {
        do {
            let realm = try Realm()
            for object in objects {
                do {
                    try realm.write {
                        realm.add(object, update: true)
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    static func writeCryptos(_ cryptos: [CryptoCurrencyDesctiption]) {
        let realmCryptos: [RealmCryptoCurrency] = cryptos.map { cryptoDescription in
            let realmCrypto = RealmCryptoCurrency()
            realmCrypto.currencyDescription = {
                guard let description = cryptoDescription.description, !description.contains("<") else { return "" }
                return description
            }()
            realmCrypto.id = cryptoDescription.crypto.id
            realmCrypto.name = cryptoDescription.crypto.name
            realmCrypto.symbol = cryptoDescription.crypto.symbol
            realmCrypto.rank = Int(cryptoDescription.crypto.rank) ?? 0
            realmCrypto.dollarPrice = Double(cryptoDescription.crypto.priceUsd) ?? 0
            realmCrypto.bitcoinPrice = Double(cryptoDescription.crypto.priceBtc) ?? 0
            realmCrypto.twentyFourHourVolumeUsd = Double(cryptoDescription.crypto.twentyFourHourVolumeUsd) ?? 0
            realmCrypto.marketCapUsd = Double(cryptoDescription.crypto.marketCapUsd) ?? 0
            realmCrypto.availableSupply = Double(cryptoDescription.crypto.availableSupply) ?? 0
            realmCrypto.totalSupply = Double(cryptoDescription.crypto.totalSupply) ?? 0
            realmCrypto.maxSupply = Double(cryptoDescription.crypto.maxSupply ?? "") ?? 0
            realmCrypto.percentChangeOneHour = Double(cryptoDescription.crypto.percentChangeOneHour) ?? 0
            realmCrypto.percentChangeSevenDays = Double(cryptoDescription.crypto.percentChangeSevenDays ?? "") ?? 0
            realmCrypto.percentChangeTwentyFourHour = Double(cryptoDescription.crypto.percentChangeTwentyFourHour) ?? 0
            realmCrypto.lastUpdated = cryptoDescription.crypto.lastUpdated
            realmCrypto.iconUrl = "https://coincodex.com/en/resources/images/admin/coins/\(cryptoDescription.crypto.name.replacingOccurrences(of: " ", with: "-")).png:resizebox?180x180"
            return realmCrypto
        }
        addRealmObjects(realmCryptos)
    }
}
