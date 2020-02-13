//
//  ShowNewsViewController.swift
//  NewsMarkiyanVytrykush
//
//  Created by Nanter on 2/12/20.
//  Copyright © 2020 Markiyan Vytrykush. All rights reserved.
//

import Foundation
import UIKit

class NewsViewController: UIViewController {

    var searchBar: UISearchBar!

    // MARK: -  IBOutlets
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    private var articles: ResultsContainer<Article>?
    private var sources: ResultsContainer<Sources>?

    var parameters = [String:String]()
    var delegate: CategoryParameterDelegate?
    var pressedButton: ParametersButton = .noButton
    
    private let refresher = UIRefreshControl()
    var searchBarDidEdited: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }


    // MARK: -  createSearchBar
    @objc func createSearchBar(_ sender: UIButton) {
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44.0))
        searchBar.barTintColor = UIColor.white
        searchBar.tintColor = UIColor.black
        searchBar.placeholder = "News search"
        searchBar.returnKeyType = .done
        searchBar.showsCancelButton = true
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
        searchBar.becomeFirstResponder()
        PageManager.shared.resetPageCounting()
    }

    // MARK: -  removeSearchBar
    func removeSearchBar() {
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(createSearchBar(_:)))
        searchButton.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem = searchButton
    }

    // MARK: -  addTapRecognizer
    func addTapRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        infoLabel.isUserInteractionEnabled = true
        infoLabel.addGestureRecognizer(tap)
    }

    // MARK: -  setup
    func setup() {
        removeSearchBar()
        addRefresher()
        getInfo(requestType: .getNews)
        addTapRecognizer()
        parameters = NetworkManager.shared.type.queryParameters
        
    }

    // MARK: -  handleTap
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        getInfo(requestType: .getNews)
    }

    // MARK: -  addRefresher
    func addRefresher() {
        refresher.tintColor = UIColor.black
        refresher.attributedTitle = NSAttributedString(string: "Refreshing...")
        tableView.addSubview(refresher)
        refresher.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }

    // MARK: -  refresh
    @objc func refresh() {
        PageManager.shared.resetPageCounting()
        getInfo(requestType: .reload)
    }

    // MARK: -  request
    func request<T:Codable>(type: T.Type, action: @escaping (T)->()) {

        do {
            let url: URLRequest
            switch NetworkManager.shared.type {
            case .topHeadlines(let category, let country, let source, _):
                url = try NewsApiRouter.topHeadlines(category: category, country: country, source: source, page: PageManager.shared.page).asRequest()
            case .everything(let searchWord, _):
                url = try NewsApiRouter.everything(searchWord: searchWord, page: PageManager.shared.page).asRequest()
            case .sources(let category, let country, let language):
                url = try NewsApiRouter.sources(category: category, country: country, language: language).asRequest()
            }
            print("Current url: \(url)")

            ApiService.shared.request(request: url, type: type) { result in
                switch result {
                case .success(let news):
                    action(news)
                case .failure(let failure):
                    DispatchQueue.main.async {
                        if failure.localizedDescription != TaskManager.shared.cancelledErrorDescription {
                            self.alert(title: "Error", message: failure.localizedDescription, button: "Ok", action: nil)
                        }
                    }
                    self.setInterface()
                }
            }
        } catch let error {
            alert(title: "Error", message: error.localizedDescription, button: "Ok", action: nil)
            setInterface()
        }
    }


    // MARK: -  getInfo
    func getInfo(requestType: RequestType) {
        switch NetworkManager.shared.type {
        case .sources:
            switch requestType {
            case .getNews:
                tableView.setContentOffset(.zero, animated: false)
                newsDownloadStart()
            default:
                break
            }
            request(type: ResultsContainer<Sources>.self) { (sources) in
                self.sources = sources
                self.articles = nil
                self.setInterface()
            }
        default:
            switch requestType {
            case .getNews:
                tableView.setContentOffset(.zero, animated: false)
                newsDownloadStart()
            default:
                break
            }
            request(type: ResultsContainer<Article>.self) { (articles) in
                switch requestType {
                case .pagination:
                    self.articles?.results += articles.results
                default:
                    self.articles = articles
                    self.sources = nil
                }
                if let resultCount = articles.totalResults {
                    PageManager.shared.totalResults = resultCount
                    print("Total result for current request: \(PageManager.shared.totalResults)")
                }
                self.setInterface()
            }
        }
    }

    // MARK: -  enum RequestType
    enum RequestType {
        case getNews
        case pagination
        case reload
    }


    // MARK: -  setInterface
    func setInterface() {
        DispatchQueue.main.async {
            switch NetworkManager.shared.type {
            case .topHeadlines:
                if self.articles?.results.isEmpty ?? true {
                    self.infoLabel.isHidden = false
                    self.tableView.isHidden = true
                } else {
                    self.infoLabel.isHidden = true
                    self.tableView.isHidden = false
                }
            case .everything:
                if self.articles?.results.isEmpty ?? true {
                    self.infoLabel.isHidden = false
                    self.tableView.isHidden = true
                } else {
                    self.infoLabel.isHidden = true
                    self.tableView.isHidden = false
                }
            case .sources:
                if self.sources?.results.isEmpty ?? true {
                    self.infoLabel.isHidden = false
                    self.tableView.isHidden = true
                } else {
                    self.infoLabel.isHidden = true
                    self.tableView.isHidden = false
                }
            }
            self.tableView.tableFooterView = UIView()
            self.spinner.stopAnimating()
            self.refresher.endRefreshing()
            self.tableView.reloadData()
        }
    }

    func newsDownloadStart() {
        self.spinner.startAnimating()
        self.tableView.isHidden = true
        self.infoLabel.isHidden = true
    }

    func pagination(indexPath: IndexPath) {
        guard let articles = articles?.results else { return }
        if indexPath.row == articles.count - 1 && ApiService.shared.task?.state != URLSessionTask.State.running {
            PageManager.shared.nextPage {
                paginationLoadFooter()
                getInfo(requestType: .pagination)
            }
        }
    }

    // MARK: -  paginationLoadFooter
    func paginationLoadFooter() {
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))

        self.tableView.tableFooterView = spinner
    }

    // MARK: -  setType
    func setType() {
        switch NetworkManager.shared.NewsTypeInfo {
        case .headlines:
            if parameters[Parameters.category.rawValue] == nil && parameters[Parameters.country.rawValue] == nil && parameters[Parameters.sources.rawValue] == nil {
                NetworkManager.shared.type = .topHeadlines(category: Parameters.category.filterValues[3],
                                                           country: nil,
                                                           source: nil,
                                                           page: 1)
            } else {
                NetworkManager.shared.type = .topHeadlines(category: parameters[Parameters.category.rawValue],
                                                           country: parameters[Parameters.country.rawValue],
                                                           source: parameters[Parameters.sources.rawValue],
                                                           page: 1)
            }
        case .publishers:
            NetworkManager.shared.type = .sources(category: parameters[Parameters.category.rawValue],
                                                  country: parameters[Parameters.country.rawValue],
                                                  language: parameters[Parameters.language.rawValue])
        }
    }

}


