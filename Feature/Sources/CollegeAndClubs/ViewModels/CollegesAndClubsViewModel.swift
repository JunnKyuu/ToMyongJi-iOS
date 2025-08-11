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
    
    var showAlert: Bool = false
    var alertTitle: String = ""
    var alertMessage: String = ""
    
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
                guard let self = self else { return }
                self.isLoading = false
                switch completion {
                case .failure:
                    self.showAlert(title: "실패", message: "학생회 정보를 불러오는데 실패했습니다.")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.colleges = response.data
            }
            .store(in: &cancellables)
    }
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}
