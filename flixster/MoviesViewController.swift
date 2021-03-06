//
//  MoviesViewController.swift
//  flixster
//
//  Created by Feizza Fazilatun on 2/9/21.
//

import UIKit
import AlamofireImage
class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
   //Outlet-Connection to tableView
    @IBOutlet weak var tableView: UITableView!
    //Variables created here are called properties (available for the lifetime of the screen):
    var movies = [[String:Any]]() //An array of dictionaries
    
    
    //Everything in this function is carried out the moment the screen first appears:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        // Do any additional setup after loading the view.
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            
            self.movies = dataDictionary["results"] as! [[String:Any]] //cast it as String:Any
            self.tableView.reloadData() //calls functoin again after api data is retrieved and stored
            print(self.movies)
              // TODO: Get the array of movies
              // TODO: Store the movies in a property to use elsewhere
              // TODO: Reload your table view data

           }
        }
        task.resume()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        //dequeueReusableCell: if there are any cells ofscreen just give me that recycled cell
        //if no cells are available then create new one --- saves memory/space
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl+posterPath)
        cell.posterView.af_setImage(withURL: posterUrl!)
        //The question mark -> swift optionals
        return cell
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Find the selected movie
        let cell = sender as!  UITableViewCell
        let indexPath  = tableView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
        
        // Pass the selected movie to the details view controller
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie=movie
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

}
