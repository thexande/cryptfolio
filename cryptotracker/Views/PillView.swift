import UIKit
import Anchorage

enum CryptoPill {
    case usd
    case btc
    
    func color() -> UIColor {
        switch self {
        case .usd: return StyleConstants.color.emerald
        case .btc: return StyleConstants.color.bitOrange
        }
    }
}

class PillView: UIView {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.text = "0"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        label.topAnchor == topAnchor + 4
        label.bottomAnchor == bottomAnchor - 4
        label.leadingAnchor == leadingAnchor + 4
        label.trailingAnchor == trailingAnchor - 4
        layer.borderWidth = 1
        layer.cornerRadius = 5
        label.textAlignment = .center
    }
    
    func setColor(_ color: UIColor) {
        label.textColor = color
        layer.borderColor = color.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
