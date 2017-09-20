import UIKit

class SearchBookController: UITableViewController {
    
    private var data: [Book] = []
    private var myTableView: UITableView!
    private let getBookURL = "http://127.0.0.1:8080/books/get"
    
    public func setData(data: [Book]) {
        self.data = data
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("FindedBooks", comment: "")

        myTableView = UITableView(frame: UIScreen.main.bounds, style: UITableViewStyle.plain)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SearchBookCell")
        self.view.addSubview(self.myTableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let bookId = data[indexPath.row].id {
            getFullInFormationAboutBookById(bookId: bookId)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "SearchBookCell", for: indexPath) as UITableViewCell
        var currentRow: String = "";
        if let title = data[indexPath.row].title {
            currentRow.append(NSLocalizedString("Title", comment: "") + ": " + title + "\n");
        }
        if let author = data[indexPath.row].author {
            currentRow.append(NSLocalizedString("Author", comment: "") + ": " + author + "\n");
        }
        if let genre = data[indexPath.row].genre {
            currentRow.append(NSLocalizedString("Genre", comment: "") + ": " + genre);
        }
        if let imageString = data[indexPath.row].image {
            let thumbnailData =  Data(base64Encoded: imageString as String, options: NSData.Base64DecodingOptions())
            if let data = thumbnailData {
                cell.imageView?.image = UIImage(data: data)
                
            }
        }
        cell.textLabel?.numberOfLines = 0;
        cell.textLabel?.lineBreakMode = .byWordWrapping;
        cell.layer.borderWidth = 1
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.cornerRadius = 8
        
        cell.textLabel?.text = currentRow;

        return cell
    }
    
    private func requestFullInFormationAboutBookById(bookId: Int64, callback: @escaping (_ result: Book?, _ error: Error?) -> ()) {
        var processedResult: Book?
        let param = Utils.stringToEscapedString(string: "?id=\(bookId)")
        var urlRequest = URLRequest(url: URL(string: getBookURL + param)!)
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
                        book.year = bookPart["year"] as? Int
                        book.pages = bookPart["pages"] as? Int
                        book.publisher = bookPart["publisher"] as? String
                        book.averageRating = bookPart["averageRating"] as? Int
                        book.isbn = bookPart["isbn"] as? String
                        book.image = bookPart["image"] as? String
                        book.description = bookPart["description"] as? String
                    }
                    processedResult = book
                }
            }
            
            callback(processedResult, nil)
        }
        task.resume()
    }
    
    private func getFullInFormationAboutBookById(bookId: Int64) {
        requestFullInFormationAboutBookById(bookId: bookId) { (result, error) -> () in
            DispatchQueue.main.async() {
                if (error != nil) {
                    self.present(Toast().showNegativeMessage(message: error!.localizedDescription), animated: true, completion: nil)
                }
                if let book = result {
                    self.showInformation(result: book)
                } else {
                    self.present(Toast().showNegativeMessage(message: NSLocalizedString("InformationNotAvailable", comment: "")), animated: true, completion: nil)
                }
            }
        }
    }
    
    private func showInformation(result: Book) {
        let bookController = self.storyboard?.instantiateViewController(withIdentifier: "BookController") as! BookController
        bookController.setData(book: result)
        self.navigationController?.pushViewController(bookController, animated: true)
    }


}
