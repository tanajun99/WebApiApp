//
//  TableViewController.swift
//  
//
//  Created by Junya Tanaka on 7/1/15.
//
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate{
    
    var tableView: UITableView?
    var shopInfoList: [shopModel]!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView()
        tableView!.backgroundColor = UIColor.whiteColor()
        tableView!.delegate = self
        tableView!.dataSource = self
        
        self.view.addSubview(tableView!)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView!.frame = self.view.bounds
        
        self.view.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setShopList(shopList: [ShopModel]!) {
        self.shopInfoList = shopList
        tableView?.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //セクションごとの項目数を返す
    //今回はセクション分けがないので、shopListに含まれる要素数を返す
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if shopList == nil {
            return 0
        }else{
            return shopList.count
        }
    }
    
    //indexPathで指定された位置の行を示すUITableViewCellのオブジェクト（せる）を返す
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)  -> UITableViewCell {
        //"Cell"というIdentiferの再利用可能なセルをさがす。
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("Call") as? UITableViewCell
        //無ければ、新規に作成する
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        }
        
        //indexPath.row番目のデータをshopListからとりだす
        let shopData = shopList[indexPath.row]
        
        //せるに店名と住所設定
        cell!.textLabel!.text = shopData.name
        cell!.detailTextLabel!.text = shopData.address
        //せるの右側に表示する画像を設定する
        cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    func tableView(tableView: UITableView, edtimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0 as CGFloat
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //せるが選択状態のままにならないように表示元に戻す
        tableView.deselectRowAtIndexPath(indexPath, animated: ture)
        //親ビューコントローラーに店舗表示以来する
        let parentViewController = self.parentViewController as! ViewController
        parentViewController.parentShopViewController(indexPath.rox)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
