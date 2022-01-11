//
//  FilmDetail.swift
//  TZcinema
//
//  Created by Степан Харитонов on 04.01.2022.
//

import UIKit

class FilmDetail: UIViewController {

    @IBOutlet weak var filmImage: UIImageView!
    @IBOutlet weak var filmOverviewTitle: UILabel!
    @IBOutlet weak var nameFilm: UILabel!
    @IBOutlet weak var dateRelease: UILabel!
    @IBOutlet weak var genres: UILabel!
    
    var filmName: String?
    var filmOverview: String?
    var filmRelease: String?
    var filmImageUrl: String?
    var filmGenres: [Genre]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        settingsFilmView()
    }

    func settingsFilmView() {
        self.filmOverviewTitle.text = filmOverview
        self.nameFilm.text = filmName
        
        self.genres.text = ""
        if self.filmGenres!.count > 1 {
        filmGenres?.forEach({ self.genres.text! += ($0.name + " ") })
        } else {
            self.genres.text = filmGenres![0].name
        }
        
        let releaseFormat = self.filmRelease?.prefix(4)
        self.dateRelease.text = String(describing: releaseFormat!)
        
        if let imageURL =  URL(string: "https://image.tmdb.org/t/p/w500" + filmImageUrl!) {
                DispatchQueue.global(qos: .utility).async {
                if let data = try? Data(contentsOf: imageURL) {
                        DispatchQueue.main.async {
                                let filmImage = UIImage(data: data)
                                self.filmImage.image = filmImage
                            }
                        }
                    }
                }
            }
}
