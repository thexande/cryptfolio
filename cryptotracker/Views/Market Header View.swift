import UIKit
import Anchorage

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
        view.backgroundColor = pillType.color()
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
        backgroundColor = .white
        
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

