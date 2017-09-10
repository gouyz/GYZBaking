//
//  GYZNetWork.swift
//  flowers
//  网络请求库封装
//  Created by gouyz on 2016/11/9.
//  Copyright © 2016年 gouyz. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


/// 网络请求基地址
let BaseRequestURL: String = "http://hp.0519app.com/Home/"
let BaseRequestImgURL: String = "http://hp.0519app.com/Home"


class GYZNetWork: NSObject {
    
    /// POST/GET网络请求
    ///
    /// - parameter url:        请求URL
    /// - parameter isToken:    是否需要传token，默认需要传
    /// - parameter parameters: 请求参数
    /// - parameter method:     请求类型POST/GET
    /// - success: 上传成功的回调
    /// - failture: 上传失败的回调
    static func requestNetwork(_ url : String,
                               isToken: Bool = true,
                          parameters : Parameters? = nil,
                              method : HTTPMethod = .post,
                              encoding: ParameterEncoding = URLEncoding.default,
                             success : @escaping (_ response : JSON)->Void,
                            failture : @escaping (_ error : Error?)-> Void){
        
        let requestUrl = BaseRequestURL + url
        
        Alamofire.request(requestUrl, method: method, parameters: parameters,encoding:encoding,headers: nil).responseJSON(completionHandler: { (response) in
            
            if response.result.isSuccess{
                if let value = response.result.value {
                    
                    success(JSON(value))
                }
            }else{
                failture(response.result.error)
            }
        })
    }
    
    /// POST版本更新网络请求
    ///
    /// - parameter url:        请求URL
    /// - parameter parameters: 请求参数
    /// - parameter method:     请求类型POST/GET
    /// - success: 上传成功的回调
    /// - failture: 上传失败的回调
    static func requestVersionNetwork(_ url : String,
                               parameters : Parameters? = nil,
                               method : HTTPMethod = .post,
                               encoding: ParameterEncoding = URLEncoding.default,
                               success : @escaping (_ response : JSON)->Void,
                               failture : @escaping (_ error : Error?)-> Void){
        
        Alamofire.request(url, method: method, parameters: parameters,encoding:encoding,headers: nil).responseJSON(completionHandler: { (response) in
            
            if response.result.isSuccess{
                if let value = response.result.value {
                    
                    success(JSON(value))
                }
            }else{
                failture(response.result.error)
            }
        })
    }
    
    /// 图片上传
    ///
    /// - Parameters:
    ///   - url: 服务器地址
    ///   - parameters: 参数
    ///   - uploadParam: 上传图片的信息
    ///   - success: 上传成功的回调
    ///   - failture: 上传失败的回调
    static func uploadImageRequest(_ url : String,
                                   parameters : [String:String]? = nil,
                                   uploadParam : [ImageFileUploadParam],
                                   success : @escaping (_ response : JSON)->Void,
                                   failture : @escaping (_ error : Error?)-> Void){
        
        let requestUrl = BaseRequestURL + url
        
        let headers = ["content-type":"multipart/form-data"]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for param in parameters!{
                multipartFormData.append( (param.value.data(using: String.Encoding.utf8)!), withName: param.key)
            }
            
            
            for item in uploadParam{
                multipartFormData.append(item.data!, withName: item.name!, fileName: item.fileName!, mimeType: item.mimeType!)
            }
        }, to: requestUrl,
           headers: headers,
           encodingCompletion: {
            encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response) in
                    if let value = response.result.value {
                        success(JSON(value))
                    }
                })
            case .failure(let encodingError):
                failture(encodingError)
            }
        })
    }
}

class ImageFileUploadParam: NSObject {
    
    /// 图片的二进制数据
    var data : Data?
    
    /// 服务器对应的参数名称
    var name : String?
    
    /// 文件的名称(上传到服务器后，服务器保存的文件名)
    var fileName : String?
    
    /// 文件的MIME类型(image/png,image/jpg等)
    var mimeType : String?
}
