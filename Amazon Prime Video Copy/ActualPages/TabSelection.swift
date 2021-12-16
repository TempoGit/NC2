//
//  TabSelection.swift
//  Amazon Prime Video Copy
//
//  Created by Salvatore Manna on 10/12/21.
//

import SwiftUI

struct TabSelection: View {
    //Calling the class that holds the variable of interest
    @EnvironmentObject var myModelClassInstance: MyModelClass
    //Defining the variable that handles the animation for the "Welcome Back" rectangle
    @State private var opacityForOpening: CGFloat = 0
    
    
    var body: some View {
        
        ZStack(){
            //Creating a tabView for the bottom navigation on the screen
            TabView(selection: $myModelClassInstance.tagForTabView){
                Temporary()
                    .zIndex(1)
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(0)
                SecondView()
                    .tabItem{
                        Label("Store", systemImage: "bag")
                    }
                    .tag(1)
                
                ThirdView()
                    .tabItem{
                        Label("Search", systemImage: "magnifyingglass")
                    }
                    .tag(2)
                FourthView()
                    .tabItem {
                        Label("Downloads", systemImage: "square.and.arrow.down")
                    }
                    .tag(3)
                FifthView()
                    .tabItem{
                        Label("My stuff", systemImage: "person")
                    }
                    .tag(4)
            }
            .onAppear(){
                //Here I change the styling for the tab bar
                UITabBar.appearance().backgroundColor = .black
                UITabBar.appearance().unselectedItemTintColor = .systemGray
            }

            
            //This Zstack contains the little writing that sits on top of the tab bar on the bottom part of the screen
                ZStack{
                    Rectangle()
                        .fill(.blue)
                        .opacity(opacityForOpening)
                        .frame(width: screenWidth, height: screenHeight*0.06)
                        .animation(.easeInOut(duration: 0.5), value: opacityForOpening)
                    HStack{
                        Text("Welcome back")
                            .opacity(opacityForOpening)
                            .animation(.easeInOut(duration: 0.5), value: opacityForOpening)
                            .padding()
                        Spacer()
                    }
                }
                .offset(y: screenHeight*0.37)
            
            //Inside of the myModelClass I have a showDetails variable that is set by default to false, when this variable is set to true I overlay a ZStack on top of the screen that completely covers the tab bar and overlays on top of the rest of the screen with a set amount of opacity
            if(myModelClassInstance.showDetails){
                //I set the alignment to .bottom so that the VStack automatically goes to the bottom of the screen
                ZStack(alignment: .bottom){
                    //Here I set the background with opacity, and I also set an onTapGesture so that if click on the transparent background I dismiss this ZStack
                    Color(.black)
                        .opacity(myModelClassInstance.offsetForOpacity)
                        .animation(.easeInOut(duration: 0.1), value: myModelClassInstance.offsetForOpacity)
                        .onTapGesture(perform: {
                            myModelClassInstance.offsetForOpacity = 0
                            myModelClassInstance.offsetForDismiss = screenHeight
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                                myModelClassInstance.showDetails = false
                                myModelClassInstance.offsetForOpacity = 0.6
                            }
                        })
                    
                    //Here I create the VStack that holds all the informations about seasons
                    VStack(spacing: 0){
                        ZStack{
                            Rectangle()
                                .fill(InViewDarkGray)
                                .frame(width: screenWidth, height: screenHeight*0.07)
                            Text("\(myModelClassInstance.currentElement.Title)")
                                .fontWeight(.bold)
                                .padding(.horizontal, 30)
                        }
                        //For every item inside the seriesNUmbersAndId I create a rectangle in which I show the seasons for that show and if they are prime or not
                        ForEach(0..<myModelClassInstance.seriesNumbersAndId.count){index in
                            ZStack{
                                Rectangle()
                                    .fill(InViewDarkGray)
                                    .frame(width: screenWidth, height: screenHeight*0.04)
                                HStack{
                                    if(myModelClassInstance.seriesNumbersAndId[index].seriesNumbers == myModelClassInstance.currentElement.SeriesNumber){
                                        Text("Season \(myModelClassInstance.seriesNumbersAndId[index].seriesNumbers)")
                                            .foregroundColor(.white)
                                    } else {
                                        Text("Season \(myModelClassInstance.seriesNumbersAndId[index].seriesNumbers)")
                                            .foregroundColor(Color(.systemGray))
                                    }
                                    Spacer()
                                    if(myModelClassInstance.currentElement.IsPrime == "1"){
                                        Text("prime")
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding(.horizontal, 30)
                            }
                        }
                        //This is the rectangle that sits on top of the tab bar and covers it
                        Rectangle()
                            .fill(InViewDarkGray)
                            .frame(width: screenWidth, height: screenHeight*0.07)
                        }
                    .offset(y: myModelClassInstance.offsetForDismiss)
                    .animation(.spring(), value: myModelClassInstance.offsetForDismiss)
                    .gesture(DragGesture()
                                .onEnded({value in
                        if(value.translation.height > 0){
                            myModelClassInstance.offsetForOpacity = 0
                            myModelClassInstance.offsetForDismiss = screenHeight
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                                myModelClassInstance.showDetails = false
                                myModelClassInstance.offsetForOpacity = 0.6
                            }
                        }
                    }))
                }
                .frame(width: .infinity, height: screenHeight)
                .zIndex(10)
            }
            
            //Here is the same thing as the if on top of this one, but this ZStack shows the languages
            if(myModelClassInstance.showLanguages){
                ZStack(alignment: .bottom){
                    Color(.black)
                        .opacity(myModelClassInstance.offsetForOpacity)
                        .animation(.easeInOut(duration: 0.1), value: myModelClassInstance.offsetForOpacity)
                        .onTapGesture(perform: {
                            myModelClassInstance.offsetForOpacity = 0
                            myModelClassInstance.offsetForDismiss = screenHeight
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                                myModelClassInstance.showLanguages = false
                                myModelClassInstance.offsetForOpacity = 0.6
                            }
                        })
                    
                    //This VStack holds the available languages for the movie/show on screen
                    VStack(spacing: 0){
                        HStack{
                            VStack(alignment: .leading){
                                Text("Available languages")
                                    .fontWeight(.bold)
                                Text("You can change languages while the video is plaing")
                                    .foregroundColor(Color(.systemGray))
                            }
                            .padding(.vertical, 20)
                            .padding(.horizontal, 30)
                            Spacer()
                        }
                        .background(InViewDarkGray)
                        
                        HStack{
                            VStack(alignment: .leading){
                                Text("Audio")
                                Text("\(myModelClassInstance.currentElement.AudioLanguages)")
                                    .foregroundColor(Color(.systemGray))
                            }
                            .padding(.vertical, 20)
                            .padding(.horizontal, 30)
                            Spacer()
                        }
                        .background(InViewDarkGray)
                        ZStack{
                            Rectangle()
                                .fill(InViewDarkGray)
                                .frame(width: screenWidth, height: screenHeight*0.1)
                            HStack{
                                VStack(alignment: .leading){
                                    Text("Subtitles")
                                    Text("\(myModelClassInstance.currentElement.SubtitleLanguages)")
                                        .foregroundColor(Color(.systemGray))
                                }
                                .padding(.horizontal, 30)
                                Spacer()
                            }
                        }
                        
                        Rectangle()
                            .fill(InViewDarkGray)
                            .frame(width: screenWidth, height: screenHeight*0.07)
                        }
                    .offset(y: myModelClassInstance.offsetForDismiss)
                    .animation(.spring(), value: myModelClassInstance.offsetForDismiss)
                    .gesture(DragGesture()
                                .onEnded({value in
                        if(value.translation.height > 0){
                            myModelClassInstance.offsetForOpacity = 0
                            myModelClassInstance.offsetForDismiss = screenHeight
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                                myModelClassInstance.showLanguages = false
                                myModelClassInstance.offsetForOpacity = 0.6
                            }
                        }
                    }))
                }
                .frame(width: .infinity, height: screenHeight)
                .zIndex(10)
            }
            
