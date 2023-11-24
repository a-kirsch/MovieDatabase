//
//  StateController.swift
//  AdamKirsch-Lab4
//
//  Created by Adam Kirsch on 10/23/23.
//

import UIKit
import Foundation


class StateController {
    static let shared = StateController()
    var favoriteImagesCache: [UIImage] = []
    var favorites: [Movie] = []
    var watchlist: [Movie] = []
    var watchlistImagesCache: [UIImage] = []

    
    private init() {
        
    }
    
    func addFavoriteMovie(_ movie: Movie) {
        favorites.append(movie)
//        saveFavorites()
    }

    func addFavoriteImage(_ image: UIImage) {
        favoriteImagesCache.append(image)
    }
    
    func addWatchlistMovie(_ movie: Movie) {
        watchlist.append(movie)
    }
    
    func addWatchlistImage(_ image: UIImage) {
        watchlistImagesCache.append(image)
    }

    
//    func saveFavorites() {
//        let movieEncoder = JSONEncoder()
//        if let encodedFavorites = try? movieEncoder.encode(favorites) {
//                    UserDefaults.standard.set(encodedFavorites, forKey: "FavoritesKey")
//                }
//    }
    
}

