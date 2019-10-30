import UIKit
import Anchorage
import SDWebImage

class MarketCell: UITableViewCell {
    let pillFontSize: CGFloat = 10
    let logoImageView = UIImageView()
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    lazy var logoContainer = UIStackView(arrangedSubviews: [self.titleLabel, self.subTitleLabel])
    lazy var usdPill = self.makePillView(pillType: .usd)
    lazy var btcPill = self.makePillView(pillType: .btc)
    let twentyFourHourPill = PillView()
    let sevenDayPill = PillView()
    
    lazy var amountStack: UIView = {
        let view = UIStackView(arrangedSubviews: [self.usdPill, self.btcPill])
        view.axis = .vertical
        view.spacing = 4
        return view
    }()
    
    lazy var percentStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [self.twentyFourHourPill, self.sevenDayPill])
        view.axis = .vertical
        view.spacing = 4
        return view
    }()
    

    func makePillView(pillType: CryptoPill) -> PillView {
        let view = PillView()
        view.setColor(pillType.color())
        view.label.font = UIFont.systemFont(ofSize: self.pillFontSize, weight: .regular)
        return view
    }
    
    func setCrypto(_ crypto: RealmCryptoCurrency) {
        guard let url = URL(string: crypto.iconUrl) else { return }
        logoImageView.sd_setImage(with: url, completed: nil)
        titleLabel.text = crypto.symbol
        subTitleLabel.text = crypto.name
    
        twentyFourHourPill.label.text = "24 hr: \(crypto.percentChangeTwentyFourHour)%"
        sevenDayPill.label.text = "7 day: \(crypto.percentChangeSevenDays)%"
        
        usdPill.label.text = "USD: \(crypto.dollarPrice.currencyUS)"
        btcPill.label.text = "BTC: \(crypto.bitcoinPrice.rounded(toPlaces: 5))"
        
        twentyFourHourPill.setColor(crypto.percentChangeTwentyFourHour > 0 ? StyleConstants.color.emerald : StyleConstants.color.primaryRed)
        sevenDayPill.setColor(crypto.percentChangeSevenDays > 0 ? StyleConstants.color.emerald : StyleConstants.color.primaryRed)
    }
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let views: [UIView] = [logoImageView, logoContainer, percentStack, amountStack]
        views.forEach { view in
            addSubview(view)
        }
        
        twentyFourHourPill.widthAnchor == 80
        sevenDayPill.widthAnchor == 80
        
        twentyFourHourPill.label.font = UIFont.systemFont(ofSize: self.pillFontSize, weight: .regular)
        sevenDayPill.label.font = UIFont.systemFont(ofSize: self.pillFontSize, weight: .regular)
        
        percentStack.centerYAnchor == centerYAnchor
        percentStack.trailingAnchor == readableContentGuide.trailingAnchor
        
        amountStack.trailingAnchor == percentStack.leadingAnchor - 12
        amountStack.centerYAnchor == centerYAnchor
        
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .ultraLight)
        subTitleLabel.font = UIFont.systemFont(ofSize: 10, weight: .light)
        
        logoContainer.axis = .vertical
        logoContainer.leadingAnchor == logoImageView.trailingAnchor + 12
        logoContainer.centerYAnchor == centerYAnchor
        
        logoImageView.heightAnchor == 40
        logoImageView.widthAnchor == logoImageView.heightAnchor
        logoImageView.centerYAnchor == centerYAnchor
        logoImageView.leadingAnchor == readableContentGuide.leadingAnchor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
