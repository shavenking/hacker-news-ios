//
//  ViewController.swift
//  hacker-news-ios
//
//  Created by Andy Tsai on 2018/4/12.
//  Copyright © 2018 Andy Tsai. All rights reserved.
//

import UIKit

struct News {
    var title: String
    var url: String
}

class ViewController: UIViewController {

    var tableView = UITableView()
    var news: [News?] = Array(repeatElement(nil, count: 30))
    var itemIds = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)

        tableView.frame = view.frame
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        URLSession.shared.dataTask(
            with: URL(string: "https://hacker-news.firebaseio.com/v0/beststories.json")!
        ) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            let json = try? JSONSerialization.jsonObject(with: data!)

            self.itemIds = Array((json as! [Int])[0..<30])
            DispatchQueue.main.async { () -> Void in
                self.tableView.reloadData()
            }
        }.resume()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard news[indexPath.row] == nil else {
            return
        }

        let id = itemIds[indexPath.row]

        URLSession.shared.dataTask(
            with: URL(string: "https://hacker-news.firebaseio.com/v0/item/\(id).json")!
        ) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            let json = try? JSONSerialization.jsonObject(with: data!) as! [String: Any]
            self.news[indexPath.row] = News(title: json!["title"] as! String, url: "https://news.ycombinator.com/item?id=\(json!["id"] ?? "")")
            DispatchQueue.main.async { () -> Void in
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }
        }.resume()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webViewController = WebViewController()
        webViewController.news = news[indexPath.row]
        present(UINavigationController(rootViewController: webViewController), animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemIds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UITableViewCell

        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.numberOfLines = 0

        if news[indexPath.row] != nil {
            cell.textLabel?.text = news[indexPath.row]?.title
        } else {
            cell.textLabel?.text = "Loading..."
        }

        return cell
    }
}
