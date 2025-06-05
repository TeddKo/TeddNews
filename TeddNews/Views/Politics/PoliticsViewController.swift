//
//  PoliticsPageViewController.swift
//  TeddNews
//
//  Created by Ko Minhyuk on 6/5/25.
//

import UIKit

class PoliticsViewController: UIViewController {

    @IBOutlet weak var politicsTableView: UITableView!
    
    var news: [News.Article]? = [News.Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            await NewsUseCase.shared.fetchQuery("Politics") { [weak self] in
                self?.news = $0.articles
                
                DispatchQueue.main.async {
                    self?.politicsTableView.reloadData()
                }
            }
        }
    }
}

extension PoliticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = news?.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PoliticsTableViewCell.self), for: indexPath) as! PoliticsTableViewCell
        
        let news = news?[indexPath.row]
        let imageString = news?.urlToImage ?? ""
        let date = formatDisplayDate(from: news?.publishedAt ?? "")
        
        cell.politicsTitle.text = news?.title
        cell.politicsDescription.text = news?.description
        
        cell.politicsAuthor.text = "\(news?.author ?? "Unknown") ⋅ \(date ?? "")"
        cell.politicsImage.loadImage(from: imageString)
        
        return cell
    }
}
