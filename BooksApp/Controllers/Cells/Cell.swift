//
//  Cell.swift
//  BooksApp
//
//  Created by Tom Kew-Gooale on 4/11/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

protocol AddFavoriteDelegate {
    func addToFavoritesTapped(at indexPath: IndexPath, isFavorite: Bool)
}

class Cell: UITableViewCell {

    @IBOutlet weak var bookThumbnail: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var favoritesButton: UIButton!
    var delegate: AddFavoriteDelegate!
    var indexPath: IndexPath!
    var isFavorite = false

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func addToFavoritesTapped(_ sender: Any) {
        isFavorite = !isFavorite
        if isFavorite {
            favoritesButton.setTitle("Added", for: .normal)
            self.delegate.addToFavoritesTapped(at: indexPath, isFavorite: true)
        } else {
            favoritesButton.setTitle("Add to favorites", for: .normal)
            self.delegate.addToFavoritesTapped(at: indexPath, isFavorite: false)
        }
    }
}
