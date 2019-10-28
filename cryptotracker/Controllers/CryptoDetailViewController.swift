import UIKit
import Anchorage
import Realm

class CryptoDescriptionCell: UITableViewCell {
    let cryptoDescription: String
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = self.cryptoDescription
        return label
    }()
    
    init(cryptoDescription: String) {
        self.cryptoDescription = cryptoDescription
        super.init(style: .default, reuseIdentifier: nil)
        contentView.addSubview(descriptionLabel)
        descriptionLabel.verticalAnchors == contentView.verticalAnchors + 12
        descriptionLabel.horizontalAnchors == readableContentGuide.horizontalAnchors + 12
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CryptoDetailViewController: UITableViewController {
    let crypto: RealmCryptoCurrency
    lazy var sections = self.createDetailCells(for: self.crypto)
    
    struct DetailSection {
        let title: String
        let cells: [UITableViewCell]
    }
    
    func createDetailCells(for crypto: RealmCryptoCurrency) ->  [DetailSection] {
        let cryptoDescription = CryptoDescriptionCell(cryptoDescription: crypto.currencyDescription)
        let name = CryptoDetailCell(title: "Name", detail: crypto.name)
        let symbol = CryptoDetailCell(title: "Symbol", detail: crypto.symbol)
        let rank = CryptoDetailCell(title: "Rank", detail: String(crypto.rank))
        let priceUsd = CryptoDetailCell(title: "USD Price", detail: crypto.dollarPrice.currencyUS)
        let priceBtc = CryptoDetailCell(title: "Bitcoin Price", detail: "\(crypto.bitcoinPrice)")
        let twentyFourHourVolume = CryptoDetailCell(title: "24 Hour USD Volume", detail: crypto.twentyFourHourVolumeUsd.currencyUS)
        let marketCap = CryptoDetailCell(title: "USD Market Cap", detail: crypto.marketCapUsd.currencyUS)
        let availableSupply = CryptoDetailCell(title: "Available Supply", detail: "\(Int(crypto.availableSupply))")
        let totalSupply = CryptoDetailCell(title: "Total Supply", detail: "\(Int(crypto.totalSupply))")
        let maxSupply = CryptoDetailCell(title: "Max Supply", detail: "\(Int(crypto.dollarPrice))")
        
        let percentChangeTwentyFour = CryptoDetailCell(title: "24 Hour Percentage Change", detail: "\(crypto.percentChangeTwentyFourHour)%")
        percentChangeTwentyFour.detailLabel.textColor = (crypto.percentChangeTwentyFourHour > 0 ? StyleConstants.color.emerald : StyleConstants.color.primaryRed)
        
        let percentChangeSevenDay = CryptoDetailCell(title: "7 Day Percentage Change", detail: "\(crypto.percentChangeSevenDays)%")
        percentChangeSevenDay.detailLabel.textColor = (crypto.percentChangeSevenDays > 0 ? StyleConstants.color.emerald : StyleConstants.color.primaryRed)
        
        let percentChangeOneHour = CryptoDetailCell(title: "1 Hour Percentage Change", detail: "\(crypto.percentChangeOneHour)%")
        percentChangeOneHour.detailLabel.textColor = (crypto.percentChangeOneHour > 0 ? StyleConstants.color.emerald : StyleConstants.color.primaryRed)
        
        let lastUpdated = CryptoDetailCell(title: "Last Updated", detail: "\(crypto.lastUpdated)")
        let infoSection = DetailSection(title: "Information", cells: [name, symbol, rank, lastUpdated])
        let priceSection = DetailSection(title: "Prices", cells: [priceUsd, priceBtc])
        let volumeSection = DetailSection(title: "Volume", cells: [twentyFourHourVolume, marketCap])
        let marketCapSection = DetailSection(title: "Supply", cells: [availableSupply, totalSupply, maxSupply])
        let percentageSection = DetailSection(title: "Percentage Movements", cells: [percentChangeOneHour, percentChangeTwentyFour, percentChangeSevenDay])
        
        let sections: [DetailSection] = {
            guard crypto.currencyDescription.count > 40 else {
                return [infoSection, priceSection, percentageSection, volumeSection, marketCapSection]
            }
            let descriptionSection = DetailSection(title: "Description", cells: [cryptoDescription])
            return[infoSection, priceSection, percentageSection, volumeSection, marketCapSection, descriptionSection]
        }()
        
        return sections
    }
    
    init(_ crypto: RealmCryptoCurrency) {
        self.crypto = crypto
        super.init(style: .grouped)
        title = crypto.symbol
        
        let titleImage = UIImageView()
        titleImage.heightAnchor == 40
        titleImage.widthAnchor == titleImage.heightAnchor
        
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        
        titleImage.sd_setImage(with: URL(string: crypto.iconUrl), completed: nil)
        
        navigationItem.titleView = titleImage
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title.uppercased()
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.sections[indexPath.section].cells[indexPath.row]
    }
}
