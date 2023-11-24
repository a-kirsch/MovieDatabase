//
//  DetailViewController.swift
//  AdamKirsch-Lab4
//
//  Created by Adam Kirsch on 10/20/23.
//

import UIKit


class DetailViewController : UIViewController {
    
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var movieScore: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var watchlistButton: UIButton!
    @IBOutlet weak var movieDescription: UILabel!
    var selectedIndexPath: IndexPath?
    var movie: Movie?
    var image: UIImage?
    var favorites: [Movie] = []
    var favoriteImagesCache: [UIImage] = []
    let stateController = StateController.shared
    var favorited: Bool = false
    var watchlisted: Bool = false
    var watchlist: [Movie] = []
    var watchlistImagesCache: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(movie?.title ?? "Title Not Found")
        moviePoster.image = image
        movieTitle.text = movie?.title
        movieReleaseDate.text = "Release Date:  \(movie?.release_date ?? "Not Found")"
        movieDescription.text = movie?.overview
        movieDescription.numberOfLines = 0
        let x = movie?.vote_average ?? 0.0
        let y = Double(round(10 * x) / 10)
        movieScore.text = "Average score:  \(y)/10"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if stateController.favorites.description.contains((movie?.id.description)!)
        {
            favoriteButton.setTitle("One of your favorites", for: .normal)
            favorited = true
        }
        else
        {
            favoriteButton.setTitle("Add to favorites", for: .normal)
            favorited = false
        }
        if stateController.watchlist.description.contains((movie?.id.description)!)
        {
            watchlistButton.setTitle("On your watchlist", for: .normal)
            watchlisted = true
        }
        else
        {
            watchlistButton.setTitle("Add to watchlist", for: .normal)
            watchlisted = false
        }
    }
    
    
    @IBAction func buttonPressed(_ sender: Any) {
        if !favorited
        {
            let defaults = UserDefaults.standard
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(movie){
                defaults.set(encoded, forKey: "\(String(describing: movie?.id))")
                if let currentImage = image?.pngData(){
                    defaults.set(currentImage, forKey: "\(String(describing: movie?.id)).png")
                }
            }
            stateController.addFavoriteMovie(movie!)
            stateController.addFavoriteImage(image!)
            favorited = true
            favoriteButton.setTitle("One of your favorites", for: .normal)
            
        }
        
    }
    @IBAction func watchlistPressed(_ sender: Any) {
        if !watchlisted
        {
            stateController.addWatchlistMovie(movie!)
            stateController.addWatchlistImage(image!)
            watchlisted = true
            watchlistButton.setTitle("On your watchlist", for: .normal)
        }
        
    }
    
    
    @IBAction func showFullDescription(_ sender: Any) {
        if let popUp = storyboard?.instantiateViewController(withIdentifier: "PopUpModalViewControllerIdentifier") as? PopUpModalViewController {
//          PopUpModalViewController.delegate = self
            let description = movie?.overview
            popUp.movieDescription = description
            navigationController?.pushViewController(popUp, animated: true)
        }
    }
    
    
}
