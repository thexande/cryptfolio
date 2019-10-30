import UIKit
import Anchorage

extension UIColor {
    
    static func darkModeTableBackground() -> UIColor {
        return UIColor(red:0.09, green:0.09, blue:0.09, alpha:1.0)
    }
    
    static func darkModeMardown() -> UIColor {
        return UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0)
    }
    
    static func appleBlue() -> UIColor {
        return UIColor.init(red: 14.0/255, green: 122.0/255, blue: 254.0/255, alpha: 1.0)
    }

}

class MarketHeaderView: UIView {
    let pillFontSize: CGFloat = 12
    lazy var totalMarketCap = makePillView(pillType: .usd)
    lazy var totalVolume = makePillView(pillType: .usd)
    lazy var btcPercent = makePillView(pillType: .btc)
    let dividerView = UIView()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            self.makePillContainer(pill: totalMarketCap),
            self.makePillContainer(pill: totalVolume),
            self.makePillContainer(pill: btcPercent)
        ])
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    func makePillView(pillType: CryptoPill) -> PillView {
        let view = PillView()
        view.setColor(pillType.color())
        view.label.font = UIFont.systemFont(ofSize: self.pillFontSize, weight: .regular)
        return view
    }
    
    func makePillContainer(pill: PillView) -> UIView {
        let container = UIView()
        container.addSubview(pill)
        pill.centerAnchors == container.centerAnchors
        pill.verticalAnchors == container.verticalAnchors
        
        return container
    }
    
    func setMarketInfo(_ info: CryptoWorldInformation) {
        totalMarketCap.label.text = "Total Market Cap USD: \(info.totalMarketCapUsd.currencyUS)"
        totalVolume.label.text = "Total Volume USD: \(info.totalTwentyFourHourVolumeUsd.currencyUS)"
        btcPercent.label.text = "BTC Market Dominance: \(String(info.bitcoinPercentageOfMarketCap))%"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        dividerView.backgroundColor = StyleConstants.color.secondaryGray
        
        addSubview(stackView)
        addSubview(dividerView)
        
        dividerView.horizontalAnchors == horizontalAnchors
        dividerView.bottomAnchor == bottomAnchor
        dividerView.heightAnchor == 0.5
        
        stackView.horizontalAnchors == horizontalAnchors
        stackView.topAnchor == topAnchor + 12
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

