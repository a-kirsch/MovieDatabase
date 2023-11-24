//
//  WatchlistViewController.swift
//  AdamKirsch-Lab4
//
//  Created by Adam Kirsch on 10/23/23.
//

import UIKit


class WatchlistViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let stateController = StateController.shared
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        updateTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         updateTable()
     }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")

        cell.textLabel!.text = stateController.watchlist[indexPath.row].title
        
        cell.detailTextLabel?.text = stateController.watchlist[indexPath.row].overview
        
        cell.imageView?.image = stateController.watchlistImagesCache[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stateController.watchlist.count
    }
    func updateTable() {
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            stateController.watchlist.remove(at: indexPath.row)
            stateController.watchlistImagesCache.remove(at: indexPath.row)
            updateTable()
            }
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewControllerIdentifier") as? DetailViewController {
            let selectedMovie = stateController.watchlist[indexPath.row]
            let selectedImage = stateController.watchlistImagesCache[indexPath.row]
            
            detailViewController.movie = selectedMovie
            detailViewController.image = selectedImage
            navigationController?.pushViewController(detailViewController, animated: true)
        }
        
        
        
    }
    @IBAction func clearWatchlist(_ sender: Any) {
        stateController.watchlist = []
        stateController.watchlistImagesCache = []
        updateTable()
    }
    
    }
    
