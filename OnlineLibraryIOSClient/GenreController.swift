import UIKit

class GenreController: UITableViewController {
    
    private var data: [String] = []
    private var myTableView: UITableView!
    private var delegate: GenreControllerDelegate?
    
    public func setData(data: [String]) {
        let sortedData: [String] = data.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
        self.data = sortedData
    }
    
    public func setDelegate(delegate: GenreControllerDelegate?) {
        self.delegate = delegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Genres", comment: "")
        
        myTableView = UITableView(frame: UIScreen.main.bounds, style: UITableViewStyle.plain)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "GenreCell")
        self.view.addSubview(self.myTableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        doWithSelectedValue(value: data[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "GenreCell", for: indexPath) as UITableViewCell
        cell.textLabel!.text = "\(data[indexPath.row])"
        return cell
    }
    
    private func doWithSelectedValue(value: String) {
        self.navigationController?.popViewController(animated: true)
        delegate?.sendDataFromGenreControllerToPrevController(value: value)
    }
}

protocol GenreControllerDelegate {
    func sendDataFromGenreControllerToPrevController(value: String)
}
