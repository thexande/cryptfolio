//
//  MarketViewController.swift
//  cryptotracker
//
//  Created by Alexander Murphy on 11/24/17.
//  Copyright © 2017 Alexander Murphy. All rights reserved.
//

import Foundation
import UIKit
import Anchorage
import SDWebImage
import Realm
import RealmSwift
import PromiseKit
import Lottie


extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

class MarketViewController: UIViewController {
    let searchController = UISearchController(searchResultsController: nil)
    fileprivate let searchEmptyStateView = SearchEmptyStateView()
    fileprivate let refreshControl = UIRefreshControl()
    var cryptos: [RealmCryptoCurrency] = []
    var filteredCryptos: [RealmCryptoCurrency] = []
    var isSearching: Bool = false
    
    func fetchRealmCryptos() -> [RealmCryptoCurrency] {
        do {
            let realm = try Realm()
            return Array(realm.objects(RealmCryptoCurrency.self))
            
        } catch _ { return [] }
    }
    
    func reloadRealmCryptos() {
        cryptos = self.fetchRealmCryptos()
        filteredCryptos = self.fetchRealmCryptos()
    }
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(MarketCell.self, forCellReuseIdentifier: String(describing: MarketCell.self))
        return view
    }()
    
    lazy var segment: UISegmentedControl = {
        let segment: UISegmentedControl = UISegmentedControl(items: [ "Cap", "1 hr %", "24 hr %", "7 day %"])
        segment.sizeToFit()
        segment.addTarget(self, action: #selector(didChangeSegmentedControl(_:)), for: .valueChanged)
        segment.selectedSegmentIndex = 0
        return segment  
    }()
    
    let loadingViewController = BlurLoadingViewController()
    let marketHeaderView =  MarketHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 107))

    
    @objc func didPressRefresh() {
        loadCryptos()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "market".uppercased()
        navigationItem.titleView = segment
        tableView.tableHeaderView = self.marketHeaderView
        view.addSubview(tableView)
        tableView.edgeAnchors == view.edgeAnchors
        
        tableView.backgroundView = searchEmptyStateView
        tableView.backgroundView?.isHidden = true
        tableView.tableFooterView = UIView()
        
        loadCryptos()
        loadMarketInfo()
        
//         Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Currencies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchBar.delegate = self
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc func refreshData() {
        CryptoCurrencyHelper.fetchCryptos(url: UrlConstants.coinMarketCapTickerUrl) { [weak self] (cryptos) in
            _ = PromiseKit.when(fulfilled: cryptos.map { crypto in
                return CryptoCurrencyHelper.fetchDescription(for: crypto)
            }).then { cryptoDescriptions -> Void in
                RealmCrudHelper.writeCryptos(cryptoDescriptions)
                DispatchQueue.main.async {
                    self?.refreshControl.endRefreshing()
                    self?.reloadRealmCryptos()
                    self?.tableView.reloadData()
                }
                }.catch(execute: { (error) in
                    print(error.localizedDescription)
                })
        }
    }
    
    func loadMarketInfo() {
        CryptoCurrencyHelper.fetchMarketInformation(url: UrlConstants.globalInfoUrl) { [weak self] (marketInformation) in
            DispatchQueue.main.async {
                self?.marketHeaderView.setMarketInfo(marketInformation)
            }
        }
    }
    
    func loadCryptos() {
        loadingViewController.modalPresentationStyle = .overFullScreen
        self.present(loadingViewController, animated: false, completion: nil)
        CryptoCurrencyHelper.fetchCryptos(url: UrlConstants.coinMarketCapTickerUrl) { [weak self] (cryptos) in
            
            _ = PromiseKit.when(fulfilled: cryptos.map { crypto in
                return CryptoCurrencyHelper.fetchDescription(for: crypto)
            }).then { cryptoDescriptions -> Void in
                RealmCrudHelper.writeCryptos(cryptoDescriptions)
                DispatchQueue.main.async {
                    self?.loadingViewController.dismissFade()
                    self?.reloadRealmCryptos()
                    self?.tableView.reloadData()
                }
                }.catch(execute: { (error) in
                    print(error.localizedDescription)
                })
        }
    }
    
    @objc func didChangeSegmentedControl(_ segmented: UISegmentedControl) {
        switch segmented.selectedSegmentIndex {
        case 0:
            cryptos = cryptos.sorted(by: { (crypto1, crypto2) -> Bool in
                return crypto1.rank < crypto2.rank
            })
            tableView.reloadData()
        case 1:
            cryptos = cryptos.sorted(by: { (crypto1, crypto2) -> Bool in
                return crypto1.percentChangeOneHour > crypto2.percentChangeOneHour
            })
            tableView.reloadData()
        case 2:
            cryptos = cryptos.sorted(by: { (crypto1, crypto2) -> Bool in
                return crypto1.percentChangeTwentyFourHour > crypto2.percentChangeTwentyFourHour
            })
            tableView.reloadData()
        case 3:
            cryptos = cryptos.sorted(by: { (crypto1, crypto2) -> Bool in
                return crypto1.percentChangeSevenDays > crypto2.percentChangeSevenDays
            })
            tableView.reloadData()
        case 3:
            cryptos = cryptos.sorted(by: { (crypto1, crypto2) -> Bool in
                return crypto1.twentyFourHourVolumeUsd > crypto2.twentyFourHourVolumeUsd
            })
            tableView.reloadData()
        default: return
        }
    }
}

extension MarketViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let crypto: RealmCryptoCurrency = {
            if isSearching {
                return filteredCryptos[indexPath.row]
            } else {
                return cryptos[indexPath.row]
            }
        }()
        
        let vc = CryptoDetailViewController(crypto)
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            if filteredCryptos.count == 0 {
                tableView.separatorStyle = .none
                tableView.backgroundView?.isHidden = false
            } else {
                tableView.separatorStyle = .singleLine
                tableView.backgroundView?.isHidden = true
            }
            
            return filteredCryptos.count
        } else {
            return cryptos.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MarketCell.self)) as? MarketCell else { return UITableViewCell() }
        
        let crypto: RealmCryptoCurrency = {
            if isSearching {
                return filteredCryptos[indexPath.row]
            } else {
                return cryptos[indexPath.row]
            }
        }()
        
        cell.setCrypto(crypto)
        return cell
    }
}

extension MarketViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {

    }
}

extension MarketViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = true
        filteredCryptos = cryptos
        let searchCryptos = filteredCryptos.filter { $0.name.uppercased().range(of: searchText.uppercased()) != nil  || $0.symbol.uppercased().range(of: searchText.uppercased()) != nil }
        filteredCryptos = searchText == "" ? cryptos : searchCryptos
        tableView.reloadData()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false
        view.sendSubview(toBack: searchEmptyStateView)
        tableView.reloadData()
    }
}


final class SearchEmptyStateView: UIView {
    let titleLabel = UILabel()
    let lottieView = LOTAnimationView(name: "rejection")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [titleLabel, lottieView].forEach { addSubview($0) }
        
        lottieView.sizeAnchors == CGSize(width: 200, height: 200)
        lottieView.centerAnchors == centerAnchors
        lottieView.loopAnimation = true
        lottieView.play()
        
        titleLabel.horizontalAnchors == horizontalAnchors + 24
        titleLabel.bottomAnchor == lottieView.topAnchor
        titleLabel.text = "No results found."
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        
        backgroundColor = .white
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lottieView.play()
    }
}
