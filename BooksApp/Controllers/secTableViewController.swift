//
//  secTableViewController.swift
//  BooksApp
//
//  Created by Tom Kew-Gooale on 4/11/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit
import SDWebImage

class secTableViewController: UITableViewController {

    var bookModelArray = [BookModel]()
    let cellId = "favCell"

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bookModelArray = ModelManager.shared.loadBooks(bookModelArray: &bookModelArray)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueSecToFavorite" {
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let title = bookModelArray[indexPath.row].title else { return }
                guard let author = bookModelArray[indexPath.row].author else { return }
                guard let thumbnailURL = bookModelArray[indexPath.row].thumbnailURL else { return }
                guard let description = bookModelArray[indexPath.row].bookDescription else { return }
                let book = Model()
                book.title = title
                book.author = author
                book.thumbnailURL = thumbnailURL
                book.description = description
                let controller = segue.destination as! detailViewController
                controller.detailBook = book
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookModelArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! favCell
        let thumbnailURL = URL(string: bookModelArray[indexPath.row].thumbnailURL ?? "")
        cell.delegate = self
        cell.indexPath = indexPath
        if let url = thumbnailURL {
            cell.bookThumbnail.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.bookThumbnail.sd_setImage(with: url, placeholderImage: UIImage(named: "blank"))
        }
        cell.bookTitle.text = bookModelArray[indexPath.row].title
        cell.bookAuthor.text = bookModelArray[indexPath.row].author
        return cell
    }
}

extension secTableViewController: RemoveFavoriteDelegate {
    func removeFavoriteTapped(at indexPath: IndexPath) {
        ModelManager.shared.deleteFromCoreData(at: indexPath, bookModelArray: &bookModelArray)
        bookModelArray.remove(at: indexPath.row)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        let navigationVC = self.tabBarController?.viewControllers?[0] as! UINavigationController
        let booksVC = navigationVC.viewControllers[0] as! mainTableViewController
        booksVC.removedFavorites = true
    }
}


