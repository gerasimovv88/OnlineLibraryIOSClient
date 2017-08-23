import UIKit

class MainViewController: UIViewController {
    
    private let allAuthorsURL = "http://127.0.0.1:8080/authors/all"
    private let allGenresURL = "http://127.0.0.1:8080/genres/all"
    @IBOutlet weak var showAuthors: UIButton!
    @IBOutlet weak var showGenres: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Main menu"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func getAllAuthors() -> [String] {
        var result: [String] = []
        let url = URL(string: allAuthorsURL)
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                self.present(Toast().showNegativeMessage(message: error!.localizedDescription), animated: true, completion: nil)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            if let authorsJson = try? JSONSerialization.jsonObject(with: data, options: []) as? [AnyObject] {
                for value in authorsJson! {
                    if let author = value["fio"] as? String {
                        result.append(author)
                    }
                }
            }
        }
        task.resume()
        return result
    }
    
    private func getAllGenres() -> [String] {
        var result: [String] = []
        let url = URL(string: allGenresURL)
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                self.present(Toast().showNegativeMessage(message: error!.localizedDescription), animated: true, completion: nil)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            if let genresJson = try? JSONSerialization.jsonObject(with: data, options: []) as? [AnyObject] {
                for value in genresJson! {
                    if let genre = value["title"] as? String {
                        result.append(genre)
                    }
                }
            }
        }
        task.resume()
        return result
    }
    
    @IBAction func showAuthorsTable(_ sender: UIButton) {
        let authors = getAllAuthors()
        if !authors.isEmpty {
            let authorController = storyboard?.instantiateViewController(withIdentifier: "AuthorController") as! AuthorController
            authorController.setData(data: authors)
            navigationController?.pushViewController(authorController, animated: true)
        }
    }
    
    @IBAction func showGenresTable(_ sender: UIButton) {
        let genres = getAllGenres()
        if !genres.isEmpty {
//            let genresTable = GenreTableViewController()
//            genresTable.setData(data: genres)
//            self.present(genresTable, animated: true, completion: nil)
        }
    }
}
