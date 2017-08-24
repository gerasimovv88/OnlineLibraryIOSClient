import UIKit

class MainViewController: UIViewController, AuthorControllerDelegate, GenreControllerDelegate {
    
    private let allAuthorsURL = "http://127.0.0.1:8080/authors/all"
    private let allGenresURL = "http://127.0.0.1:8080/genres/all"

    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var genreTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("MainMenu", comment: "")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func sendDataFromAuthorControllerToPrevController(value: String) {
        authorTextField.text = value
    }
    
    func sendDataFromGenreControllerToPrevController(value: String) {
        genreTextField.text = value
    }
    
    private func requestToGetAllAuthors(callback: @escaping (_ result: [String], _ error: Error?) -> ()) {
        var processedResult: [String] = []
        let url = URL(string: allAuthorsURL)
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                callback(processedResult, error)
                return
            }
            if let authorsJson = try? JSONSerialization.jsonObject(with: data!, options: []) as? [AnyObject] {
                for value in authorsJson! {
                    if let author = value["fio"] as? String {
                        processedResult.append(author)
                    }
                }
            }
            callback(processedResult, nil)
        }
        task.resume()
    }
    
    private func requestToGetAllGenres(callback: @escaping (_ result: [String], _ error: Error?) -> ()) {
        var processedResult: [String] = []
        let url = URL(string: allGenresURL)
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                callback(processedResult, error)
                return
            }
            if let genresJson = try? JSONSerialization.jsonObject(with: data!, options: []) as? [AnyObject] {
                for value in genresJson! {
                    if let genre = value["title"] as? String {
                        processedResult.append(genre)
                    }
                }
            }
            callback(processedResult, nil)
        }
        task.resume()
    }
    
    @IBAction func showAuthorsTable(_ sender: UIButton) {
        requestToGetAllAuthors() { (result, error) -> () in
            DispatchQueue.main.async() {
                if (error != nil) {
                    self.present(Toast().showNegativeMessage(message: error!.localizedDescription), animated: true, completion: nil)
                }
                if !result.isEmpty {
                    let authorController = self.storyboard?.instantiateViewController(withIdentifier: "AuthorController") as! AuthorController
                    authorController.setData(data: result)
                    authorController.setDelegate(delegate: self)
                    self.navigationController?.pushViewController(authorController, animated: true)
                }
            }
        }
    }
    
    @IBAction func showGenresTable(_ sender: UIButton) {
        requestToGetAllGenres() { (result, error) -> () in
            DispatchQueue.main.async() {
                if (error != nil) {
                    self.present(Toast().showNegativeMessage(message: error!.localizedDescription), animated: true, completion: nil)
                }
                if !result.isEmpty {
                    let genreController = self.storyboard?.instantiateViewController(withIdentifier: "GenreController") as! GenreController
                    genreController.setData(data: result)
                    genreController.setDelegate(delegate: self)
                    self.navigationController?.pushViewController(genreController, animated: true)
                }
            }
        }
    }

}
