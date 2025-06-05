//
//  EducationPageViewController.swift
//  TeddNews
//
//  Created by Ko Minhyuk on 6/5/25.
//

import UIKit

class EducationViewController: UIViewController {

    @IBOutlet weak var eduTableView: UITableView!
    
    var news: [News.Article]? = [News.Article]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            await NewsUseCase.shared.fetchQuery("Education") { [weak self] in
                self?.news = $0.articles
                
                DispatchQueue.main.async {
                    self?.eduTableView.reloadData()
                }
            }
        }
    }
}

extension EducationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = news?.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EducationTableViewCell.self), for: indexPath) as! EducationTableViewCell
        
        let news = news?[indexPath.row]
        let imageString = news?.urlToImage ?? ""
        let date = formatDisplayDate(from: news?.publishedAt ?? "")
        
        cell.eduTitle.text = news?.title ?? ""
        cell.eduDescription.text = news?.description ?? ""
        cell.eduAuthor.text = "\(news?.author ?? "Unknown") ⋅ \(date ?? "")"
        cell.eduImage.loadImage(from: imageString)
        
        return cell
    }
}
