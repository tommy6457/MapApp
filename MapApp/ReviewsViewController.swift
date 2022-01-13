//
//  ReviewsViewController.swift
//  MapApp
//
//  Created by 蔡尚諺 on 2022/1/11.
//

import UIKit

class ReviewsViewController: UIViewController {
    
    var photos: [PhotosResults]?
    var item: itemResults!
    var detail: DetailResponse?
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var reviewTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewTableView.delegate = self
        reviewTableView.dataSource = self
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        //抓資料
        GoogleMapListController.shared.fetchPlaceDetail(place_id: item.place_id ) { detailresponse in
            self.detail = detailresponse
            DispatchQueue.main.async {
                self.reviewTableView.reloadData()
                self.photosCollectionView.reloadData()
            }
        }
        //標題
        title = item.name
        //        collectionView大小
        setPhotoLayout()
    }
    
    func setPhotoLayout(){
        
        let layout = photosCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: 300, height: 300)
        layout.estimatedItemSize = .zero
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ReviewsViewController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detail?.result.reviews.count ?? 0 //留言評論
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(CommentTableViewCell.self)", for: indexPath) as! CommentTableViewCell
        cell.review = detail?.result.reviews[indexPath.row]
        cell.updateUI()
        
        return cell
        
    }
}

extension ReviewsViewController: UICollectionViewDelegate , UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detail?.result.photos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(PhotosCollectionViewCell.self)",for : indexPath) as! PhotosCollectionViewCell
        //先清空，避免reuse殘留值
        cell.photosImageView.image = nil
        cell.fetchPhotos(photoReference: detail?.result.photos[indexPath.row].photo_reference ?? "") { image in
            DispatchQueue.main.async {
                cell.photosImageView.image = image
                
            }
        }
        
        return cell
    }
    
    //    cell消失時清掉，避免殘留值
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let cell = cell as? PhotosCollectionViewCell {
            cell.task?.cancel()
            cell.task = nil
        }
    }
    
}