            //Again, same logic as the ones on top, just that this ZStack shows the trailer of the movie/show
            if(myModelClassInstance.showTrailer){
                ZStack(alignment: .bottom){
                    Color(.black)
                        .opacity(myModelClassInstance.offsetForOpacity)
                        .animation(.easeInOut(duration: 0.1), value: myModelClassInstance.offsetForOpacity)
                        .onTapGesture(perform: {
                            myModelClassInstance.offsetForOpacity = 0
                            myModelClassInstance.offsetForDismiss = screenHeight
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                                myModelClassInstance.showTrailer = false
                                myModelClassInstance.offsetForOpacity = 0.6
                            }
                        })
                    
                    ZStack{
                        Button(action: {
                            myModelClassInstance.offsetForOpacity = 0
                            myModelClassInstance.offsetForDismiss = screenHeight
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                                myModelClassInstance.showTrailer = false
                                myModelClassInstance.offsetForOpacity = 0.6
                            }
                        }){
                            Image(systemName: "x.circle")
                                .resizable()
                                .frame(width: screenWidth*0.1, height: screenWidth*0.1)
                                .foregroundColor(.white)
                                .position(x: screenWidth*0.9, y: screenHeight*0.067)
                        }
                        VideoView(videoID: myModelClassInstance.currentElement.TrailerLink)
                            .frame(width: screenWidth, height: screenHeight*0.3)
                            .position(x: screenWidth/2, y: screenHeight/2)
                    }
                    .offset(y: myModelClassInstance.offsetForDismiss)
                    .animation(.spring(), value: myModelClassInstance.offsetForDismiss)
                    .gesture(DragGesture()
                                .onEnded({value in
                        if(value.translation.height > 0){
                            myModelClassInstance.offsetForOpacity = 0
                            myModelClassInstance.offsetForDismiss = screenHeight
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                                myModelClassInstance.showTrailer = false
                                myModelClassInstance.offsetForOpacity = 0.6
                            }
                        }
                    }))
                    
                    
                }
                .frame(width: .infinity, height: screenHeight)
                .zIndex(10)
            }
            
        }
        .frame(width: .infinity, height: .infinity)
        .preferredColorScheme(.dark)
        .onAppear(perform: {
            if(myModelClassInstance.onOpening){
                myModelClassInstance.onOpening = false
                opacityForOpening = 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                        opacityForOpening = 0
                }
            }
        })
        
        
    }
    //End of body
}


