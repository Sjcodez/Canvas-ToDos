//
//  SignInHeaderView.swift
//  Canvas To-dos
//
//  Created by Sanjith Ponnusamy on 1/8/24.
//

import SwiftUI

struct SignInHeaderView: View {
    
    let title: String
    let subtitle: String
    let tintColor1: Color
    let tintColor2: Color
    let angle1: Double
    let angle2: Double
    
    var body: some View {
        ZStack {
            ZStack{
                RoundedRectangle(cornerRadius: 0)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [tintColor1, tintColor2]),
                        startPoint: .leading,
                        endPoint: .trailing))
                    .rotationEffect(Angle(degrees: angle1))
                RoundedRectangle(cornerRadius: 0)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [tintColor2, tintColor1]),
                        startPoint: .leading,
                        endPoint: .trailing))
                    .rotationEffect(Angle(degrees: angle2))
            }
            .offset(y: -30)
            VStack {
                Text(title)
                    .font(.system(size: 35))
                    .foregroundStyle(.white)
                    .bold()
                Text(subtitle)
                    .font(.system(size: 20))
                    .foregroundStyle(.white)
                    .bold()
                    .padding(.top, 1)
            }
            .padding(.bottom, 120)
            .offset(y: 175)
        }
        .frame(width: UIScreen.main.bounds.width * 3, height: 350)
        .offset(y: -190)
    }

}

#Preview {
    SignInHeaderView(title: "title", subtitle: "Subtitle", tintColor1: .black, tintColor2: Color.red, angle1: 45, angle2: 135)
}
