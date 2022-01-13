//
//  CommentTableViewCell.swift
//  MapApp
//
//  Created by 蔡尚諺 on 2022/1/8.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    var review: Reviews!
    var dateFormatter = DateFormatter()
    
    @IBOutlet weak var author_nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var profile_photo_urlImageView: UIImageView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var relative_timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profile_photo_urlImageView.layer.cornerRadius = profile_photo_urlImageView.bounds.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//    }
    
    func updateUI() {
        
        if let review = review {
            
            GoogleMapListController.shared.getPhoto(url: review.profile_photo_url) { image in
                DispatchQueue.main.async {
                    self.profile_photo_urlImageView.image = image

                }
            }
            
            commentTextView.text = review.text
            author_nameLabel.text = review.author_name
            relative_timeLabel.text = review.relative_time_description
            
            dateFormatter.dateFormat = "yyyy年MM月dd日"
            timeLabel.text = dateFormatter.string(from: review.time)
        }
    }
}
