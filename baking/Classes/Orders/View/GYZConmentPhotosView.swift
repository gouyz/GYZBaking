//
//  GYZConmentPhotosView.swift
//  baking
//  上传图片view
//  Created by gouyz on 2017/4/3.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZConmentPhotosView: UIView {
    
    var delegate: GYZConmentPhotosViewDelegate?
    
    var imageViewsArray:[UIImageView] = []
    
    //5列，列间隔为5，距离屏幕边距左右各10
    let imgWidth: CGFloat = (kScreenWidth - 40)*0.2
    
    var selectImgs: [UIImage]?{
        didSet{
            if let imgArr = selectImgs {
                
                for index in imgArr.count ..< imageViewsArray.count {
                    let imgView: UIImageView = imageViewsArray[index]
                    imgView.isHidden = true
                }
                
                let perRowItemCount = 5
                let margin: CGFloat = 5
                for (index,item) in imgArr.enumerated() {
                    let columnIndex = index % perRowItemCount
                    let rowIndex = index/perRowItemCount
                    
                    let imgView: UIImageView = imageViewsArray[index]
                    imgView.isHidden = false
                    imgView.image = item
                    imgView.frame = CGRect.init(x: CGFloat.init(columnIndex) * (imgWidth + margin), y: CGFloat.init(rowIndex) * (imgWidth + margin), width: imgWidth, height: imgWidth)
                }
                
                let columnIndex = imgArr.count % perRowItemCount
                let rowIndex = imgArr.count/perRowItemCount
                
                addImgBtn.frame = CGRect.init(x: CGFloat.init(columnIndex) * (imgWidth + margin), y: CGFloat.init(rowIndex) * (imgWidth + margin), width: imgWidth, height: imgWidth)
                
            }
        }
    }

    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        for _ in 0 ..< kMaxSelectCount{
            let imgView: UIImageView = UIImageView()
            addSubview(imgView)
            imageViewsArray.append(imgView)
        }
        
        addImgBtn.backgroundColor = kBackgroundColor
        addImgBtn.addOnClickListener(target: self, action: #selector(addImgOnClick))
        addSubview(addImgBtn)
        
        addImgBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.top.equalTo(self)
            make.size.equalTo(CGSize.init(width: imgWidth, height: imgWidth))
        }
    }
    
    /// 添加照片
    lazy var addImgBtn: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_conment_add"))
    /// 添加照片
    func addImgOnClick() {
        delegate?.didClickAddImage()
    }
}

protocol GYZConmentPhotosViewDelegate {
    func didClickAddImage();
}
