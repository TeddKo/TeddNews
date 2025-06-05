//
//  AllTableViewCell.swift
//  TeddNews
//
//  Created by Ko Minhyuk on 6/6/25.
//

import UIKit

class AllTableViewCell: UITableViewCell {

    @IBOutlet weak var allImage: UIImageView!
    @IBOutlet weak var allTitle: UILabel!
    @IBOutlet weak var allDescription: UILabel!
    @IBOutlet weak var allName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUnderLineText(label: allTitle)
        
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
