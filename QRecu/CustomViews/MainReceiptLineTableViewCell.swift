//
//  MainReceiptLineTableViewCell.swift
//  QRecu
//
//  Created by Arimac on 2024-11-07.
//

import UIKit

class MainReceiptLineTableViewCell: UITableViewCell {
    
    @IBOutlet weak var smallImage: UIImageView!
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
