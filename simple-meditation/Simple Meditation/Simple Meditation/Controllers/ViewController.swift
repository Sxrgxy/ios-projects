//
//  ViewController.swift
//  Simple Meditation
//
//  Created by dev on 21.09.2025.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var meditations: [Meditation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // applying main color
        view.backgroundColor = UIColor(red: 245/255, green: 242/255, blue: 238/255, alpha: 1)
        tableView.backgroundColor = UIColor(red: 245/255, green: 242/255, blue: 238/255, alpha: 1)
        
        // load meditations
        loadMeditations() //loadFallbackData()
        
        tableView.separatorStyle = .none // remove cell separators
        
        // we point a current view to be a tableView delegate?
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        
        // register MeditationCell xib as a reusable cell template for tableView
        tableView.register(UINib(nibName: "MeditationCell", bundle: nil), forCellReuseIdentifier: "MeditationCell")
    }
    
    // нужно подключиться по url, скачать файл, преобразовать его в meditations struct и сохранить в let meditations
    private func loadMeditations() {
        // 1. Create URL (handle invalid url)
        guard let url = URL(string: API.meditationsURL) else { return loadFallbackData() }
        
        // 2. Start URL session
        let session = URLSession(configuration: .default)
        // 3. Give session a task
        let task = session.dataTask(with: url) { [weak self] (data, url, error) in
            // Handle errors
            if let error = error {
                print("Falied to load: \(error)")
                DispatchQueue.main.async {
                    self?.loadFallbackData()
                }
                return
            }
            
            if let data = data {
                // prepare data
                let decoder = JSONDecoder()
                
                do {
                    // MeditationsResponse.self is an empty struct used to map requested data to it
                    // decode from json response to swift struct
                    let response = try decoder.decode(MeditationsResponse.self, from: data)
                    
                    let meditations = response.meditations
                    
                    // connect to main UI
                    DispatchQueue.main.async {
                        // assign unparsed values to a Class level meditations var
                        self?.meditations = meditations
                        //
                        self?.tableView.reloadData()
                    }
                } catch {
                    print("Parsing error: \(error)")
                    DispatchQueue.main.async {
                        self?.loadFallbackData()
                    }
                    return
                }
            } else {
                print("No data received")
                DispatchQueue.main.async {
                    self?.loadFallbackData()
                }
                return
            }
        }
        //4.Start the task
        task.resume()
    }
    
    private func loadFallbackData() {
        print("Loading fallback data (local meditations)")
        meditations = MeditationDataSource.meditations
        tableView.reloadData()
    }

}

// Table View settings
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    // Number of sections = number of meditations
    func numberOfSections(in tableView: UITableView) -> Int {
        return meditations.count
    }
    
    // TableView cells count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 //meditations.count
    }
    
    // Buttom spacing
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    // Row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // Cell setting
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // init UITableViewCell cell from a MeditationCell.swift cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeditationCell", for: indexPath) as! MeditationCell
        
        // object inside a cell
        let meditation = meditations[indexPath.section] //row
        
        // cell attributes (settings)
        cell.label.text = meditation.title
        cell.label.textColor = Colours.darkColor
        
        
        cell.backgroundColor = UIColor.white
        
        cell.selectionStyle = .none // remove selection
        
        // set ImageView symbol
        cell.cellImage.tintColor = Colours.darkColor
        cell.cellImage.image = UIImage(systemName: meditation.imageName)
        
        cell.layer.borderColor = Colours.backgroundColor.cgColor
        cell.layer.borderWidth = 1.5
        cell.layer.cornerRadius = 16.0
        
        return cell
    }
    
    // Cell selection logic
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // set up a sender object name to var
        let meditation = meditations[indexPath.section]
        
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        // haptic press
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        // selection animation
        UIView.animate(withDuration: 0.1, animations: {
            // scale a cell down to 0.95
            cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            // scale with bounce to a normal size
            UIView.animate(
                withDuration: 0.4,
                delay: 0,
                usingSpringWithDamping: 0.6,
                initialSpringVelocity: 0.5,
                options: [],
                animations: {
                    cell.transform = .identity
                }
            )
        }
        
        // perform segue to a Player View
        performSegue(withIdentifier: SegueIdentifier.showPlayer, sender: meditation)
    }
    
    // Populate Player View with meditations data before sugueing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.showPlayer {
            if let playerVC = segue.destination as? PlayerViewController {
                if let meditation = sender as? Meditation {
                    playerVC.meditation = meditation
                }
            }
                
        }
    }
}
