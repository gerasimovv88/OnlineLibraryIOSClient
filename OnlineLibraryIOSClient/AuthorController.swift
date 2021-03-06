import UIKit

class AuthorController: UITableViewController {
    
    private var data: [String] = []
    private var myTableView: UITableView!
    private var delegate: AuthorControllerDelegate?
    
    public func setData(data: [String]) {
        self.data = data
    }
    
    public func setDelegate(delegate: AuthorControllerDelegate?) {
        self.delegate = delegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Authors", comment: "")
        
        myTableView = UITableView(frame: UIScreen.main.bounds, style: UITableViewStyle.plain)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "AuthorCell")
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
        let cell = myTableView.dequeueReusableCell(withIdentifier: "AuthorCell", for: indexPath) as UITableViewCell
        cell.textLabel!.text = "\(data[indexPath.row])"
        return cell
    }
    
    private func doWithSelectedValue(value: String) {
        self.navigationController?.popViewController(animated: true)
        delegate?.sendDataFromAuthorControllerToPrevController(value: value)
    }
}

protocol AuthorControllerDelegate {
    func sendDataFromAuthorControllerToPrevController(value: String)
}
