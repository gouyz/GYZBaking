//
//  AliPayConfig.swift
//  baking
//  支付宝配置
//  Created by gouyz on 2017/4/26.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import Foundation

/**
 *  partner:合作身份者ID,以 2088 开头由 16 位纯数字组成的字符串。
 *
 */
let kAliPayPartnerID: String = ""
/**
 *  seller:支付宝收款账号,手机号码或邮箱格式。
 */
let kAliPaySeller: String = ""
/**
 *  支付宝服务器主动通知商户 网站里指定的页面 http 路径。
 */
let kAliPayNotifyURL: String = ""
/**
 *  appSckeme:应用注册scheme,在Info.plist定义URLtypes，处理支付宝回调
 */
let kAliPayAppScheme: String = "BakingAliPay"

/// pkcs8 格式私钥串（不包含BEGIN/END,无换行）
let kAliPayPrivateKey: String = "MIIEwAIBADANBgkqhkiG9w0BAQEFAASCBKowggSmAgEAAoIBAQDkxMKyge/4IH0nlkCxSfhOjR6t6qiv4t8PAAWbz/xpA84zgUplpn0NkvNp3zMMwUhbVNYO2Cx3XkM22kb+rjVArwRT75JIAkIkzVMc9J8JrcX8E5Uh9X/6O+PfxVpydmSQyd+e6tmanyGwOfW9BqmfL6oPPh3BhNYuVNfd5yPdpuCNpt1ffo0QHnDKUSZzJnQPejpfc/UKoZSskt/u3Kq9e8QUZQIZfccfDiz28G0jp6vOzaUi8pMrVBLojMxSd8OisrT9JwyL4ueFyDUgk6XfxfgwVD7oE7+Q27ehgvb97W51BjkFaV/nHjE1ebJ9ZBf6Ebomj4xZ+2RUI/q340DBAgMBAAECggEBANaQpXv/2y8CaeBjULH4CujB+3Brk2PEiinrf1cwsDFe3Fv6e+jzSn8cwSkfqyXfcxoWa97oamxbAPfFqqjchB3zCUAghzb6x0b1PWr/FNtjHTrcsxdyx2HQIl6TH84TtScH8LGA3C/l6Rb8hbuRMC6Z6gr527bR/IDgGseKL12HjNXb9NMJdy5C1xMf0OW726C4qInKA9R3t9aatC3+J6ZDqhjbGh6Ra8XnjrDdNxGy//+1OmACuZ/vYzdl2P9jp3NSXanchTp9PWwWaCzMUkBFV+0TysF1gl2BqT81mHoPNRVM19Ui2K9cpd22g5zxOx2MAk3kxwEMwjjgIxYRMAECgYEA/Pkq2q+39uJmO4tvXGd79DAusKzKWn41/0b34FADcN05FrsLdyhBi3o3fVZh7IozdWWEb7ubkfqJf2bld9ZHObaTsRNHVhwVzeBLdUCEfpc3PWcJBlMMIDxFK2yLNJjvOWR/ylz1KSphyWCMaHJFKB32gHC8zJoIMEwA6QluRyECgYEA54F02kJdtWHWXzwnjq7OIKnI8TDHGaWcU6aILcenTwO/RNPsGM3WL7gEGKCoMN+ljLXt5DxJyYWD4O0d7KCWQ48FzlZIM8AastIzctBMMj4dLjk+dft3H089ix7VLSn4oUvj2gR78+RP93CWdOSRd8UFQLL6deR7/nMLi+7o5aECgYEA4w6l90k23qKQzis11gOQTzmb/rnomlakEq/ZNn26yOfXIN7byKTaR913xsjs9cmJrHpk54DFfr4YAcESf4BVx6hnYc2C/vgQXgxOzjwNcC47x6IeiI2r2ZcfIn23aItIVQQuay0KY1uGD6DYBbti9UIHiXsnCqHKbccaHhB36eECgYEAxVU0/MJrTCv8ZitJcLcSXwc6kFTKsdLX4PnnxFYWCCUiiZG3AyGZfA13+GIhW5+XZszA3baCEvPrCPQ1eLkdvLKR+WLUosASQfEpB6oD+SO3DeqfkkPqM1cBF7ANeDT5iMu+id0epzMq8rkWlscqNBRNuOuW0J0VEDySUBIylWECgYEAjgm47ZYtnblzlex+eURH9legA7H9+q6taVpISCmm/ZCn91W3f9e7r/Wdy9CTpPB/4zcBapGyAN4mRcmch3GQuMkMelRyfRgSB/qYs7Jhj2e+lqT1wt87zRXXXa2jDGWnE3gPLeWvn4e2Ys5IujK0qgkAQDjlW0f2tbjJQ5StDZc="

