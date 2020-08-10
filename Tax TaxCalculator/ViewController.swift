//
//  ViewController.swift
//  Tax TaxCalculator
//
//  Created by Nechan on 2019/09/27.
//  Copyright © 2019 Nechan. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController, GADBannerViewDelegate  {

    @IBOutlet weak var ZeroText: UILabel!
    @IBOutlet weak var EightText: UILabel!
    @IBOutlet weak var TenText: UILabel!
    let formatter = NumberFormatter()
    
    var ClacFlg = false
    var saveText: Double = 0.0
    var flg = 0
    
    //バナー広告
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        
        //広告開始
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        //addBannerViewToView(bannerView)
        //本番　ca-app-pub-4013798308034554/7920663953
        //テスト　ca-app-pub-3940256099942544/2934735716
        //bannerView.adUnitID = "ca-app-pub-4013798308034554/7920663953"
        //bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"  //テスト
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        //広告終わり
    }
    
    //数字ボタン
    @IBAction func TapNumButton(_ sender: UIButton) {
        if ClacFlg == true {
            Clear()
        }
        ClacFlg = false
        
        //zerotextに書いてある数字
        guard let labelNum = ZeroText.text else{
            return
        }
        //文字数制限
        guard  strlen(ZeroText.text!) < 9 else {
            return
        }
        //今押された数字
        guard let senderNum = sender.titleLabel?.text else{
            return
        }
        //加算
        var zeroTaxString = labelNum + senderNum
        //カンマ削除
        zeroTaxString = zeroTaxString.replacingOccurrences(of: ",", with: "")
        //型変換
        let zeroTax = Double(zeroTaxString)
        //税金計算
        TaxClac(Number: zeroTax!)
    }
    
    //クリアボタン
    @IBAction func TapClearButton(_ sender: UIButton) {
        if ClacFlg == true {
            saveText = 0.0
        }
        Clear()
        ClacFlg = false
    }
    
    func Clear(){
        ZeroText.text = ""
        EightText.text = ""
        TenText.text = ""
    }
    
    func TaxClac(Number: Double){
        let zeroTax = Number
        var eightTax = Number * 1.08
        var tenTax = Number * 1.10

        eightTax = round(eightTax)
        tenTax = round(tenTax)

        ZeroText.text = String(formatter.string(from: zeroTax as NSNumber)!)
        EightText.text = String(formatter.string(from: eightTax as NSNumber)!)
        TenText.text = String(formatter.string(from: tenTax as NSNumber)!)
    }

    @IBAction func pushDivide(_ sender: Any) {
        flg = 3
        a()
    }
    
    @IBAction func pushMultiply(_ sender: Any) {
        flg = 2
        a()
    }
    
    @IBAction func pushAdd(_ sender: Any) {
        flg = 1
        a()
    }
    
    func a (){
        if ZeroText.text != "" && ZeroText.text != "0" {
            saveText = transform()
            ClacFlg = true
        }
    }
    
    
    
    @IBAction func pushEqual(_ sender: Any) {
        Clac()
        flg = 0
    }
    
    
    func Clac(){
        var zeroTax = transform()
        
        switch(flg){
        case 0:
            break
        case 1:
            zeroTax = saveText + zeroTax
            break
        case 2:
            zeroTax = saveText * zeroTax
            break
        case 3:
            zeroTax = saveText / zeroTax
            break
        default:
            break
        }
        TaxClac(Number: zeroTax)
    }
    
    func transform() -> Double {
        //zerotextに書いてある数字
        guard let labelNum = ZeroText.text else{
            return 0.0
        }
        //カンマ削除
        let zeroTaxString = labelNum.replacingOccurrences(of: ",", with: "")
        
        //型変換
        return Double(zeroTaxString)!
    }
    
    
    
    
    
    
    
    
    
    
    
    
    //広告開始------------------------------------------------------------------
    func addBannerViewToView(_ bannerView: UIView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        if #available(iOS 11.0, *) {
            positionBannerAtTopOfSafeArea(bannerView)
        }
        else {
            positionBannerAtTopOfView(bannerView)
        }
    }
    @available (iOS 11, *)
    func positionBannerAtTopOfSafeArea(_ bannerView: UIView) {
        // Position the banner. Stick it to the bottom of the Safe Area.
        // Centered horizontally.
        let guide: UILayoutGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate(
            [bannerView.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
             bannerView.topAnchor.constraint(equalTo: guide.topAnchor)]
        )
    }
    func positionBannerAtTopOfView(_ bannerView: UIView) {
        // Center the banner horizontally.
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        // Lock the banner to the top of the bottom layout guide.
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: self.view,
                                              attribute: .top,
                                              multiplier: 1,
                                              constant: 0))
    }
    //広告終わり------------------------------------------------------------


}

