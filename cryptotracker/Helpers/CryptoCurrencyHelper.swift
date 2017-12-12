import Foundation
import PromiseKit

struct UrlConstants {
    static let coinMarketCapTickerUrl: URL = URL(string: "https://api.coinmarketcap.com/v1/ticker/")!
    static let globalInfoUrl: URL = URL(string: "https://api.coinmarketcap.com/v1/global/")!
}

struct CryptoCurrencyDesctiption {
    let crypto: CryptoCurrency
    let description: String?
}

class CryptoCurrencyHelper {
    static func fetchMarketInformation(url: URL, _ completion: @escaping(CryptoWorldInformation) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            let string1 = String(data: data, encoding: String.Encoding.utf8) ?? "Data could not be printed"
            print(string1)

            do {
                let marketInfo = try JSONDecoder().decode(CryptoWorldInformation.self, from: data)
                completion(marketInfo)
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    static func fetchCryptos(url: URL, _ completion: @escaping([CryptoCurrency]) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let cryptos = try JSONDecoder().decode([CryptoCurrency].self, from: data)
                completion(cryptos)
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    static func fetchDescription(for crypto: CryptoCurrency) -> Promise<CryptoCurrencyDesctiption> {
        return CryptoCurrencyHelper.fetchDescription(for: crypto.symbol).then { description -> CryptoCurrencyDesctiption in
            let cryptoDescription = CryptoCurrencyDesctiption(crypto: crypto, description: description)
            return cryptoDescription
        }
    }
    
    static func fetchDescription(for ticker: String) -> Promise<String?> {
        return Promise { resolve, reject in
            let url = URL(string: "https://krausefx.github.io/crypto-summaries/coins/\(ticker.lowercased())-5.txt")!
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, let string = String(data: data, encoding: String.Encoding.utf8) else {
                    resolve(nil)
                    return
                }
                resolve(string)
                }.resume()
        }
    }
}
