//
//  HomeViewController.swift
//  QRecu
//
//  Created by Arimac on 2024-11-06.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var homeDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        homeDescription.text = "You have saved \n12 \ntrees until now."
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        let qRScanVC = QRScanViewController()
        qRScanVC.delegate = self
        navigationController?.pushViewController(qRScanVC, animated: true)
    }
    
    func getAPIResponse(url: String) {
        
        if let url = URL(string: url) {
            let session = URLSession.shared
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        // 4. Make sure data is received
                            guard let data = data else {
                                print("No data received.")
                                return
                            }
                            
                            do {
                                let decoder = JSONDecoder()
                                let apiResponse = try decoder.decode(ApiResponse.self, from: data)
                                
                                let encoder = JSONEncoder()
                                if let encodedData = try? encoder.encode(apiResponse) {
                                    UserDefaults.standard.set(encodedData, forKey: "savedApiResponse")
                                }
                                
                                self.showSuccessAlert()
                            } catch {
                                self.showErrorAlert()
                                print("Error decoding JSON: \(error)")
                            }
                    } else {
                        self.showErrorAlert()
                        print("Error: Invalid response code \(httpResponse.statusCode)")
                    }
                }
            }
            task.resume()
        }
    }
    
    func showSuccessAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Successfully Scanned",
                                          message: "Move to view Receipts to view",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok",
                                          style: .default))
            self.present(alert, animated: true)
        }
    }
    
    func showErrorAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error",
                                          message: "Something went wrong",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok",
                                          style: .default))
            self.present(alert, animated: true)
        }
    }
}

extension HomeViewController: QRScanViewDelegate {
    func didReceiveData(_ data: String) {
        getAPIResponse(url: data)
    }
}

struct Product: Codable {
    let id: Int
    let name: String
    let description: String
    let price: String

    enum CodingKeys: String, CodingKey {
        case id, name, description, price
    }

    // Custom decoding to handle both String and Number for 'price'
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)

        // Try to decode price as String, if fails try decoding it as a Double and convert to String
        if let priceString = try? container.decode(String.self, forKey: .price) {
            price = priceString
        } else if let priceNumber = try? container.decode(Double.self, forKey: .price) {
            price = String(priceNumber)
        } else {
            throw DecodingError.typeMismatch(String.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Expected String or Double for 'price'"))
        }
    }
}

// Define the Metadata structure
struct Metadata: Codable {
    let createdAt: String
    let name: String
    let readCountRemaining: Int
    let timeToExpire: Int
}

// Define the main API response structure
struct ApiResponse: Codable {
    let id: String
    let metadata: Metadata
    let record: [Product]
}
