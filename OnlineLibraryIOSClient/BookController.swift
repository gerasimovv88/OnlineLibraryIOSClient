import Foundation
import UIKit

class BookController: UIViewController {
    private let readBookURL: String = "http://127.0.0.1:8080/books/download"
    private var book: Book?
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var readBookButton: UIButton!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var bookGenre: UILabel!
    @IBOutlet weak var bookYear: UILabel!
    @IBOutlet weak var bookPages: UILabel!
    @IBOutlet weak var bookPublisher: UILabel!
    @IBOutlet weak var bookAverageRating: UILabel!
    @IBOutlet weak var bookIsbn: UILabel!
    @IBOutlet weak var bookDescription: UITextView!

    public func setData(book: Book) {
        self.book = book
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("ShowInformationAboutBook", comment: "")
        self.readBookButton.setTitle(NSLocalizedString("ReadBook", comment: ""), for: .normal)
        fillDataOnPage()
        customReadBookButton()
    }
    
    public func fillDataOnPage() {
        if let book = self.book {
            if let imageString = book.image {
                let thumbnailData =  Data(base64Encoded: imageString as String, options: NSData.Base64DecodingOptions())
                if let data = thumbnailData {
                    self.bookImage.image = UIImage(data: data)
                }
            }
            if let title = book.title {
                self.bookTitle.text = NSLocalizedString("Title", comment: "") + ": " + title;
            }
            if let author = book.author {
                self.bookAuthor.text = NSLocalizedString("Author", comment: "") + ": " + author;
            }
            if let genre = book.genre {
                self.bookGenre.text = NSLocalizedString("Genre", comment: "") + ": " + genre;
            }
            if let year = book.year {
                self.bookYear.text = NSLocalizedString("Year", comment: "") + ": " + String(year);
            }
            if let pages = book.pages {
                self.bookPages.text = NSLocalizedString("PagesCount", comment: "") + ": " + String(pages);
            }
            if let publisher = book.publisher {
                self.bookPublisher.text = NSLocalizedString("Publisher", comment: "") + ": " + publisher;
            }
            if let averageRating = book.averageRating {
                self.bookAverageRating.text = NSLocalizedString("AverageRating", comment: "") + ": " + String(averageRating);
            }
            if let isbn = book.isbn {
                self.bookIsbn.text = NSLocalizedString("Isbn", comment: "") + ": " + isbn;
            }
            if let description = book.description {
                self.bookDescription.text = NSLocalizedString("Description", comment: "") + ": " + description;
            }

        }
    }
    
    @IBAction func readBook(_ sender: UIButton) {
        if let book = self.book {
            if let bookId = book.id {
                var stringUrl: String = Utils.stringToEscapedString(string: readBookURL + "?id=" + String(bookId))
                let url : URL = URL(string: stringUrl)!
                let readBookController = self.storyboard?.instantiateViewController(withIdentifier: "ReadBookController") as! ReadBookController
                self.navigationController?.pushViewController(readBookController, animated: true)
                readBookController.setUrl(url: url)
            }
        }
    }
    
    private func customReadBookButton() {
        readBookButton.backgroundColor = UIColor.green
        readBookButton.layer.cornerRadius = 5
        readBookButton.layer.borderWidth = 1
        readBookButton.layer.borderColor = UIColor.black.cgColor
    }
}
