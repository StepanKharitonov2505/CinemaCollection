//
//  MainController.swift
//  TZcinema
//
//  Created by Степан Харитонов on 04.01.2022.
//

import UIKit

class MainController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private var filmsAPITmdb = FilmsGetApiTmdb()
    private var filmsAPIArrayTmdb: [FilmsContainerTmdb] = []
     
    var filmsIdTmdb = ["tt10872600",
                       "tt0111161",
                       "tt0068646",
                       "tt0468569",
                       "tt0108052",
                       "tt0167260",
                       "tt0137523",
                       "tt0109830",
                       "tt1375666",
                       "tt0133093",
                       "tt0232500",
                       "tt0102926",
                       "tt0120815",
                       "tt0076759",
                       "tt0120689",
                       "tt0110413",
                       "tt0103064",
                       "tt0120586",
                       "tt0172495",
                       "tt1675434",
                       "tt0078748",
                       "tt1853728",
                       "tt0910970",
                       "tt7286456",
                       "tt1345836",
                       "tt0361748",
                       "tt0091251",
                       "tt0338013",
                       "tt0993846",
                       "tt0434409"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCustomCell()
      
        loadFilmsTmdb()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filmsAPIArrayTmdb.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilmsCell", for: indexPath) as? CustomCellClass else { return UICollectionViewCell() }
        
        let filmsPath = filmsAPIArrayTmdb[indexPath.item]
        cell.tag = indexPath.item
        
        cell.nameFilm.text = filmsPath.title
        let numberRating = String(describing: filmsPath.voteAverage)
        cell.iMDBNumber.text = numberRating
        cell.iMDBNumber.textColor = .white
        cell.iMDBView.layer.cornerRadius = 8
        if filmsPath.voteAverage >= 8 && filmsPath.voteAverage < 9 {
            cell.iMDBView.backgroundColor = .blue
        } else if filmsPath.voteAverage < 7 {
            cell.iMDBView.backgroundColor = .gray
        } else if filmsPath.voteAverage >= 9 {
            cell.iMDBView.backgroundColor = .red
        } else {
            cell.iMDBView.backgroundColor = .orange
        }
        
        let releaseFormat = filmsPath.releaseDate.prefix(4)
        cell.year.text = String(releaseFormat)
        cell.filmsAvatar.layer.opacity = 0
        
        if let imageURL =  URL(string: "https://image.tmdb.org/t/p/w500" + filmsPath.posterPath) {
                DispatchQueue.global(qos: .utility).async {
                if let data = try? Data(contentsOf: imageURL) {
                        DispatchQueue.main.async (execute: {() -> Void in
                            if cell.tag == indexPath.item {
                                let filmImage = UIImage(data: data)
                                cell.filmsAvatar.image = filmImage
                                UIView.animate(withDuration: 0.5, animations: {
                                            cell.filmsAvatar.layer.opacity = 1
                                })
                            }
                        })
                    }
                }
            }
        return cell
    }
    
    //MARK: Prepare methods
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "infoFilms", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "infoFilms" {
                guard let filmsVC = segue.destination as? FilmDetail else {
                    return
                }
        guard let indexPath = sender as? IndexPath else { return }
              
                  let selectFilm = self.filmsAPIArrayTmdb[indexPath.item]
                  filmsVC.filmName = selectFilm.title
                  filmsVC.filmOverview = selectFilm.overview
                  filmsVC.filmRelease = selectFilm.releaseDate
                  filmsVC.filmImageUrl = selectFilm.backdropPath
                  filmsVC.filmGenres = selectFilm.genres
          }
      }

    //MARK: Layout Cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.orientation.isLandscape || self.view.frame.width > 600 {
            let layoutWidthLandScape = (self.view.frame.width-12)/6
            let layoutHeightLandScape = layoutWidthLandScape*(16/9)
            return CGSize(width: layoutWidthLandScape, height: layoutHeightLandScape)
        } else {
            let layoutWidth = (self.view.frame.width-6)/3
            let layoutHeight = layoutWidth*(16/9)
            return CGSize(width: layoutWidth, height: layoutHeight)
        }
    }
        
    func loadFilmsTmdb() {
        for i in 0..<(self.filmsIdTmdb.count) {
            self.filmsAPITmdb.getFilms(filmsId: filmsIdTmdb[i]) { [weak self] filmsAPIArrayTmdb in
                guard let self = self else { return }
                self.filmsAPIArrayTmdb.append(filmsAPIArrayTmdb)
                self.collectionView.reloadData()
            }
        }
    }
    
    //MARK: Register Cell
    private func registerCustomCell() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CustomCell", bundle: nil), forCellWithReuseIdentifier: "FilmsCell")
    }
        
}
