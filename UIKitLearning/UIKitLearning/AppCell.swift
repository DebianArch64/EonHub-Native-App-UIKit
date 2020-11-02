//
//  AppCell.swift
//  UIKitLearning
//
//  Created by DebianArch on 11/1/20.
//

import UIKit
import SDWebImage
class AppCell: UITableViewCell {
    var download: String = ""
    @IBOutlet weak var appName: UILabel!
    
    @IBOutlet weak var appIcon: UIImageView!
    @IBOutlet weak var appButton: UIButton!
    @objc func installApp() {
        UIApplication.shared.open(URL(string: "itms-services://?action=download-manifest&url=https://eonhubapp.com/plists/\(download).plist")!)
       
    }
    
    func setApp(title: AppStruct) {
        download = title.plist
        appName.text = title.name
        appButton.addTarget(self, action: #selector(installApp), for: .touchDown)
        appButton.backgroundColor = .systemPink
        appButton.layer.cornerRadius = 15.0
        appButton.tintColor = UIColor.blue
        appIcon.sd_setImage(with: URL(string: "https://app.eonhubapp.com/images/icons/\(title.icon)"))
        appIcon.layer.cornerRadius = 20
    }
}

class AppCellListScreen: UIViewController {
    
    @IBOutlet weak var EonHubLogo: UIImageView!
    var datas: [AppStruct] = []
    
   
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        datas = createArray()
        EonHubLogo.layer.masksToBounds = false
        EonHubLogo.layer.cornerRadius = EonHubLogo.frame.height / 2
        EonHubLogo.clipsToBounds = true
    }
    func createArray() -> [AppStruct] {
        var tempApps: [AppStruct] = []
        var tempBool: Bool = false
        func idk(completion: @escaping (_ success: Bool) -> Void) {
        let url = URL(string: "https://eonhubapp.com/all.json")
        
        URLSession.shared.dataTask(with: url!) { (data, _ , error) in
            if error == nil && data != nil {
                let jsonData = try! JSONDecoder().decode([AppStruct].self, from: data!)
                for i in jsonData {
                    tempApps.append(AppStruct(name: i.name, plist: i.plist, icon: i.icon))
                    print(tempApps)
                }
                
                } else {
                    print("failed To Grab")
                    return
                }
            completion(true)
            }.resume()
        }
        idk(completion: {(success) -> Void in
            tempBool = true
        })
        while !tempBool {
        print("Returning....")
        }
        return tempApps
    }
}
extension AppCellListScreen: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = datas[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppCell") as! AppCell
        cell.setApp(title: data)
        cell.selectionStyle = .none
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        return cell
    }
}
struct AppStruct: Identifiable, Decodable {
    let id = UUID()
    var name: String
    var plist: String
    var icon: String

}
