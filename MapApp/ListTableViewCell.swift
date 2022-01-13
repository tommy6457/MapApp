//
//  ListTableViewCell.swift
//  MapApp
//
//  Created by 蔡尚諺 on 2022/1/6.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var vicinityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(item: itemResults?) {
        
        if let item = item {
            nameLabel.text = item.name
            vicinityLabel.text = item.vicinity
        }else{
            nameLabel.text = ""
            vicinityLabel.text = ""
        }
        
    }

}
