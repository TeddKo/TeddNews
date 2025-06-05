//
//  PoliticsTableViewCell.swift
//  TeddNews
//
//  Created by Ko Minhyuk on 6/6/25.
//

import UIKit

class PoliticsTableViewCell: UITableViewCell {
    @IBOutlet weak var politicsImage: UIImageView!
    @IBOutlet weak var politicsTitle: UILabel!
    @IBOutlet weak var politicsDescription: UILabel!
    @IBOutlet weak var politicsAuthor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUnderLineText(label: politicsTitle)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
