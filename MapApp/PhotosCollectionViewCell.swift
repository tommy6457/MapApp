//
//  PhotosCollectionViewCell.swift
//  MapApp
//
//  Created by 蔡尚諺 on 2022/1/8.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    
    var task: URLSessionDataTask?
    
    @IBOutlet weak var photosImageView: UIImageView!
    
    //Place Photos - Place Photo requests
    func fetchPhotos(photoReference: String , completion: @escaping (UIImage?) -> Void){
        
        if let url = URL(string: "https://maps.googleapis.com/maps/api/place/photo?photo_reference=\(photoReference)&maxwidth=1600&key=\(GoogleMapListController.key)"){
            
            task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data,
                   let response = response as? HTTPURLResponse,
                   response.statusCode == 200,
                   error == nil{
                    let photo = UIImage(data: data)
                    completion(photo)
                }else{
                    completion(nil)
                }
                //做完就清掉
                self.task = nil
            }
            task?.resume()
        }
    }
}
