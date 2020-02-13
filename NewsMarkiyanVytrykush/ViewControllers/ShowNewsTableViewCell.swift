//
//  ShowNewsTableViewCell.swift
//  NewsMarkiyanVytrykush
//
//  Created by Nanter on 2/12/20.
//  Copyright © 2020 Markiyan Vytrykush. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    // MARK: -  IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageShow: UIRemoteImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sourceOrLanguageLabel: UILabel!
    @IBOutlet weak var authorOrCountryLabel: UILabel!
    @IBOutlet weak var publishedAtOrCategoryLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: -  article
    var article: Article? {
        didSet{
            guard let article = article else { return }
            titleLabel.text = article.title
            descriptionLabel.text = article.description
            if let author = article.author {
                authorOrCountryLabel.text = "Author: \(author)"
            } else {
                authorOrCountryLabel.text = nil
            }
            if let source = article.source?.name {
                sourceOrLanguageLabel.text = "Source: \(source)"
            } else {
                sourceOrLanguageLabel.text = nil
            }
            if let date = article.publishedAt {
                publishedAtOrCategoryLabel.text = "Published at: \(date)"
            } else {
               publishedAtOrCategoryLabel.text = nil
            }
            if let imageUrl = article.urlToImage {
                imageShow.setImage(from: imageUrl)
            } else {
                imageShow.image = nil
            }
        }
    }

    // MARK: -  source
    var source: Sources? {
        didSet {
            guard let source = source else { return }
            titleLabel.text = source.name
            descriptionLabel.text = source.description
            sourceOrLanguageLabel.text = "Language: \(source.language)"
            authorOrCountryLabel.text = "Country: \(source.country)"
            publishedAtOrCategoryLabel.text = "Category: \(source.category)"
            imageShow.image = nil
        }
    }

}
