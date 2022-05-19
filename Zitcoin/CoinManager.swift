//
//  CoinManager.swift
//  Zitcoin
//
//  Created by Bahadır Kılınç on 19.05.2022.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate"
    let apiKey = "YOUR-API-KEY"

    let currencyArray = ["BTC", "RACA","BNB","ETH","AVAX","XAVA","SHIB","HEC","DOGE","RIDE","SOL","ADA","DOT","MATIC","MANA","ICP","REEF","MINA","SAND"] // add your fav coins
    
    func getCoinPrice(for currency: String) {
        
        let urlString = "\(baseURL)/\(currency)/USD?apikey=\(apiKey)"
        print(urlString)
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        let priceString = String(format: "%.6f", bitcoinPrice)
                        self.delegate?.didUpdatePrice(price: priceString)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            return lastPrice
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
