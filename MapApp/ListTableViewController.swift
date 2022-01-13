//
//  ListTableViewController.swift
//  MapApp
//
//  Created by 蔡尚諺 on 2022/1/6.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    var location = "25.04174,121.56661"//座標預設為台北市
    var listResponse: ListResponse?
    
    let listController = GoogleMapListController()
    
    @IBOutlet weak var listSearchBar: UISearchBar!
    /*---ActivityIndicator---*/
    let loadingView = UIView()
    let activityIndicator = UIActivityIndicatorView()
    let loadingLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Place List"
        listSearchBar.delegate = self
        setActivityIndicatorView()
        hideActivityIndicatorView()
    }
    
    @IBSegueAction func toDetailPage(_ coder: NSCoder) -> ReviewsViewController? {
        
        let item = listResponse?.results[tableView.indexPathsForSelectedRows!.first!.row]
        let reviewsVC = ReviewsViewController(coder: coder)
        reviewsVC?.item = item
        return reviewsVC
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listResponse?.results.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(ListTableViewCell.self)", for: indexPath) as! ListTableViewCell
        
        let item = listResponse?.results[indexPath.row]
        cell.updateCell(item: item)
        return cell
    }
    
    //去下一頁
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetailPage", sender: nil)
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ListTableViewController {
    
    func setActivityIndicatorView() {
        
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (tableView.frame.width / 2) - (width / 2)
        let y = (tableView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        // Sets loading text
        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading..."
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)
        
        // Sets spinner
        activityIndicator.style = .medium
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        activityIndicator.startAnimating()
        
        // Adds text and spinner to the view
        loadingView.addSubview(loadingLabel)
        loadingView.addSubview(activityIndicator)
        tableView.addSubview(loadingView)
        
    }
    
    func showActivityIndicatorView() { loadingView.isHidden = false }
    
    func hideActivityIndicatorView() { loadingView.isHidden = true }
    
}

//SearchBar
extension ListTableViewController: UISearchBarDelegate{
    
    //搜尋文字改變時會觸發
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        //搜尋時跳出loading
        showActivityIndicatorView()
        
        GoogleMapListController.shared.fetchNearbySearch(location: location, keyword: searchText) { listresponse in //寒舍艾美
            self.listResponse = listresponse

            DispatchQueue.main.async {
                self.tableView.reloadData()
                //找到資料隱藏loading
                self.hideActivityIndicatorView()
            }
        }
        
    }
    
    //點擊search後會觸發
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        //收鍵盤
        searchBar.resignFirstResponder()
    }
    
}
