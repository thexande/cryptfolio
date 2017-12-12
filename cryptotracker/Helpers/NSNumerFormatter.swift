import Foundation

extension NumberFormatter {
    convenience init(style: Style) {
        self.init()
        numberStyle = style
    }
}

extension Formatter {
    static let currency = NumberFormatter(style: .currency)
    static let currencyUS: NumberFormatter = {
        let formatter = NumberFormatter(style: .currency)
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()
    static let currencyBR: NumberFormatter = {
        let formatter = NumberFormatter(style: .currency)
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter
    }()
}


extension Numeric {   // for Swift 3 use FloatingPoint or Int
    var currency: String {
        return Formatter.currency.string(for: self) ?? ""
    }
    var currencyUS: String {
        return Formatter.currencyUS.string(for: self) ?? ""
    }
    var currencyBR: String {
        return Formatter.currencyBR.string(for: self) ?? ""
    }
    
}
