//
//  CollegeStudentClubViewModel.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 12/5/24
//

import Foundation
import Combine
import Core

@Observable
class CollegesAndClubsViewModel {
    var colleges: [College] = []
    var isLoading = false
    var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let networkingManager: AlamofireNetworkingManager
    
    init(networkingManager: AlamofireNetworkingManager = .shared) {
        self.networkingManager = networkingManager
    }
    
    func getCollegeAndClubs() {
        isLoading = true
        errorMessage = nil
        
        let endpoint = CollegesAndClubsEndpoint.collegesAndClubs
        
        networkingManager.run(endpoint, type: CollegesAndClubsResponse.self)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.colleges = response.data
            }
            .store(in: &cancellables)
    }
}
