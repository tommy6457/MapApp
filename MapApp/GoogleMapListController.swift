//
//  GoogleMapListController.swift
//  MapApp
//
//  Created by 蔡尚諺 on 2022/1/6.
//

import Foundation
import UIKit


class GoogleMapListController {
    
    static let key = "Your_API_KEY"
    static var shared = GoogleMapListController()
    
    //Place Search - NearbySearch
    /*  location: 經緯度
     radius：範圍（公尺）
     keyword：搜尋關鍵字
     language：語言
     key：個人的api key*/
    func fetchNearbySearch(location: String, keyword: String, completion: @escaping (ListResponse?) -> Void){
        if let url = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(location)&radius=1000&keyword=\(keyword)&language=zh-TW&key=\(GoogleMapListController.key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data,
                   let response = response as? HTTPURLResponse,
                   response.statusCode == 200,
                   error == nil{
                    
                    do {
                        let decoder = JSONDecoder()
                        completion(try decoder.decode(ListResponse.self, from: data))
                    } catch  {
                        completion(nil)
                    }
                    
                }else{
                    print("錯誤：\(error)")
                }
            }.resume()
            
        }else{
            print("URL失敗")
        }
    }
    
    //Place Details - Place Details Requests
    func fetchPlaceDetail(place_id: String, completion: @escaping (DetailResponse?) -> Void){
        
        if let url = URL(string: "https://maps.googleapis.com/maps/api/place/details/json?place_id=\(place_id)&language=zh-TW&key=\(GoogleMapListController.key)"){
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data,
                   let response = response as? HTTPURLResponse,
                   response.statusCode == 200,
                   error == nil{
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .secondsSince1970 //時間
                        completion(try decoder.decode(DetailResponse.self, from: data))
                    } catch  {
                        print(error)
                        completion(nil)
                    }
                    
                }else{
                    print(error)
                }
            }.resume()
            
        }
    }
    
    func getPhoto(url: String , completion: @escaping (UIImage?) -> Void) {
        
        if let url = URL(string: url){
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data,
                   let response = response as? HTTPURLResponse,
                   response.statusCode == 200,
                   error == nil{
                    completion(UIImage(data: data))
                }else{
                    print(error)
                }
            }.resume()
            
        }
    }
    
}

//--------------------Place Search - NearbySearch--------------------start
//最外層
struct ListResponse: Codable {
    var results: [itemResults]
    var status: String
    
}

//裏層
struct itemResults: Codable {
    var name: String        //地標名稱
    var place_id: String    //id （for 抓詳細資料使用）
    var vicinity: String    //地址
}
//--------------------Place Search - NearbySearch--------------------end


//--------------------Place Details - Place Details Requests--------------------start

struct DetailResponse: Codable {
    var result: InfoResults
}

struct InfoResults: Codable {
    var name: String                //餐廳名稱
    var photos: [PhotosResults]     //照片
    var reviews: [Reviews]          //評論
    
}

struct PhotosResults: Codable{
    var photo_reference: String
    
}

struct Reviews: Codable{
    var author_name: String
    var profile_photo_url: String
    var relative_time_description: String
    var text: String
    var time: Date
    
}
//--------------------Place Details - Place Details Requests--------------------end
