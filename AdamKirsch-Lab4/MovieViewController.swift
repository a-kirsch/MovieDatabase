//
//  ViewController.swift
//  AdamKirsch-Lab4
//
//  Created by Adam Kirsch on 10/16/23.
//

import Foundation
import UIKit

struct APIResults:Decodable {
let page: Int
let total_results: Int
let total_pages: Int
let results: [Movie]
}
struct Movie: Codable {
let id: Int!
let poster_path: String?
let title: String
let release_date: String?
let vote_average: Double
let overview: String
let vote_count:Int!
}


class MovieViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIContextMenuInteractionDelegate {

    

    


    @IBOutlet weak var movieCollection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.delegate = self
        movieCollection.delegate = self
        if let moviesData = UserDefaults.standard.data(forKey: "moviesKey") {
                    let movieDecoder = JSONDecoder()
                    if let loadedMovies = try? movieDecoder.decode([Movie].self, from: moviesData) {
                        self.movies = loadedMovies
                    }
                }
            }
    var movies: [Movie] = []
    var imageCache: [UIImage?] = []
    let stateController = StateController.shared
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText: String = searchBar.text ?? ""
        self.spinner.startAnimating()
        searchMovies(query: searchText) { apiResults in
            guard let movies = apiResults?.results else {
                self.spinner.stopAnimating()
                return
            }
            self.movies = movies
            DispatchQueue.global(qos: .userInitiated).async {
                self.imageCache = []
                do {
                    for movie in self.movies {
                        print(movie.title)
                        if let posterPath = movie.poster_path {
                            let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
                            let data = try Data(contentsOf: url!)
                            let image = UIImage(data: data)
                            self.imageCache.append(image)
                        }else {
                            self.imageCache.append(UIImage(named: "No Poster"))
                        }
                    }
                    DispatchQueue.main.async {
                        self.spinner.stopAnimating()
                        self.movieCollection.reloadData()
                    }
            } catch {
                print("some error")
            }
            }
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.movieCollection.reloadData()
    }
    func numberOfSections(in movieCollection: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ movieCollection: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 94.0, height: 174.0)
    }
    
    func collectionView(_ movieCollection: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = movieCollection.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! MovieCollectionViewCell
        let interaction = UIContextMenuInteraction(delegate: self)
        cell.addInteraction(interaction)
        cell.isUserInteractionEnabled = true
        let movie = movies[indexPath.item]
        
        if indexPath.item < imageCache.count
        {
            cell.posterImageView.image = imageCache[indexPath.item]
        }
        else
        {
            cell.posterImageView.image = nil
        }
        cell.titleLabel.numberOfLines = 0
        cell.titleLabel.textAlignment = .center
        cell.titleLabel.textColor = UIColor.white
        cell.titleLabel.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
        cell.titleLabel.text = movie.title


        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewControllerIdentifier") as? DetailViewController {
            let selectedMovie = movies[indexPath.row]
            let selectedImage = imageCache[indexPath.row]
            
            detailViewController.movie = selectedMovie
            detailViewController.image = selectedImage
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }

    
    func searchMovies(query: String, completion: @escaping (APIResults?) -> Void) {
        let apiKey = "8848174acc74b7248149b4191e075d61"
        let baseUrl = "https://api.themoviedb.org/3/search/movie"
        let queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "query", value: query)
        ]
        
        var urlComponents = URLComponents(string: baseUrl)
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {
            print("Invalid URL")
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let movieResponse = try decoder.decode(APIResults.self, from: data)
                completion(movieResponse)
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
   
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let locationInCollectionView = interaction.location(in: movieCollection)
        guard let indexPath = movieCollection.indexPathForItem(at: locationInCollectionView) else {
                return nil
            }
            let selectedMovie = movies[indexPath.row]
            let selectedImage = imageCache[indexPath.row] ?? UIImage(named: "No Poster")

            let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions -> UIMenu? in
                let favoriteAction = UIAction(title: "Add to Favorites", image: UIImage(named: "Favorite Icon")) { _ in
                    let defaults = UserDefaults.standard
                    let encoder = JSONEncoder()
                    if let encoded = try? encoder.encode(selectedMovie){
                        defaults.set(encoded, forKey: "\(String(describing: selectedMovie.id))")
                        if let currentImage = selectedImage?.pngData(){
                            defaults.set(currentImage, forKey: "\(String(describing: selectedMovie.id)).png")
                        }
                    }
                    self.stateController.addFavoriteMovie(selectedMovie)
                    self.stateController.addFavoriteImage(selectedImage!)
                }
                let watchlistAction = UIAction(title: "Add to Watchlist", image: UIImage(named: "Watchlist Icon")) { _ in
                    self.stateController.addWatchlistMovie(selectedMovie)
                    self.stateController.addWatchlistImage(selectedImage!)
                }
                let detailsAction = UIAction(title: "View Details", image: UIImage(named: "Movie Icon")) { [self] _ in
                    if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewControllerIdentifier") as? DetailViewController {
                        let selectedMovie = self.movies[indexPath.row]
                        let selectedImage = self.imageCache[indexPath.row]
                        
                        detailViewController.movie = selectedMovie
                        detailViewController.image = selectedImage
                        navigationController?.pushViewController(detailViewController, animated: true)
                    }
                }

                return UIMenu(title: "", children: [favoriteAction, watchlistAction, detailsAction])
            }

            return configuration
    }
    
    
}

