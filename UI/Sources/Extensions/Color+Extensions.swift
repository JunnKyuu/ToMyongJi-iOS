import SwiftUI

public extension Color {
    static var softBlue: Color {
        Color("softBlue", bundle: .module)
    }
    
    static var darkNavy: Color {
        Color("darkNavy", bundle: .module)
    }
    
    static var deposit: Color {
        Color("deposit", bundle: .module)
    }
    
    static var withdrawal: Color {
        Color("withdrawal", bundle: .module)
    }
}

#Preview {
    VStack(spacing: 20) {
        Rectangle()
            .fill(Color.softBlue)
            .frame(width: 100, height: 100)
            .overlay(Text("softBlue").foregroundColor(.white))
        
        Rectangle()
            .fill(Color.darkNavy)
            .frame(width: 100, height: 100)
            .overlay(Text("darkNavy").foregroundColor(.white))
        
        Rectangle()
            .fill(Color.deposit)
            .frame(width: 100, height: 100)
            .overlay(Text("deposit").foregroundColor(.white))
        
        Rectangle()
            .fill(Color.withdrawal)
            .frame(width: 100, height: 100)
            .overlay(Text("withdrawal").foregroundColor(.white))
    }
    .padding()
}
