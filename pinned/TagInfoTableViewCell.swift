//
//  TagInfoTableViewCell.swift
//  pinned
//
//  Created by 汤坤 on 2017/4/10.
//  Copyright © 2017年 Kun Soup. All rights reserved.
//

import UIKit

class TagInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var description_lb: UILabel!
    @IBOutlet weak var extended_lb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
