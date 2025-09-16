//
//  SelectCollegesAndClubsView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 3/13/25.
//

import SwiftUI

struct SelectCollegesAndClubsView: View {
    var viewModel: AdminViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // 단과대학 선택
            Menu {
                ForEach(viewModel.colleges) { college in
                    Button(college.collegeName) {
                        viewModel.selectedCollege = college
                        viewModel.selectedClub = nil
                    }
                }
            } label: {
                HStack {
                    Text(viewModel.selectedCollege?.collegeName ?? "단과대학 선택")
                        .font(.custom("GmarketSansLight", size: 14))
                    Spacer()
                    Image(systemName: "chevron.down")
                }
                .foregroundStyle(Color.black)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).stroke(viewModel.selectedCollege != nil ? Color("primary") : Color("gray_20")))
            }
            
            // 소속 선택
            if let college = viewModel.selectedCollege {
                Menu {
                    ForEach(college.clubs) { club in
                        Button(club.studentClubName) {
                            viewModel.selectedClubId = club.studentClubId
                            viewModel.selectedClub = club
                        }
                    }
                } label: {
                    HStack {
                        Text(viewModel.selectedClub?.studentClubName ?? "소속 선택")
                            .font(.custom("GmarketSansLight", size: 14))
                        Spacer()
                        Image(systemName: "chevron.down")
                    }
                    .foregroundStyle(Color.black)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).stroke(viewModel.selectedClub != nil ? Color("primary") : Color("gray_20")))
                }
            }
        }
        .onAppear {
            viewModel.fetchCollegesAndClubs()
        }
    }
    
}
