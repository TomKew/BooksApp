//
//  BooksTableViewController.swift
//  BooksApp
//
//  Created by Tom Kew-Gooale on 4/11/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit
import SDWebImage


class mainTableViewController: UITableViewController {
    
    // MARK: - Properties
    @IBOutlet weak var searchBar: UISearchBar!
    let cellId = "Cell"
    var books = [Model]()
    var bookModels = [BookModel]()
    var removedFavorites = false
    var query = ""
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bookModels = ModelManager.shared.loadBooks(bookModelArray: &bookModels)
        if removedFavorites && query != "" {
            searchBook(query)
            removedFavorites = false
        }
    }
    
    // MARK: - Handlers
    func searchBook(_ bookTitle: String) {
        books = []
        
        networkManager.shared.fetchBooks(bookTitle: bookTitle) { (success, books) in
            if success {
                if books.isEmpty {
                    let alert = UIAlertController(title: "No results found", message: "", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.books = books
                    self.books = ModelManager.shared.filterArray(booksArray: &self.books, bookModelArray: &self.bookModels)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } else {
                let alert = UIAlertController(title: "Please reconnect to the internet", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueMainToDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let book = books[indexPath.row]
                let controller = segue.destination as! detailViewController
                controller.detailBook = book
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! Cell
        cell.delegate = self
        cell.indexPath = indexPath
        let thumbnailURL = URL(string: books[indexPath.row].thumbnailURL)
        if let url = thumbnailURL {
            cell.bookThumbnail.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.bookThumbnail.sd_setImage(with: url, placeholderImage: UIImage(named: "blank"))
        }
        cell.bookTitle.text = books[indexPath.row].title
        cell.bookAuthor.text = "Author: \(books[indexPath.row].author)"
        if books[indexPath.row].isFavorite {
            cell.favoritesButton.setTitle("Added", for: .normal)
            cell.isFavorite = true
        } else {
            cell.favoritesButton.setTitle("Add to favorites", for: .normal)
            cell.isFavorite = false
        }
        return cell
    }
}

extension mainTableViewController: AddFavoriteDelegate {
func addToFavoritesTapped(at indexPath: IndexPath, isFavorite: Bool) {
    if isFavorite {
        ModelManager.shared.saveFavorite(title: books[indexPath.row].title, author: books[indexPath.row].author, publisher: books[indexPath.row].publisher, thumbnailURL: books[indexPath.row].thumbnailURL, description: books[indexPath.row].description, isFavorite: true)
    } else {
        ModelManager.shared.deleteMatches(at: indexPath, bookModelArray: &bookModels, booksArray: &books)
        }
    }
}

extension mainTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != "" {
            searchBook(searchBar.text!)
            query = searchBar.text!
        }
        view.endEditing(true)
    }
}



