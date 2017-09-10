//
//  GYZSegmentView.swift
//  baking
//  自定义segment
//  Created by gouyz on 2017/3/27.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

private let kButtonWidth:CGFloat = 75

protocol GYZSegmentViewDelegate {
    func segmentViewSelectIndex(_ index:Int)
}

class GYZSegmentView: UIView {

    var lineView:UIView?
    var titleArr:Array<String> = []
    var buttonArr:Array<UIButton> = []
    var margin:CGFloat!
    var delegate:GYZSegmentViewDelegate?
    
    func setUIWithArr(_ titleArr:Array<String>){
        self.backgroundColor = kWhiteColor
        
        self.titleArr = titleArr
        margin = (kScreenWidth - (CGFloat(titleArr.count) * kButtonWidth)) / CGFloat(titleArr.count+1)
        for i in 0 ..< titleArr.count  {
            let floatI = CGFloat(i)
            
            let button = UIButton(type: UIButtonType.custom)
            let buttonX = margin*(floatI+1)+floatI*kButtonWidth
            
            button.frame = CGRect(x: buttonX, y: 0, width: kButtonWidth,height: kTitleHeight)
            
            let title = titleArr[i]
            button.setTitle(title, for: UIControlState())
            button.setTitleColor(kGaryFontColor, for: UIControlState())
            
            button.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
            buttonArr.append(button)
            self.addSubview(button)
        }
        buttonSelectIndex(0)
        
        
        // 分割线..没啥用
        let line = UIView(frame: CGRect(x: 0,y: self.frame.height-1,width: kScreenWidth,height: 1))
        line.backgroundColor = kGrayLineColor
        self.addSubview(line)
        
        // 下划线
        lineView = UIView(frame: CGRect(x: margin,y: self.frame.size.height-2,width: kButtonWidth,height: 2))
        lineView?.backgroundColor = kYellowFontColor
        self.addSubview(lineView!)
        
        
        
    }
    func buttonClick(_ button:UIButton){
        let index = buttonArr.index(of: button)
        buttonSelectIndex(index!)
        delegate?.segmentViewSelectIndex(index!)
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollToRate(CGFloat(index!))
        })
    }
    func scrollToRate(_ rate:CGFloat){
        if Int(rate) >= titleArr.count {
            return
        }
        let index = Int(rate)
        let pageRate = rate - CGFloat(index)
        let button = self.buttonArr[index]
        self.lineView?.frame.origin.x = button.frame.origin.x + ( button.frame.width+margin )*pageRate
        buttonSelectIndex(Int(rate + 0.5))
    }
    func buttonSelectIndex(_ index:Int){
        for button in buttonArr {
            button.setTitleColor(kGaryFontColor, for: UIControlState())
        }
        let button = buttonArr[index]
        button.setTitleColor(kYellowFontColor, for: UIControlState())
    }

}
