//
//  SearchViewModel.swift
//  odev4
//
//  Created by Cagla Efendioglu on 13.10.2022.
//

import Foundation

protocol SearchViewModelProtocol {
    func fetchRecentPhoto()
    func fetchSearchPhoto(text: String)
    func setUpOutPutDelegate(_ viewController: SearchVC)
    func recentNumberOfRows() -> Int
    func searchNumberOfRows() -> Int
    func recentPhotoData() -> [Photo]
    func searchPhotoData() -> [Photo]
}

protocol SearchViewModelOutput {
    func showData(photoData: [Photo])
    func showError(error: String)
}

final class SearchViewModel: SearchViewModelProtocol {
    var searchViewModelOutputDelegate: SearchViewModelOutput?
    var service: IServiceProtocol?
    private var recentPhotoResponse: [Photo] = []
    private var searchPhotoResponse: [Photo] = []
    private let parsingError = "parsing error"
    
    init(service: IServiceProtocol) {
        self.service = service
    }
    
    func recentNumberOfRows() -> Int {
        recentPhotoResponse.count
    }
    
    func recentPhotoData() -> [Photo] {
        recentPhotoResponse
    }
    
    func searchNumberOfRows() -> Int {
        searchPhotoResponse.count
    }
    
    func searchPhotoData() -> [Photo] {
        searchPhotoResponse
    }
}

extension SearchViewModel {
    func setUpOutPutDelegate(_ viewController: SearchVC) {
        searchViewModelOutputDelegate = viewController
    }
    
    func fetchRecentPhoto() {
        guard let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=165ab45f9f138b91b0b81a56d366b9e4&format=json&nojsoncallback=1") else { return }
        service?.fetch(url: url, completion: { [searchViewModelOutputDelegate] (result: Result<RecentPhoto, Error>)  in
            switch result {
            case .success(let recentPhoto):
                guard let recentPhotoData = recentPhoto.photos?.photo else {
                    searchViewModelOutputDelegate?.showError(error: self.parsingError)
                    return
                }
                self.recentPhotoResponse = recentPhotoData
                searchViewModelOutputDelegate?.showData(photoData: recentPhotoData)
            case .failure(let error):
                searchViewModelOutputDelegate?.showError(error: error.localizedDescription)
            }
        })
    }
    
    func fetchSearchPhoto(text: String) {
        guard let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=165ab45f9f138b91b0b81a56d366b9e4&text=\(text)&format=json&nojsoncallback=1") else { return }
        service?.fetch(url: url, completion: { [searchViewModelOutputDelegate] (result: Result<RecentPhoto, Error>)  in
            switch result {
            case .success(let searchPhoto):
                guard let searchPhotoData = searchPhoto.photos?.photo else {
                    searchViewModelOutputDelegate?.showError(error: self.parsingError)
                    return
                }
                self.searchPhotoResponse = searchPhotoData
                searchViewModelOutputDelegate?.showData(photoData: searchPhotoData)
            case .failure(let error):
                searchViewModelOutputDelegate?.showError(error: error.localizedDescription)
            }
        })
    }
}
