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
    var cryptos: [RealmCryptoCurrency] = []
    
    func fetchRealmCryptos() -> [RealmCryptoCurrency] {
        do {
            let realm = try Realm()
            return Array(realm.objects(RealmCryptoCurrency.self))
            
        } catch _ { return [] }
    }
    
    func reloadRealmCryptos() {
        cryptos = self.fetchRealmCryptos()
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
        
        tableView.tableHeaderView = self.marketHeaderView
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(didPressRefresh))
        
        view.addSubview(tableView)
        self.navigationItem.titleView = segment
        
        tableView.horizontalAnchors == view.horizontalAnchors
        tableView.bottomAnchor == view.bottomAnchor
        tableView.topAnchor ==  view.topAnchor
        
        loadCryptos()
        loadMarketInfo()
        
        // Setup the Search Controller
//        searchController.searchResultsUpdater = self
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = "Search Crypto Currencies"
//        navigationItem.searchController = searchController
//        definesPresentationContext = true
        
        // Setup the Scope Bar
//        searchController.searchBar.scopeButtonTitles = ["All", "Chocolate", "Hard", "Other"]
        searchController.searchBar.delegate = self
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
            }
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
        let crypto = cryptos[indexPath.row]
        let vc = CryptoDetailViewController(crypto)
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MarketCell.self)) as? MarketCell else { return UITableViewCell() }
        cell.setCrypto(cryptos[indexPath.row])
        return cell
    }
}

extension MarketViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
    }
}

extension MarketViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        //        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}
