//
//  Film.swift
//  tawktestios
//
//  Created by JMC on 29/7/21.
//

import CoreData

class _Film: NSManagedObject {
    
    @NSManaged var director: String
    @NSManaged var episodeId: NSNumber
    @NSManaged var openingCrawl: String
    @NSManaged var producer: String
    @NSManaged var releaseDate: Date
    @NSManaged var title: String
    
    static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "YYYY-MM-dd"
        return df
    }()
    
    func update(with jsonDictionary: [String: Any]) throws {
        guard let director = jsonDictionary["login"] as? String,
            let episodeId = jsonDictionary["id"] as? Int,
            let openingCrawl = jsonDictionary["login"] as? String,
            let producer = jsonDictionary["login"] as? String,
            let releaseDate = jsonDictionary["login"] as? String,
            let title = jsonDictionary["login"] as? String
            else {
                throw NSError(domain: "", code: 100, userInfo: nil)
        }
        
        self.director = director
        self.episodeId = NSNumber(value: episodeId)
        self.openingCrawl = openingCrawl
        self.producer = producer
//        self.releaseDate = Film.dateFormatter.date(from: releaseDate) ?? Date(timeIntervalSince1970: 0)
        self.title = title
    }

}
