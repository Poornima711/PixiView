//
//  QueryTableViewCell.swift
//  PixiView
//
//  Created by tcs on 17/01/21.
//

import UIKit

/**
    Search Suggesstion Table View Cell Class.
*/
class QueryTableViewCell: UITableViewCell {

    @IBOutlet weak var queryString: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
