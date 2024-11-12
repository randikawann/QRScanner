//
//  ShowReceiptsViewController.swift
//  QRecu
//
//  Created by Arimac on 2024-11-06.
//

import UIKit

class ShowReceiptsViewController: UIViewController {

    var tableViewData = [CellData]()
    var tableItems = [CellSubData]()
    var tableAmount = [CellSubData]()
    var tableCardNumber = [CellSubData]()
    
    @IBOutlet weak var receiptTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.receiptTableView.delegate = self
        self.receiptTableView.dataSource = self
        
        tableViewData = [CellData(image: "csd", title1: "title1", descriptions1: "descriptions1", subData: [CellSubData(title2: "title2", descriptions2: "descriptions2")])]
        var totalprice:Float = 0.0
        if let retrievedApiResponse = retrieveApiResponseFromUserDefaults() {
            for i in retrievedApiResponse.record {
                tableItems.append(CellSubData(title2: i.name, descriptions2: "$"+i.price))
                totalprice += Float(i.price) ?? 0.0
            }
        }
        
        let tax:Float = totalprice * 0.08
        
        tableAmount = [CellSubData(title2: "SubTotal:", descriptions2: "$\(totalprice)"),
                       CellSubData(title2: "Tax (8%):", descriptions2: "$\(tax)"),
                             CellSubData(title2: "Total:", descriptions2: "$\(totalprice+tax)"),
        ]
        
        tableCardNumber = [CellSubData(title2: "Card Number:", descriptions2: "*******1234"),
                             CellSubData(title2: "Approval Code:", descriptions2: "123456")
        ]
        
        tableViewData = [CellData(image: "icon_address", title1: "Address:", descriptions1: "123 Main Street, CityVile"),
                         CellData(image: "icon_phone", title1: "Phone:", descriptions1: "(123) 456-7890"),
                         CellData(image: "icon_date", title1: "Date:", descriptions1: "2024-11-05 Time: 14.30"),
                         CellData(image: "icon_orderNumber", title1: "Order Number:", descriptions1: "#GM123456"),
                         CellData(image: "icon_cashier", title1: "Cashier:", descriptions1: "John Doe"),
                         CellData(image: "icon_items", title1: "Items:", descriptions1: "", subData: tableItems),
                         CellData(image: "icon_amount", title1: "Amount:", descriptions1: "", subData: tableAmount),
                         CellData(image: "icon_payment", title1: "Payment: Credit Card (VISA):", descriptions1: "", subData: tableCardNumber)
        ]
        receiptTableView.reloadData()
    }
    
    func retrieveApiResponseFromUserDefaults() -> ApiResponse? {
        let decoder = JSONDecoder()
        
        if let savedData = UserDefaults.standard.data(forKey: "savedApiResponse") {
            do {
                let decodedApiResponse = try decoder.decode(ApiResponse.self, from: savedData)
                
                print("ApiResponse successfully retrieved from UserDefaults.")
                return decodedApiResponse
            } catch {
                print("Error decoding ApiResponse: \(error)")
                return nil
            }
        }
        print("No ApiResponse found in UserDefaults.")
        return nil
    }
}

extension ShowReceiptsViewController: UITableViewDelegate, UITableViewDataSource {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData[section].subData.isEmpty ? 1 : tableViewData[section].subData.count + 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = tableViewData[indexPath.section]
            if indexPath.row == 0 {
                let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! MainReceiptLineTableViewCell
                cell1.imageView?.image = UIImage(named: cellData.image)
                cell1.first.text = cellData.title1
                cell1.seconds.text = cellData.descriptions1
                return cell1
            }
            
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! SubReceiptLineTableViewCell
            let subData = cellData.subData[indexPath.row - 1]
            
            cell2.first.text = subData.title2
            cell2.seconds.text = subData.descriptions2
            
            return cell2
    }
    
}

struct CellData {
    var image = String()
    var title1 = String()
    var descriptions1 = String()
    var subData = [CellSubData]()
}

struct CellSubData {
    var title2 = String()
    var descriptions2 = String()
    var price2 = String()
}
