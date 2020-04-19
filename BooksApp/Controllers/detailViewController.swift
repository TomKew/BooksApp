//
//  detailViewController.swift
//  BooksApp
//
//  Created by Tom Kew-Gooale on 4/11/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit
import SDWebImage

class detailViewController: UIViewController {

    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var bookPublisher: UILabel!
    @IBOutlet weak var bookDescription: UILabel!
    
    var detailBook: Model? {
        didSet {
            configureView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        if let book = detailBook {
            if let thumbmnail = bookImage {
                let thumbnailURL = URL(string: book.thumbnailURL)
                if let url = thumbnailURL {
                    thumbmnail.sd_setImage(with: url, placeholderImage: UIImage(named: "blank"))
                }
            }
            if let title = bookTitle {
                title.text = "\(book.title)"
            }
            if let author = bookAuthor {
                author.text = "Author: \(book.author)"
            }
            if let publisher = bookPublisher {
                publisher.text = "Publisher: \(book.publisher)"
            }
            if let description = bookDescription {
                description.text = "Description: \(book.description)"
            }
                 }
    }
}

