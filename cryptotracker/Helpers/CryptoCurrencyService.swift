//import Result
//
//struct UrlConstants {
//    static let coinMarketCapTickerUrl: URL = URL(string: "https://api.coinmarketcap.com/v1/ticker/")!
//    static let globalInfoUrl: URL = URL(string: "https://api.coinmarketcap.com/v1/global/")!
//    
//    static func descriptionUrl(ticker: String) -> URL {
//        return URL(string: "https://krausefx.github.io/crypto-summaries/coins/\(ticker.lowercased())-5.txt")!
//    }
//}
//
//enum CryptoCurrencyServiceError: Error {
//    case apiFail(String?)
//    case descriptionFetchFail(String?)
//}
//
//final class CryptoCurrencyService {
//    func fetchCryptoCurencies(completion: @escaping(Result<[CryptoCurrency], CryptoCurrencyServiceError>) -> Void) {
//        URLSession.shared.dataTask(with: UrlConstants.coinMarketCapTickerUrl) { (data, response, error) in
//            guard let data = data else { return }
//            do {
//                let cryptos = try JSONDecoder().decode([CryptoCurrency].self, from: data)
//                // move this shit somewhere else
//                let marketCap: [Int] = cryptos.compactMap({ Int($0.marketCapUsd) })
//                let total = marketCap.reduce(0, { $0 + $1 })
//                GlobalMarketDataStore.sharedInstance.totalMakretCap = total
//                
//                completion(.success(cryptos))
//            } catch let error {
//                completion(.failure(.apiFail(error.localizedDescription)))
//            }
//            }.resume()
//    }
//    
//    
//    func fetchMarketInformation(url: URL, _ completion: @escaping(CryptoWorldInformation) -> Void) {
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            guard let data = data else { return }
//            let string1 = String(data: data, encoding: String.Encoding.utf8) ?? "Data could not be printed"
//            print(string1)
//            
//            do {
//                let marketInfo = try JSONDecoder().decode(CryptoWorldInformation.self, from: data)
//                completion(marketInfo)
//            } catch let error {
//                print(error.localizedDescription)
//            }
//            }.resume()
//    }
//    
//    
//    func fetchDescription(for ticker: String, completion: @escaping(Result<String, CryptoCurrencyServiceError>) -> Void) {
//        URLSession.shared.dataTask(with: UrlConstants.descriptionUrl(ticker: ticker)) { (data, response, error) in
//            guard let data = data, let string = String(data: data, encoding: String.Encoding.utf8) else {
//                completion(.failure(.descriptionFetchFail(error?.localizedDescription)))
//                return
//            }
//            completion(.success(string))
//        }
//    }
//    
//    
//    
//    
//    //
//    //            let cryptoDescriptionPromises: [Promise<CryptoCurrencyDesctiption>] = cryptos.map(CryptoCurrencyHelper.fetchDescription(for:))
//    //            _ = PromiseKit.when(fulfilled: cryptoDescriptionPromises).then { cryptoDescriptions -> Void in
//    //                RealmCrudHelper.writeCryptos(cryptoDescriptions)
//    //                completion(true)
//    //                }.catch(execute: { (error) in
//    //                    print(error.localizedDescription)
//    //                    completion(false)
//    //                })
//    
//    
//}
