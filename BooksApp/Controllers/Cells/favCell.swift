//
//  favCell.swift
//  BooksApp
//
//  Created by Tom Kew-Gooale on 4/11/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

protocol RemoveFavoriteDelegate {
    func removeFavoriteTapped(at indexPath: IndexPath)
}

class favCell: UITableViewCell {

    @IBOutlet weak var bookThumbnail: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    var delegate: RemoveFavoriteDelegate!
    var indexPath: IndexPath!
    var isFavorite = false

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func removeFavoritesTapped(_ sender: Any) {
        self.delegate.removeFavoriteTapped(at: indexPath)
    }
    
}
