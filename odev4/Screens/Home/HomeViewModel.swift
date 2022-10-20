//
//  SearchViewModel.swift
//  odev4
//
//  Created by Cagla Efendioglu on 13.10.2022.
//

import Foundation

protocol HomeViewModelProtocol {
    func fetchRecentPhoto()
    func setUpOutPutDelegate(_ viewController: HomeVC)
    func numberOfRows() -> Int
    func recentPhotoData() -> [Photo]
}

protocol HomeViewModelOutput {
    func showData(photoData: [Photo])
    func showError(error: String)
}

final class HomeViewModel: HomeViewModelProtocol {
    var homeViewModelOutputDelegate: HomeViewModelOutput?
    var service: IServiceProtocol?
    private var recentPhotoResponse: [Photo] = []
    private let parsingError = "parsing error"
    
    init(service: IServiceProtocol) {
        self.service = service
    }
    
    func numberOfRows() -> Int {
        recentPhotoResponse.count
    }
    
    func recentPhotoData() -> [Photo] {
        recentPhotoResponse
    }
}

extension HomeViewModel {
    
    func setUpOutPutDelegate(_ viewController: HomeVC) {
        homeViewModelOutputDelegate = viewController
    }
    
    func fetchRecentPhoto() {
        guard let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=165ab45f9f138b91b0b81a56d366b9e4&format=json&nojsoncallback=1") else { return }
        service?.fetch(url: url, completion: { [homeViewModelOutputDelegate] (result: Result<RecentPhoto, Error>)  in
            switch result {
            case .success(let recentPhoto):
                guard let recentPhotoData = recentPhoto.photos?.photo else {
                    homeViewModelOutputDelegate?.showError(error: self.parsingError)
                    return
                }
                self.recentPhotoResponse = recentPhotoData
                homeViewModelOutputDelegate?.showData(photoData: recentPhotoData)
            case .failure(let error):
                homeViewModelOutputDelegate?.showError(error: error.localizedDescription)
            }
        })
    }
}
