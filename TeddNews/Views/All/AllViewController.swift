//
//  AllPageViewController.swift
//  TeddNews
//
//  Created by Ko Minhyuk on 6/5/25.
//

import UIKit

class AllViewController: UIViewController {
    
    @IBOutlet weak var allTableView: UITableView!
    
    var news: [News.Article]? = [News.Article]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            await NewsUseCase.shared.fetchAll { [weak self] in
                self?.news = $0.articles
                
                DispatchQueue.main.async {
                    self?.allTableView.reloadData()
                }
            }
        }
    }
}

extension AllViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = news?.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AllTableViewCell.self), for: indexPath) as! AllTableViewCell
        
        let news = news?[indexPath.row]
        let imageString = news?.urlToImage ?? ""
        let date = formatDisplayDate(from: news?.publishedAt ?? "")
        
        cell.allTitle.text = news?.title ?? ""
        cell.allDescription.text = news?.description
        
        
        cell.allName.text = "\(news?.author ?? "Unknown") ⋅ \(date ?? "")"
        cell.allImage.loadImage(from: imageString)
        
        return cell
    }
}
