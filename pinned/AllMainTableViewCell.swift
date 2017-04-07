//
//  AllMainTableViewCell.swift
//  pinned
//
//  Created by 汤坤 on 2017/4/6.
//  Copyright © 2017年 Kun Soup. All rights reserved.
//

import UIKit

class AllMainTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var description_lb: UILabel!
    @IBOutlet weak var extended_lb: UILabel!
    @IBOutlet weak var tags_collectionView: UICollectionView!
    
    var tags: Array<String> = []
    
    func collectionViewDataSourceDelegate(tags: Array<String>) {
        self.tags = tags
        self.tags_collectionView.reloadData()
        
//        let contentSize = self.tags_collectionView.collectionViewLayout.collectionViewContentSize
        
    }
    // MARK: UICollectionView
    func reloadCell(){
        self.tags_collectionView.reloadData()
        self.updateConstraints()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllMain", for: indexPath) as! AllMainNewCollectionViewCell
        
        let tag = self.tags[indexPath.row]
        
        cell.tab_bt?.setTitle(tag, for: .normal)
        
        return cell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.tags_collectionView.dataSource = self
        self.tags_collectionView.delegate = self
        
        self.tags_collectionView!.register(UINib(nibName:"AllMainNewCollectionViewCell", bundle:nil),
                                      forCellWithReuseIdentifier: "AllMain")
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 70, height: 35)
//        layout.estimatedItemSize = CGSize(width: 70, height: 35)
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        self.tags_collectionView.setCollectionViewLayout(layout, animated: false)
        self.tags_collectionView.showsHorizontalScrollIndicator = false
        self.tags_collectionView.showsVerticalScrollIndicator = false
        
//        The relevant UICollectionViewFlowLayout instance is <UICollectionViewFlowLayout: 0x7fe5ebd29390>, and it is attached to <UICollectionView: 0x7fe5ec841200; frame = (8 36; 359 40); clipsToBounds = YES; autoresize = RM+BM; gestureRecognizers = <NSArray: 0x608000259bf0>; layer = <CALayer: 0x6080002277a0>; contentOffset: {0, 0}; contentSize: {90, 40}> collection view layout: <UICollectionViewFlowLayout: 0x7fe5ebd29390>.
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
