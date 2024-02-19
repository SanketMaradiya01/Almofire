//
//  ViewController.swift
//  Almofire
//
//  Created by Nimap on 19/02/24.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class ViewController: UIViewController {
    
    var topView: UIView?
    var tableView: UITableView!
    var titleLabel: UILabel?
    
    var dataList = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDataFromAPI()
        configureUI()
    }
    
    func fetchDataFromAPI() {
        let url = "https://testffc.nimapinfotech.com/testdata.json"
        Alamofire.request(url).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                if let jsonDictionary = value as? [String: Any],
                   let dataDictionary = jsonDictionary["data"] as? [String: Any],
                   let recordsArray = dataDictionary["Records"] as? [[String: Any]] {
                    
                    if recordsArray.isEmpty {
                        print("Empty data received from the API.")
                    } else {
                        self.dataList = recordsArray
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                } else {
                    print("Invalid JSON format received from the API.")
                }
            case .failure(let error):
                print("Error Occurred: \(error.localizedDescription)")
            }
        }
    }
    
    
    
    
    
    private func configureUI() {
        view.backgroundColor = .white
        
        topView = UIView()
        topView?.backgroundColor = .black
        view.addSubview(topView!)
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .black
        view.addSubview(tableView)
        
        titleLabel = UILabel()
        titleLabel?.textColor = .white
        titleLabel?.text = "Recent List"
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        
        titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        topView?.addSubview(titleLabel!)
        NSLayoutConstraint.activate([
            titleLabel!.centerXAnchor.constraint(equalTo: topView!.centerXAnchor),
            titleLabel!.centerYAnchor.constraint(equalTo: topView!.centerYAnchor)
        ])
        
        topView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView!.heightAnchor.constraint(equalToConstant: 60.0)
        ])
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topView!.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.FundNumL?.text = "\(dataList[indexPath.row]["collectedValue"] ?? "")"
        cell.TitleLabel?.text = "\(dataList[indexPath.row]["title"] ?? "")"
        cell.DescriptionLabel?.text = "\(dataList[indexPath.row]["shortDescription"] ?? "")"
        cell.FundNumL?.text = "\(dataList[indexPath.row]["collectedValue"] ?? "")"
        cell.GoalNumL?.text = "\(dataList[indexPath.row]["totalValue"] ?? "")"
        if let imageURLString = dataList[indexPath.row]["mainImageURL"] as? String,
           let imageURL = URL(string: imageURLString) {
            
            Alamofire.request(imageURL).responseImage { (response) in
                switch response.result {
                case .success(let image):
                    DispatchQueue.main.async {
                        cell.Image?.image = image
                    }
                case .failure(let error):
                    print("Image request failed: \(error.localizedDescription)")
                }
            }
        }
        
        return cell
    }
}
