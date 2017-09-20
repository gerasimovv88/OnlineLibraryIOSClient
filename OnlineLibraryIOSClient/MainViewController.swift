import UIKit
import Foundation

class MainViewController: UIViewController, AuthorControllerDelegate, GenreControllerDelegate {
    
    private let allAuthorsURL = "http://127.0.0.1:8080/authors/all"
    private let allGenresURL = "http://127.0.0.1:8080/genres/all"
    private let searchBooksURL = "http://127.0.0.1:8080/books/search"

    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var genreTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("MainMenu", comment: "")
        customSearchButton()
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
        var urlRequest = URLRequest(url: URL(string: allAuthorsURL)!)
        urlRequest.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
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
        var urlRequest = URLRequest(url: URL(string: allGenresURL)!)
        urlRequest.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
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
    
    
    @IBAction func searchBook(_ sender: UIButton) {
        if let title = titleTextField.text {
            if (!title.isEmpty) {
                requestTosearchBookByParameter(key: "title", value: title) { (result, error) -> () in
                    DispatchQueue.main.async() {
                        if (error != nil) {
                            self.present(Toast().showNegativeMessage(message: error!.localizedDescription), animated: true, completion: nil)
                        }
                        if (!result.isEmpty) {
                            self.showFindedBooks(result)
                        } else {
                            self.present(Toast().showNegativeMessage(message: NSLocalizedString("NotFound", comment: "")), animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        if let author = authorTextField.text {
            if (!author.isEmpty) {
                requestTosearchBookByParameter(key: "author", value: author) { (result, error) -> () in
                    DispatchQueue.main.async() {
                        if (error != nil) {
                            self.present(Toast().showNegativeMessage(message: error!.localizedDescription), animated: true, completion: nil)
                        }
                        if (!result.isEmpty) {
                            self.showFindedBooks(result);
                        }
                        else {
                            self.present(Toast().showNegativeMessage(message: NSLocalizedString("NotFound", comment: "")), animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        if let genre = genreTextField.text {
            if (!genre.isEmpty) {
                requestTosearchBookByParameter (key: "genre", value: genre) { (result, error) -> () in
                    DispatchQueue.main.async() {
                        if (error != nil) {
                            self.present(Toast().showNegativeMessage(message: error!.localizedDescription), animated: true, completion: nil)
                        }
                        if (!result.isEmpty) {
                            self.showFindedBooks(result);
                        } else {
                            self.present(Toast().showNegativeMessage(message: NSLocalizedString("NotFound", comment: "")), animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }

    func requestTosearchBookByParameter(key: String, value: String, callback: @escaping (_ result: [Book], _ error: Error?) -> ()) {
        var processedResult: [Book] = []
        let param = Utils.stringToEscapedString(string: "?\(key)=\(value)")
        var urlRequest = URLRequest(url: URL(string: searchBooksURL + param)!)
        urlRequest.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                callback(processedResult, error)
                return
            }
            if let booksJson = try? JSONSerialization.jsonObject(with: data!, options: []) as? [AnyObject] {
                for value in booksJson! {
                    let book = Book();
                    if let author = value[1] as? String {
                        book.author = author
                    }
                    if let genre = value[2] as? String {
                        book.genre = genre
                    }
                    if let bookPart = value[0] as? AnyObject {
                        book.id = bookPart["id"] as? Int64
                        book.title = bookPart["title"] as? String
                        book.image = bookPart["image"] as? String
                    }
                    processedResult.append(book)
                }
            }

            callback(processedResult, nil)
        }
        task.resume()
    }

    private func showFindedBooks(_ result: [Book]) {
        let searchBookController = self.storyboard?.instantiateViewController(withIdentifier: "SearchBookController") as! SearchBookController
        searchBookController.setData(data: result)
        self.navigationController?.pushViewController(searchBookController, animated: true)
    }
    
    private func customSearchButton() {
        searchButton.backgroundColor = UIColor.green
        searchButton.layer.cornerRadius = 5
        searchButton.layer.borderWidth = 1
        searchButton.layer.borderColor = UIColor.black.cgColor
    }
}
