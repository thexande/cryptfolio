import UIKit
import Anchorage

class CryptoDetailCell: UITableViewCell {
    let detailLabel = UILabel()
    let titleLabel = UILabel()
    
    init(title: String, detail: String) {
        super.init(style: .default, reuseIdentifier: nil)
        detailLabel.text = detail
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        detailLabel.font = UIFont.systemFont(ofSize: 16)
        
        detailLabel.textColor = StyleConstants.color.secondaryGray
        
        addSubview(detailLabel)
        addSubview(titleLabel)
        
        titleLabel.leadingAnchor == readableContentGuide.leadingAnchor + 12
        titleLabel.verticalAnchors == contentView.verticalAnchors + 6
        
        detailLabel.trailingAnchor == readableContentGuide.trailingAnchor - 12
        detailLabel.verticalAnchors == contentView.verticalAnchors + 6
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
