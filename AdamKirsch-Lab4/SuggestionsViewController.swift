//
//  SuggestionsViewController.swift
//  AdamKirsch-Lab4
//
//  Created by Adam Kirsch on 10/26/23.
//

import Foundation
import UIKit

class SuggestionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    var suggestions: [Movie] = []
    var suggestionsImageCache: [UIImage?] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarItem.image = UIImage(named: "Die Icon")
        tableView.delegate = self
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRandomMovies { movies in
            guard let suggestions = movies else {
                return
            }
            self.suggestions = suggestions
            DispatchQueue.global(qos: .userInitiated).async {
                self.suggestionsImageCache = []
                for movie in self.suggestions {
                    if let posterPath = movie.poster_path {
                        let urlString = "https://image.tmdb.org/t/p/w500\(posterPath)"
                        if let url = URL(string: urlString), let data = try? Data(contentsOf: url) {
                            let image = UIImage(data: data)
                            self.suggestionsImageCache.append(image)
                        } else {
                            self.suggestionsImageCache.append(UIImage(named: "No Poster"))
                        }
                    } else {
                        self.suggestionsImageCache.append(UIImage(named: "No Poster"))
                    }
                }
            }
            self.suggestionsImageCache = self.suggestionsImageCache
               
               DispatchQueue.main.async {
                   self.updateTable()
               }
           }
        
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        cell.textLabel!.text = suggestions[indexPath.row].title
        
        cell.detailTextLabel?.text = suggestions[indexPath.row].overview
        if indexPath.item < suggestionsImageCache.count
        {
            cell.imageView?.image = suggestionsImageCache[indexPath.row]
        }
        else
        {
            cell.imageView?.image = nil
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions.count
    }
    func updateTable() {
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewControllerIdentifier") as? DetailViewController {
            let selectedMovie = suggestions[indexPath.row]
            let selectedImage = suggestionsImageCache[indexPath.row]
            
            detailViewController.movie = selectedMovie
            detailViewController.image = selectedImage
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    func fetchRandomMovies(completion: @escaping ([Movie]?) -> Void) {
        let apiKey = "8848174acc74b7248149b4191e075d61"
        let baseUrl = "https://api.themoviedb.org/3/discover/movie"
        let randomPage = Int.random(in: 1...500)
        let queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "page", value: String(randomPage))
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
                let randomMovies = Array(movieResponse.results.prefix(20))
                completion(randomMovies)
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    
    
}