// MARK: -  NewsViewControllerTableViewDataSource
extension NewsViewController: UITableViewDataSource {

    func counter() -> Int {
        var counter = 0
        switch NetworkManager.shared.type {
        case .sources:
            guard let sources = sources?.results else { return counter }
            counter = sources.count
        default:
            guard let articles = articles?.results else { return counter }
            counter = articles.count
        }
        return counter
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return counter()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: NewsTableViewCell = tableView.getCell()

        switch NetworkManager.shared.type {
        case .sources:
            let source = sources?.results[indexPath.row]
            cell.source = source
        default:
            let article = articles?.results[indexPath.row]
            cell.article = article
        }
        pagination(indexPath: indexPath)
        return cell
    }

}

// MARK: -  NewsViewControlleTableViewDelegate
extension NewsViewController: UITableViewDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if searchBar != nil {
            searchBar.endEditing(true)
            if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
                cancelButton.isEnabled = true
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var url: URL!
        switch NetworkManager.shared.type {
        case .sources:
            url = sources?.results[indexPath.row].url
        default:
            url = articles?.results[indexPath.row].url
        }
        Safari.shared.showPage(from: url, sender: self)

    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 450
    }
}

// MARK: -  CategoryParameterDelegate
extension NewsViewController: CategoryParameterDelegate {

    func tableViewUpdateWithNewFilters() {
        getInfo(requestType: .getNews)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CategoryViewController{
            destination.delegate = self
        }
    }


}

// MARK: -  NewsViewControllerSearchBarDelegate
extension NewsViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search text: \(String(describing: searchBar.text))")
        if let text = searchBar.text, !text.isEmpty {
            searchBarDidEdited = true
            NetworkManager.shared.type = NewsApiRouter.everything(searchWord: text, page: PageManager.shared.page)
            TaskManager.shared.cancelTask(task: ApiService.shared.task)
            getInfo(requestType: .getNews)
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        NetworkManager.shared.getFromUserDefaults()
        PageManager.shared.resetPageCounting()
        searchBar.endEditing(true)
        removeSearchBar()
        if searchBarDidEdited {
            getInfo(requestType: .getNews)
            searchBarDidEdited = false
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.isEnabled = true
        }
    }
}
