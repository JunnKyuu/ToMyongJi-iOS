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
                VStack {
                    Text("학생회를 선택해주세요.")
                        .font(.custom("GmarketSansBold", size: 28))
                        .foregroundStyle(.darkNavy)
                        .frame(height: 45)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 15)
                        .padding(.bottom, 15)
                    
                    LazyVStack(spacing: 20) {
                        ForEach(viewModel.colleges) { college in
                            CollegeCard(college: college)
                        }
                    }
                    .padding(.horizontal, 15)
                }
            }
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
                        .font(.custom("GmarketSansBold", size: 18))
                        .foregroundStyle(.darkNavy)
                    Text("\(college.clubs.count)개의 학생회")
                        .font(.custom("GmarketSansMedium", size: 14))
                        .foregroundStyle(.gray)
                }
                Spacer()
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(.darkNavy)
                    .font(.title3.bold())
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
            }
            
            if isExpanded {
                ForEach(college.clubs) { club in
                    ClubRow(club: club)
                }
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color.softBlue)
                .overlay(alignment: .leading) {
                    Circle()
                        .fill(Color.softBlue)
                        .overlay {
                            Circle()
                                .fill(.white.opacity(0.2))
                        }
                        .scaleEffect(2, anchor: .topLeading)
                        .offset(x: -50, y: -40)
                }
        }
        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
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
                    .font(.custom("GmarketSansLight", size: 15))
                    .foregroundStyle(Color.darkNavy)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 5)
        }
    }
}

#Preview {
    CollegesAndClubsView()
}
