//
//  FavoriteViewController.swift
//  AdamKirsch-Lab4
//
//  Created by Adam Kirsch on 10/23/23.
//

import UIKit

class FavoriteViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let stateController = StateController.shared
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        updateTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        updateTable()
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        cell.textLabel!.text = stateController.favorites[indexPath.row].title
        
        cell.detailTextLabel?.text = stateController.favorites[indexPath.row].overview
        
        cell.imageView?.image = stateController.favoriteImagesCache[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stateController.favorites.count
    }
    func updateTable() {
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            defaults.removeObject(forKey: "\(String(describing: stateController.favorites[indexPath.row].id))")
            defaults.removeObject(forKey: "\(String(describing: stateController.favorites[indexPath.row].id)).png")
            stateController.favorites.remove(at: indexPath.row)
            stateController.favoriteImagesCache.remove(at: indexPath.row)
            updateTable()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewControllerIdentifier") as? DetailViewController {
            let selectedMovie = stateController.favorites[indexPath.row]
            let selectedImage = stateController.favoriteImagesCache[indexPath.row]
            
            detailViewController.movie = selectedMovie
            detailViewController.image = selectedImage
            navigationController?.pushViewController(detailViewController, animated: true)
        }
        
        
    }
    
    func fetchData(){
        stateController.favorites = []
        stateController.favoriteImagesCache = []
        for key in defaults.dictionaryRepresentation().keys{
            if(key.suffix(4) != ".png"){
                if let savedMovie = defaults.object(forKey: key) as? Data {
                               let decoder = JSONDecoder()
                               if let currentFavorite = try? decoder.decode(Movie.self, from: savedMovie) {
                                   stateController.favorites.append(currentFavorite)
                                   if let moviePoster = defaults.object(forKey: "\(String(describing: currentFavorite.id)).png") as? Data, let currentFavoriteImage = UIImage(data:moviePoster){
                                       stateController.favoriteImagesCache.append(currentFavoriteImage)
                                   }
                                   else{
                                       stateController.favoriteImagesCache.append(UIImage(named: "No Poster")!)
                                   }
                               }
                           }
            }
           
        }
    }
    
    
    
    
    @IBAction func clearFavorites(_ sender: Any) {
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
            stateController.favorites = []
            stateController.favoriteImagesCache = []
            updateTable()
        }
    }
    
}