struct SecondView: View{
    
    var body: some View{
        ZStack{
            InViewDarkGray.ignoresSafeArea()
            VStack(spacing: 20){
                Text("HELLO!")
                    .fontWeight(.bold)
                Text("")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Text("Unfortunately there is currently nothing.")
                Text("Bye for now!")
                    .fontWeight(.bold)
            }
        }
        .frame(width: .infinity, height: .infinity)
    }
}

struct ThirdView: View{
    
    var body: some View{
        ZStack{
            InViewDarkGray.ignoresSafeArea()
            VStack(spacing: 20){
                Text("Still going through the tab bar items I gather.")
                    .fontWeight(.bold)
                Text("Here there should be the search bar to search through the movies and series and stuff, but as you can see this page is also empty.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Text("Bye bye.")
                    .fontWeight(.bold)
                
            }
            
        }
    }
}

struct FourthView: View{
    
    var body: some View{
        ZStack{
            InViewDarkGray.ignoresSafeArea()
            VStack(spacing: 20){
                Text("You should have understood by now that all the other tabs except the home now are empty")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
    }
}

struct FifthView: View{
    @State private var bouncing = false
    var body: some View{
        ZStack{
            InViewDarkGray.ignoresSafeArea()
            VStack(spacing: 20){
                Text("Dude, what are you still doing going through the tabs? They are \(Text("EMPTY").fontWeight(.bold))")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Text("\(Text("BUT").fontWeight(.bold)) since you got till here get this little floating X")
                    .padding(.bottom, 50)
                Image(systemName: "xmark.seal")
                    .resizable()
                    .frame(width: screenWidth*0.4, height: screenWidth*0.4)
                    .frame(maxHeight: screenHeight*0.3, alignment: bouncing ? .bottom : .top)
                    .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true))
                    .onAppear(perform: {
                        self.bouncing.toggle()
                    })
                
            }
        }
    }
    
}


struct TabSelection_Previews: PreviewProvider {
    static var previews: some View {
        TabSelection()
            .environmentObject(MyModelClass())
    }
}
