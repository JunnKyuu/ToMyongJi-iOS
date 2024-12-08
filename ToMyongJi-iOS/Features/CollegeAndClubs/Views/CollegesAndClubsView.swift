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
        ScrollView {
            VStack {
                Text("단과대와 학생회를 확인해보세요")
                    .font(.custom("GmarketSansMedium", size: 18))
                    .foregroundStyle(Color.softBlue)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 30)
                
                LazyVStack(spacing: 20) {
                    ForEach(viewModel.colleges) { college in
                        CollegeCard(college: college)
                    }
                }
            }
            .padding()
        }
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

struct CollegeCard: View {
    let college: College
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(college.collegeName)
                        .font(.custom("GmarketSansMedium", size: 18))
                        .foregroundStyle(Color.darkNavy)
                    Text("\(college.clubs.count)개의 학생회")
                        .font(.custom("GmarketSansLight", size: 14))
                        .foregroundColor(Color.gray)
                }
                Spacer()
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(.darkNavy)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
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
        .background(Color.softBlue)
        .cornerRadius(15)
    }
}

struct ClubRow: View {
    let club: Club
    
    var body: some View {
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

struct CollegeAndClubsView_Previews: PreviewProvider {
    static var previews: some View {
        CollegesAndClubsView()
    }
}

#Preview {
    CollegesAndClubsView()
}
