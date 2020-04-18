//
//  networkManager.swift
//  BooksApp
//
//  Created by Tom Kew-Gooale on 4/11/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class networkManager {
    static let shared = networkManager()
    
    
    func fetchBooks(bookTitle: String, completion: @escaping(_ success: Bool, _ arr: [Model]) -> ()) {
        DispatchQueue.global(qos: .background).async {
            guard let queryString = bookTitle.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
            AF.request("https://www.googleapis.com/books/v1/volumes?q=\(queryString)").validate().responseJSON { (response) in
                switch response.result {
                case .success(let data):
                    let json: JSON = JSON(data)
                    let subjson: JSON = json["items"]
                    var booksArray = [Model]()
                    for (_, object) in subjson {
                        let book = Model ()
                        book.title = object["volumeInfo"]["title"].stringValue
                        let authorsArray = object["volumeInfo"]["authors"].arrayObject as? [String] ?? [""]
                        book.author = authorsArray.joined(separator: ", ")
                        book.thumbnailURL = object["volumeInfo"]["imageLinks"]["thumbnail"].stringValue
                        book.publisher = object["volumeInfo"]["publisher"].stringValue
                        book.description = object["volumeInfo"]["description"].stringValue
                        booksArray.append(book)
                    }
                    completion(true, booksArray)
                    
                case .failure(let error):
                    completion(false, [])
                    print(error)
                    break
                }
            }
        }
    }
}
