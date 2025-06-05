//
//  TechnologyPageViewController.swift
//  TeddNews
//
//  Created by Ko Minhyuk on 6/5/25.
//

import UIKit

class TechnologyViewController: UIViewController {

    @IBOutlet weak var techTableView: UITableView!
    
    var news: [News.Article]? = [News.Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            await NewsUseCase.shared.fetchQuery("Technology") { [weak self] in
                self?.news = $0.articles
                
                DispatchQueue.main.async {
                    self?.techTableView.reloadData()
                }
            }
        }
    }
}

extension TechnologyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = news?.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TechnologyTableViewCell.self), for: indexPath) as! TechnologyTableViewCell
        
        let news = news?[indexPath.row]
        let imageString = news?.urlToImage ?? ""
        let date = formatDisplayDate(from: news?.publishedAt ?? "")
        
        cell.techhTitle.text = news?.title
        cell.techDescription.text = news?.description
        
        cell.techhAutor.text = "\(news?.author ?? "Unknown") ⋅ \(date ?? "")"
        cell.techImage.loadImage(from: imageString)
        
        return cell
    }
}
