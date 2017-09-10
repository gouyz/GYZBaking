//
//  GYZBuyNotesVC.swift
//  baking
//  购买须知
//  Created by gouyz on 2017/6/8.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZBuyNotesVC: GYZBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "购买须知"
        view.addSubview(desLab)
        desLab.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.init(top: kMargin, left: kMargin, bottom: kMargin, right: kMargin))
        }
        
        desLab.text = "  南京焙多芬网络科技有限公司系依照中华人民共和国相关法律、法规成立的主营电商购物平台（以下简称“平台”）的有限责任公司，客户使用本平台购物前，应对以下条款进行确认：\n一、 商家接单后，非经与商家确认客户不得随意取消订单；\n二、 客户应于收货时履行查收和确认订单完成的义务，如对货物质量或数量存疑，应于查收时当场提出并不予确认收货；一经确认收货，即视为货物符合订单约定的标准，订单即告完成，客户不得再以产品未达到约定要求为由申请订单流程倒退或要求卖家重新发货、换货、退货；如客户确有足够证据证明货物于交付时不达标，应当申请平台客服介入处理；\n三、商家对货物承担全部法律责任，可查明商家上游生产商或经销商的，该生产商或经销商与商家承担连带责任；如因商家对货物仓储、运输等存在过失导致的纠纷，生产商或经销商可在向客户承担相关法律责任后对商家进行追偿；\n四、 依据《中华人民共和国刑法》相关规定，制造虚假事实或利用处分人的错误认识进行欺诈，使被害人基于错误认识交付财物致损的，应当承担相应法律责任。利用平台活动，与商家恶意串通骗免相关满减费用，实际上构成骗取相关财产性利益，南京焙多芬网络科技有限公司决不放弃追究其法律责任的权利；\n五、 仅合约客户享受平台活动价，活动详见每期公告；\n六、 本规则一经确认即视为用户对以上条款全部知悉并认可，具有法律效力。"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /// 注册描述
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.numberOfLines = 0
        
        return lab
    }()
}
