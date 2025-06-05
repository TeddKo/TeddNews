//
//  EducationTableViewCell.swift
//  TeddNews
//
//  Created by Ko Minhyuk on 6/6/25.
//

import UIKit

class EducationTableViewCell: UITableViewCell {

    @IBOutlet weak var eduImage: UIImageView!
    @IBOutlet weak var eduTitle: UILabel!
    @IBOutlet weak var eduDescription: UILabel!
    @IBOutlet weak var eduAuthor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUnderLineText(label: eduTitle)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
