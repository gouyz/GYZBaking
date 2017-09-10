//
//  GYZOpenCameraPhotosTool.swift
//  LazyHuiSellers
//  打开系统相机及相册
//  Created by gouyz on 2016/12/16.
//  Copyright © 2016年 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD


struct PhotoSource:OptionSet
{
    let rawValue:Int
    
    static let camera = PhotoSource(rawValue: 1)
    static let photoLibrary = PhotoSource(rawValue: 1<<1)
    
}

typealias finishedImage = (_ image:UIImage) -> ()

class GYZOpenCameraPhotosTool: NSObject {
    
    var finishedImg : finishedImage?
    
    /// 图片是否可编辑
    var isEditor = false
    
    ///单例
    static let shareTool = GYZOpenCameraPhotosTool()
    private override init() {}

    ///选择图片
    ///
    /// - Parameters:
    ///   - controller: 控制器
    ///   - editor: 图片是否可编辑
    ///   - options: 类型
    ///   - finished: 完成后的回调闭包
    
    func choosePicture(_ controller : UIViewController,  editor : Bool,options : PhotoSource = [.camera,.photoLibrary], finished : @escaping finishedImage){
        
        finishedImg = finished
        isEditor = editor
        
        if options.contains(.camera) && options.contains(.photoLibrary){
            
            let alertController = UIAlertController(title: "请选择图片", message: nil, preferredStyle: .actionSheet)
            
            let photographAction = UIAlertAction(title: "拍照", style: .default) { (_) in
                
                self.openCamera(controller: controller, editor: editor)
            }
            let photoAction = UIAlertAction(title: "从相册选取", style: .default) { (_) in
                
                self.openPhotoLibrary(controller: controller, editor: editor)
            }
            
            let cannelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            alertController.addAction(photographAction)
            alertController.addAction(photoAction)
            alertController.addAction(cannelAction)
            
            controller.present(alertController, animated: true, completion: nil)

        } else if options.contains(.photoLibrary){
            
            self.openPhotoLibrary(controller: controller, editor: editor)
        }else if options.contains(.camera){
            
            self.openCamera(controller: controller, editor: editor)
        }
    }
    
    ///打开相册
    
    func openPhotoLibrary(controller : UIViewController,  editor : Bool){
        
        let photo = UIImagePickerController()
        photo.delegate = self
        photo.sourceType = .photoLibrary
        photo.allowsEditing = editor
        controller.present(photo, animated: true, completion: nil)
    }
    
    ///打开相机
    func openCamera(controller : UIViewController,  editor : Bool){
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            MBProgressHUD.showAutoDismissHUD(message: "该设备无摄像头")
            return
        }
        
        let photo = UIImagePickerController()
        photo.delegate = self
        photo.sourceType = .camera
        photo.allowsEditing = editor
        controller.present(photo, animated: true, completion: nil)
    }
}

//MARK:  UIImagePickerControllerDelegate,UINavigationControllerDelegate

extension GYZOpenCameraPhotosTool : UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        guard let image = info[isEditor ? UIImagePickerControllerEditedImage : UIImagePickerControllerOriginalImage] as? UIImage else { return }
        picker.dismiss(animated: true) { [weak self] in
            guard let tmpFinishedImg = self?.finishedImg else { return }
            tmpFinishedImg(image)
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        picker.dismiss(animated: true, completion: nil)
        
    }
}
