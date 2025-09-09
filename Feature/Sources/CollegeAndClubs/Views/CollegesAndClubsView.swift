//
//  CollegeStudentClubView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 12/5/24.
//

import SwiftUI

struct CollegesAndClubsView: View {
    @Bindable private var viewModel = CollegesAndClubsViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("영수증 조회")
                            .font(.custom("GmarketSansBold", size: 26))
                            .foregroundStyle(Color.black)
                        
                        Text("각 학생회별로 등록된 영수증을 조회합니다.")
                            .font(.custom("GmarketSansMedium", size: 16))
                            .foregroundStyle(Color("gray_80"))
                            .padding(.horizontal, 3)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 15)
                    .padding(.top, 20)

                    LazyVStack(spacing: 20) {
                        ForEach(viewModel.colleges) { college in
                            CollegeCard(college: college)
                        }
                    }
                    .padding(.horizontal, 15)
                }
            }
            .background(Color("signup-bg"))
            .scrollIndicators(.hidden)
            .overlay(Group {
                if viewModel.isLoading {
                    ProgressView()
                }
            })
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil), presenting: viewModel.errorMessage) { _ in
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            } message: { errorMessage in
                Text(errorMessage)
            }
            .onAppear {
                viewModel.getCollegeAndClubs()
            }
        }
    }
}

struct CollegeCard: View {
    let college: College
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(college.collegeName)
                        .font(.custom("GmarketSansMedium", size: 18))
                        .foregroundStyle(Color.black)
                    Text("\(college.clubs.count)개의 학생회")
                        .font(.custom("GmarketSansMedium", size: 14))
                        .foregroundStyle(Color("gray_70"))
                }
                Spacer()
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(Color("gray_20"))
                    .font(.title3.bold())
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
            }
            
            if isExpanded {
                Divider()
                    .foregroundStyle(Color("gray_10"))
                    .padding(.vertical, 10)
                ForEach(college.clubs) { club in
                    ClubRow(club: club)
                }
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.white)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

struct ClubRow: View {
    let club: Club
    
    var body: some View {
        NavigationLink {
            ReceiptListView(club: club)
        } label: {
            HStack {
                Text(club.studentClubName)
                    .font(.custom("GmarketSansMedium", size: 14))
                    .foregroundStyle(Color("gray_90"))
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Color("gray_90"))
            }
            .padding(.vertical, 5)
        }
    }
}

#Preview {
    CollegesAndClubsView()
}
