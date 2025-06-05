//
//  TechnologyTableViewCell.swift
//  TeddNews
//
//  Created by Ko Minhyuk on 6/6/25.
//

import UIKit

class TechnologyTableViewCell: UITableViewCell {
    @IBOutlet weak var techImage: UIImageView!
    @IBOutlet weak var techhTitle: UILabel!
    @IBOutlet weak var techDescription: UILabel!
    @IBOutlet weak var techhAutor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUnderLineText(label: techhTitle)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
