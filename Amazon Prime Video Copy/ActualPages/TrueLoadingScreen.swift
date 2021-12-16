//
//  TrueLoadingScreen.swift
//  Amazon Prime Video Copy
//
//  Created by Salvatore Manna on 10/12/21.
//

import SwiftUI

struct TrueLoadingScreen: View {
    @State private var isActive: Bool = false
    
    var body: some View {
            if (isActive){
                //If the condition isActive is true I go to the next page (The homepage)
                TabSelection()
            } else {
                ZStack{
                    //Setting the background for the screen
                    Color(.black)
                        .ignoresSafeArea()
                    //Inside of this VStack I placed the logo and the progress bar
                    VStack{
                        ZStack{
                            Image("AmazonPrimeLogo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 0.5*screenWidth, height: screenHeight/5)
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                                .position(x: 0.5*screenWidth, y: 0.52*screenHeight)
                        }
                    }
                }
                //Since I have a dark background, I always set the colorscheme of the statusbar to .dark, so it shows as white
                .preferredColorScheme(.dark)
                .onAppear{
                    //I present a loading screen for a set amount of time then I turn the "isActive" variable to true and so the main page loads
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7){
                        isActive = true
                    }
 
                }
            }
    }
}

struct TrueLoadingScreen_Previews: PreviewProvider {
    static var previews: some View {
        TrueLoadingScreen()
            .environmentObject(MyModelClass())
    }
}
