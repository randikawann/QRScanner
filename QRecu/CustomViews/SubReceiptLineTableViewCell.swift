//
//  SubReceiptLineTableViewCell.swift
//  QRecu
//
//  Created by Arimac on 2024-11-07.
//

import UIKit

class SubReceiptLineTableViewCell: UITableViewCell {
    
    @IBOutlet weak var first: UILabel!
    @IBOutlet weak var seconds: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
