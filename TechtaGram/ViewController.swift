//
//  ViewController.swift
//  TechtaGram
//
//  Created by 松下怜平 on 2019/07/26.
//  Copyright © 2019 com.iitech. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet var cameraImageView: UIImageView!
    
    //加工する画像
    var originalImage: UIImage!
    
    //加工するためのフィルター
    var filter: CIFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//撮影ボタンのメソッド
    @IBAction func tekePhoto() {
        
        //カメラが使えるか確認
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            //カメラを起動
            
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            
            picker.allowsEditing = true
            
            present(picker, animated: true, completion: nil)
        }else {
            //カメラが使えないときはエラーをコンソールに出す
            print("error")
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        cameraImageView.image = info[.editedImage] as? UIImage
    
        originalImage = cameraImageView.image
        
        dismiss(animated: true, completion: nil)
    }
    //保存用メソッド
    @IBAction func savePhoto() {
        UIImageWriteToSavedPhotosAlbum(cameraImageView.image!, nil, nil, nil)
    }
    
    //フィルター加工のメソッド
    @IBAction func colorFilter() {
        
        let filterImage: CIImage = CIImage(image: originalImage)!
        
        //フィルターの設定
        filter = CIFilter(name: "CIColorControls")!
        filter.setValue(filterImage, forKey: kCIInputImageKey)
        //彩度の調整
        filter.setValue(1.0, forKey: "inputSaturation")
        //明度調整
        filter.setValue(0.5, forKey: "inputBrightness")
        //コントラストの調整
        filter.setValue(2.5, forKey: "inputContrast")
        
        let ctx = CIContext(options: nil)
        let cgImage = ctx.createCGImage(filter.outputImage!, from: filter.outputImage!.extent)
        cameraImageView.image = UIImage(cgImage: cgImage!)
    }
    
    //画像を読み込むメソッド
    @IBAction func openAlbum() {
        //カメラロールを使えるかの確認
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            //カメラロールの画像を選択して表示
            let piker = UIImagePickerController()
            piker.sourceType = .photoLibrary
            piker.delegate = self
            
            piker.allowsEditing = true
            
            present(piker, animated: true, completion: nil)
        }
    }
    
    //SNSに投稿したい時のメソッド
    @IBAction func snsPhoto() {
        
        //投稿するときにいい所に乗せるコメント
        let shareText = "写真がシェアされました"
        
        //投稿する画像の選択
        let shareImage = cameraImageView.image!
        
        //投稿するコメントと画像の準備
        let activityItems: [Any] = [shareText, shareImage]
        
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        let excludedActivityTypes = [UIActivity.ActivityType.postToWeibo, .saveToCameraRoll, .print]
        
        activityController.excludedActivityTypes = excludedActivityTypes
        
        present(activityController, animated: true, completion: nil)
        
    }
}

