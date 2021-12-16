//
//  Temporary.swift
//  Amazon Prime Video Copy
//
//  Created by Salvatore Manna on 11/12/21.
//

import SwiftUI

struct Temporary: View, HomeModelDelegate {
    
//    init(){
//        UINavigationBar.appearance().backgroundColor = UIColor(InViewDarkGray)
//    }
    
    @EnvironmentObject var myModelClassInstance: MyModelClass
    var homeModel = HomeModel()
    
    @State var myFeaturedMovies:[Movie] = []
    @State var harryPotterMovies:[Movie] = []
    @State var tvShowsArray: [Movie] = []
    @State var myMovies:[Movie] = []
    @State var anime: [Movie] = []
    
    @State var featuredIndex = 0
    @State var zStackOffset:CGFloat = 0
    
    @State var firsTime: Bool = true
    
    @State var topNavigationSelection: Int = 1
    
    @State private var opacityForOpening: CGFloat = 0
    
    @State var showDetails: Bool = false
    @State var numberOfSeasons: Int = 0
    
    @State private var reset: Bool = false
    
    var body: some View {
        NavigationView{
            ZStack{
                InViewDarkGray
                    .ignoresSafeArea()
                
                    
                VStack(spacing: 0){
                    
                    Image("AmazonPrimeLogo")
                        .resizable()
                        .frame(width: screenWidth/5, height: screenHeight/24)
                    
                    TopNavigation(topNavigationSelection: $topNavigationSelection)
                    
                    switch topNavigationSelection {
                    case 1:
                        ScrollView{
                            
                            VStack{
                                //Calling the view that creates the first custom view from the top
                                CustomTabView(myFeaturedMovies: myFeaturedMovies)
                                
                                //Calling the view that creates the three scrollable views between the first tabview and the "Featured previews" tabview and the "Featured previews" tabview itself
                                BetweenTopAndPreviews(reset: $reset)
                                
                                //Calling the view that creates the other scrollable views below the "Featured previews" tab view
                                OtherScrollableElements()
                                
                                
                                
                                //Rectangle I placed here only to make everything scrollable all the way through to balance the tab bar on the bottom
                                Rectangle()
                                    .fill()
                                    .opacity(0.001)
                                    .frame(width: screenWidth, height: screenHeight/12)
                                
                            }
                            .offset(y: 0.001*screenHeight)
                            //END OF VSTACK THAT HOLDS THE ELEMENTS TO SCROLL THROUGH
                        
                        }
                        //END OF SCROLLVIEW
                    case 2:
                        ScrollView{
                            VStack{
                                ZStack{
                                    Text("TV WIP")
                                   
                                }
                                .frame(width: screenWidth, height: screenHeight*0.19)
                            }
                            .offset(y: 0.001*screenHeight)
                        }
                    case 3:
                        ScrollView{
                            VStack{
                                ZStack{
                                    Text("MOVIES WIP")
                                   
                                }
                                .frame(width: screenWidth, height: screenHeight*0.19)
                            }
                            .offset(y: 0.001*screenHeight)
                        }
                    case 4:
                        ScrollView{
                            VStack{
                                ZStack{
                                    Text("KIDS WIP")
                                   
                                }
                                .frame(width: screenWidth, height: screenHeight*0.19)
                            }
                            .offset(y: 0.001*screenHeight)
                        }
                    case 5:
                        ScrollView{
                            VStack{
                                ZStack{
                                    Text("SPORTS WIP")
                                   
                                }
                                .frame(width: screenWidth, height: screenHeight*0.19)
                            }
                            .offset(y: 0.001*screenHeight)
                        }
                    default:
                        ScrollView{
                            VStack{
                                ZStack{
                                    Text("DEFAULT WIP")
                                   
                                }
                                .frame(width: screenWidth, height: screenHeight*0.19)
                            }
                            .offset(y: 0.001*screenHeight)
                        }
                        
                    }
                    
                }
                //END OF VSTACK
            
            }
            .onAppear(perform: {
                //On Appear I check a variable, if this variable is true I send a query to the database to fetch the data, otherwise I jsut create the myFeaturedMovies array
                if(myModelClassInstance.isFirstTime){
                    homeModel.getItems()
                    homeModel.delegate = self
                } else {
                    for movie in self.myModelClassInstance.myMovies {
                        if(movie.IsFeatured == "1"){
                            myFeaturedMovies.append(movie)
                        }
                    }
                }
            })
            .preferredColorScheme(.dark)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            //END OF ZSTACK
        }
        .accentColor(.white)
        //END OF NAVIGATION VIEW
    }
    
    
    
    
    
    func itemsDownloaded(movies: [Movie]) {
        
        self.myMovies = movies
        
        self.myModelClassInstance.myMovies = movies
        
        print("Counter: \(myModelClassInstance.myMovies.count)")
        
        if(myModelClassInstance.isFirstTime){
            
            for index in 0..<self.myModelClassInstance.myMovies.count {
                if(self.myModelClassInstance.myMovies[index].IsFeatured == "1"){
                    myFeaturedMovies.append(self.myModelClassInstance.myMovies[index])
                    self.myModelClassInstance.featuredIndexes.append(index)
                    self.reset = true
                }
            }
            myModelClassInstance.isFirstTime = false
        }
    }
    
}

struct CustomTabView: View{
    @EnvironmentObject var myModelClassInstance: MyModelClass
    var myFeaturedMovies: [Movie]
    
    //Index to handle the tab bar
    @State private var featuredIndex = 0
    //Index to actually select the item from the tab bar
    @State private var featuredSelectionIndex = 0
    //Variables to handle the tab bar animations
    @State private var zStackOffset: CGFloat = 0
    @State private var zStackOffsetChanged: CGFloat = 0
    
    //Variable to trigger the navigationLink
    @State private var selection:String? = nil

    
    var body: some View{
        ZStack{
            if(myFeaturedMovies.count == 0) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            } else {
                ZStack{
                    //Here I go through the featured movies and if there is a thumbnail I display it on screen otherwise I just print a Rectangle
                    ForEach(0..<myFeaturedMovies.count, id: \.self){index in
                        if(myFeaturedMovies[index].IsFeatured == "1"){
                            if(myFeaturedMovies[index].HasMovieThumbnail == "1"){
                                Image(uiImage: UIImage(data: Data(base64Encoded: myFeaturedMovies[index].MovieThumbnail)!)!)
                                    .resizable()
                                    .offset(x: CGFloat(index)*screenWidth)
                                    .onTapGesture(perform: {
                                        featuredSelectionIndex = myModelClassInstance.featuredIndexes[index]
                                        selection = "Details"
                                        
                                    })
                            } else {
                                Rectangle()
                                    .fill(.black)
                                    .offset(x: CGFloat(index)*screenWidth)
                            }
                        }
                    }
                }
                .frame(width: screenWidth, height: screenHeight*0.19)
                .animation(.easeInOut, value: zStackOffset)
                .animation(.easeInOut, value: zStackOffsetChanged)
                .offset(x: zStackOffset + zStackOffsetChanged)
                .gesture(DragGesture()
                            .onChanged{value in
                    //To provide an animation while swiping
                    zStackOffsetChanged = value.translation.width
                }
                            .onEnded{value in
                    //I reset this value to not fuck up the tab bar
                    zStackOffsetChanged = 0
                    if(value.translation.width < 0){
                        //Swipe from middle(right) to left, move the current image to the left
//                        if(featuredIndex != 3){
//                            featuredIndex += 1
//                            zStackOffset -= screenWidth
//                        } else {
//                            featuredIndex = 0
//                            zStackOffset = 0
//                        }
                        if(featuredIndex != 3){
                            featuredIndex += 1
                            zStackOffset -= screenWidth
                        }
                        
                        
                    } else if(value.translation.width > 0){
                        //Swipe from middle(or left) to right, move the current image to the right
//                        if(featuredIndex == 0){
//                            featuredIndex = 3
//                            zStackOffset = 3*screenWidth
//                        } else {
//                            featuredIndex -= 1
//                            zStackOffset += screenWidth
//                        }
                        if(featuredIndex > 0){
                            featuredIndex -= 1
                            zStackOffset += screenWidth
                        }
                    }
                })
                //Here I create the small dots for the tab view
                VStack{
                    Spacer()
                    HStack{
                        ForEach(0..<4, id: \.self){index in
                            if(index == featuredIndex){
                                Circle()
                                    .fill(.white)
                                    .frame(width: 10, height: 10)
                            }else{
                                Circle()
                                    .fill(Color(.systemGray3))
                                    .frame(width: 8, height: 8)
                            }
                        }
                    }
                }
            }
            
        }
        .frame(width: screenWidth, height: screenHeight*0.19)
        
        
        if(myFeaturedMovies.count != 0){
            NavigationLink(destination: DetailsView(currentElement: myModelClassInstance.myMovies[featuredSelectionIndex]), tag: "Details", selection: $selection){EmptyView()}
        }

        
    }
    
}

struct TopNavigation: View{
    
    @State private var homeColor: Color = .white
    @State private var tvColor: Color = InViewDarkGray
    @State private var moviesColor: Color = InViewDarkGray
    @State private var kidsColor: Color = InViewDarkGray
    @State private var sportsColor: Color = InViewDarkGray
    
    @State private var homeWritingColor: Color = .white
    @State private var tvWritingColor: Color = Color(.systemGray)
    @State private var moviesWritingColor: Color = Color(.systemGray)
    @State private var kidsWritingColor: Color = Color(.systemGray)
    @State private var sportsWritingColor: Color = Color(.systemGray)
    
    @Binding var topNavigationSelection: Int
    
    var body: some View{
        HStack(spacing: 15){
            VStack(spacing: 3){
                Text("Home")
                    .foregroundColor(homeWritingColor)
                    .onTapGesture(perform: {
                        if(homeColor != .white){
                            homeColor = .white
                            tvColor = InViewDarkGray
                            moviesColor = InViewDarkGray
                            kidsColor = InViewDarkGray
                            sportsColor = InViewDarkGray
                            
                            homeWritingColor = .white
                            tvWritingColor = Color(.systemGray)
                            moviesWritingColor = Color(.systemGray)
                            kidsWritingColor = Color(.systemGray)
                            sportsWritingColor = Color(.systemGray)
                            
                            topNavigationSelection = 1
                        }
                    })
                Rectangle()
                    .fill(homeColor)
                    .frame(width: 55, height: 3)
            }
            VStack(spacing: 3){
                Text("Tv")
                    .foregroundColor(tvWritingColor)
                    .onTapGesture(perform: {
                        if(tvWritingColor != .white){
                            tvColor = .white
                            homeColor = InViewDarkGray
                            moviesColor = InViewDarkGray
                            kidsColor = InViewDarkGray
                            sportsColor = InViewDarkGray
                            
                            tvWritingColor = .white
                            homeWritingColor = Color(.systemGray)
                            moviesWritingColor = Color(.systemGray)
                            kidsWritingColor = Color(.systemGray)
                            sportsWritingColor = Color(.systemGray)
                            
                            topNavigationSelection = 2
                        }
                    })
                Rectangle()
                    .fill(tvColor)
                    .frame(width: 30, height: 3)
            }
            
            VStack(spacing: 3){
                Text("Movies")
                    .foregroundColor(moviesWritingColor)
                    .onTapGesture(perform: {
                        if(moviesWritingColor != .white){
                            moviesColor = .white
                            homeColor = InViewDarkGray
                            tvColor = InViewDarkGray
                            kidsColor = InViewDarkGray
                            sportsColor = InViewDarkGray
                            
                            moviesWritingColor = .white
                            homeWritingColor = Color(.systemGray)
                            tvWritingColor = Color(.systemGray)
                            kidsWritingColor = Color(.systemGray)
                            sportsWritingColor = Color(.systemGray)
                            
                            topNavigationSelection = 3
                        }
                    })
                Rectangle()
                    .fill(moviesColor)
                    .frame(width: 60, height: 3)
            }
            VStack(spacing: 3){
                Text("Kids")
                    .foregroundColor(kidsWritingColor)
                    .onTapGesture(perform: {
                        if(kidsWritingColor != .white){
                            kidsColor = .white
                            homeColor = InViewDarkGray
                            moviesColor = InViewDarkGray
                            tvColor = InViewDarkGray
                            sportsColor = InViewDarkGray
                            
                            kidsWritingColor = .white
                            homeWritingColor = Color(.systemGray)
                            moviesWritingColor = Color(.systemGray)
                            tvWritingColor = Color(.systemGray)
                            sportsWritingColor = Color(.systemGray)
                            
                            topNavigationSelection = 4
                        }
                    })
                Rectangle()
                    .fill(kidsColor)
                    .frame(width: 40, height: 3)
            }
            VStack(spacing: 3){
                Text("Sports")
                    .foregroundColor(sportsWritingColor)
                    .onTapGesture(perform: {
                        if(sportsWritingColor != .white){
                            sportsColor = .white
                            homeColor = InViewDarkGray
                            moviesColor = InViewDarkGray
                            kidsColor = InViewDarkGray
                            tvColor = InViewDarkGray
                            
                            sportsWritingColor = .white
                            homeWritingColor = Color(.systemGray)
                            moviesWritingColor = Color(.systemGray)
                            kidsWritingColor = Color(.systemGray)
                            tvWritingColor = Color(.systemGray)
                            
                            topNavigationSelection = 5
                        }
                    })
                Rectangle()
                    .fill(sportsColor)
                    .frame(width: 60, height: 3)
            }
        }
//        .offset(y: -screenHeight*0.41)
    }
}



struct BetweenTopAndPreviews: View{
    @EnvironmentObject var myModelClassInstance: MyModelClass
    
    //Variables to handle the navigationLinks
    @State private var selection: String? = nil
    @State private var selectionIndex: Int = 0
    
    @Binding var reset:Bool
    
    var body: some View{
        VStack(alignment: .leading){
            
            //For every scroll view I create a foreach on all the elements retrieved from the dtabase and if they are "Anime" or a "Tv Show" or if it is a Harry Potter movies then I insert it in the scrollable view
            
            VStack(alignment: .leading){
                Text("Included with prime")
                    .padding(.horizontal, 30)
                    .font(.system(size: 13))
                    .foregroundColor(.blue)
                Text("Anime")
                    .fontWeight(.bold)
                    .font(.system(size: 18))
                    .padding(.horizontal, 30)
                ZStack{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 15){
                            if(myModelClassInstance.myMovies.count == 0){
                                Spacer()
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .padding(.horizontal, 30)
                            } else {
                                ForEach(0..<myModelClassInstance.myMovies.count, id: \.self){index in
                                    if(myModelClassInstance.myMovies[index].ElementType == "Anime"){
                                        if(myModelClassInstance.myMovies[index].HasMovieThumbnail == ("1")){
                                            Image(uiImage: UIImage(data: Data(base64Encoded: myModelClassInstance.myMovies[index].MovieThumbnail)!)!)
                                                .resizable()
                                                .frame(width: screenWidth*0.36, height: screenHeight*0.1)
                                                .cornerRadius(5)
                                                .onTapGesture(perform: {
                                                    selectionIndex = index
                                                    selection = "Details"
                                                })
                                        } else {
                                            ZStack{
                                                Rectangle()
                                                    .fill(Color(.systemGray2))
                                                    .frame(width: screenWidth*0.36, height: screenHeight*0.1)
                                                    .onTapGesture(perform: {
                                                        selectionIndex = index
                                                        selection = "Details"
                                                    })
                                                VStack{
                                                    Spacer()
                                                    Text("\(myModelClassInstance.myMovies[index].Title)")
                                                        .multilineTextAlignment(.center)
                                                    
                                                }
                                                
                                            }
                                            .frame(width: screenWidth*0.36, height: screenHeight*0.1)
                                        }
                                    }
                                }
                            }
                        }
                        .offset(x: 30)
                    }
                }
                .frame(width: screenWidth, height: 0.1*screenHeight)
            }
            .padding(.top, 20)
            
            
            VStack(alignment: .leading){
                Text("Included with prime")
                    .padding(.horizontal, 30)
                    .font(.system(size: 13))
                    .foregroundColor(.blue)
                Text("Tv Shows")
                    .fontWeight(.bold)
                    .font(.system(size: 18))
                    .padding(.horizontal, 30)
                ZStack{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 15){
                            if(myModelClassInstance.myMovies.count == 0){
                                Spacer()
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .padding(.horizontal, 30)
                            } else {
                                ForEach(0..<myModelClassInstance.myMovies.count, id: \.self){index in
                                    if(myModelClassInstance.myMovies[index].ElementType == "Tv"){
                                        if(myModelClassInstance.myMovies[index].HasMovieThumbnail == ("1")){
                                            Image(uiImage: UIImage(data: Data(base64Encoded: myModelClassInstance.myMovies[index].MovieThumbnail)!)!)
                                                .resizable()
                                                .frame(width: screenWidth*0.36, height: screenHeight*0.1)
                                                .cornerRadius(5)
                                                .onTapGesture(perform: {
                                                    selectionIndex = index
                                                    selection = "Details"
                                                })
                                        } else {
                                            ZStack{
                                                Rectangle()
                                                    .fill(Color(.systemGray2))
                                                    .frame(width: screenWidth*0.36, height: screenHeight*0.1)
                                                    .onTapGesture(perform: {
                                                        selectionIndex = index
                                                        selection = "Details"
                                                    })
                                                VStack{
                                                    Spacer()
                                                    Text("\(myModelClassInstance.myMovies[index].Title)")
                                                        .multilineTextAlignment(.center)
                                                        
                                                    
                                                }
                                            }
                                            .frame(width: screenWidth*0.36, height: screenHeight*0.1)
                                        }
                                        
                                    }
                                }
                            }
                        }
                        .offset(x: 30)

                    }
                }
                .frame(width: screenWidth, height: 0.1*screenHeight)
            }
            .padding(.top, 25)

            
            
            VStack(alignment: .leading){
                Text("Included with prime")
                    .padding(.horizontal, 30)
                    .font(.system(size: 13))
                    .foregroundColor(.blue)
                Text("Harry Potter movies")
                    .fontWeight(.bold)
                    .font(.system(size: 18))
                    .padding(.horizontal, 30)
                ZStack{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 15){
                            if(myModelClassInstance.myMovies.count == 0){
                                Spacer()
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .padding(.horizontal, 30)
                            } else {
                                ForEach(0..<myModelClassInstance.myMovies.count, id: \.self){index in
                                    if(myModelClassInstance.myMovies[index].Title.contains("Harry Potter")){
                                        if(myModelClassInstance.myMovies[index].HasMovieThumbnail == ("1")){
                                            Image(uiImage: UIImage(data: Data(base64Encoded: myModelClassInstance.myMovies[index].MovieThumbnail)!)!)
                                                .resizable()
                                                .frame(width: screenWidth*0.36, height: screenHeight*0.1)
                                                .cornerRadius(5)
                                                .onTapGesture(perform: {
                                                    selectionIndex = index
                                                    selection = "Details"
                                                })
                                        } else {
                                            ZStack{
                                                Rectangle()
                                                    .fill(Color(.systemGray2))
                                                    .frame(width: screenWidth*0.36, height: screenHeight*0.1)
                                                    .onTapGesture(perform: {
                                                        selectionIndex = index
                                                        selection = "Details"
                                                    })
                                                VStack{
                                                    Spacer()
                                                    Text("\(myModelClassInstance.myMovies[index].Title)")
                                                        .multilineTextAlignment(.center)
                                                        
                                                    
                                                }
                                            }
                                            .frame(width: screenWidth*0.36, height: screenHeight*0.1)
                                        }
                                        
                                    }
                                }
                            }
                        }
                        .offset(x: 30)
                    }
                }
                .frame(width: screenWidth, height: 0.1*screenHeight)
            }
            .padding(.top, 25)
            
            
            Text("Featured previews")
                .fontWeight(.bold)
                .font(.system(size: 18))
                .padding(.horizontal, 30)
                .padding(.top, 30)
            
            
            CustomTabViewPreviews()
                .padding(.bottom, 20)
            
            
            if(myModelClassInstance.myMovies.count != 0){
                NavigationLink(destination: DetailsView(currentElement: myModelClassInstance.myMovies[selectionIndex]), tag: "Details", selection: $selection){EmptyView()}
            }
            
        }
            
    }
    
    
}

struct CustomTabViewPreviews: View{
    //TO SUBSTITUTE WITH A CONDITION FOR THE PREVIEWS
    @State private var go = true
    //TO ADD: THE MOVIES ARRAY
    //TO ADD: THE VIDEOS
    
    @State private var previewsIndex = 0
    @State private var zStackOffset: CGFloat = 0
    @State private var zStackOffsetChanged: CGFloat = 0
    
    var body: some View{
        
        ZStack{
            if(!go) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            } else {
                VStack{
                    ZStack{
                        ForEach(0..<10, id: \.self){index in
                            ZStack{
                                Rectangle()
                                    .fill(Color(.systemGray2))
                                    .frame(width: screenWidth, height: screenHeight*0.22)
                                    .offset(x: CGFloat(index)*screenWidth)
                                Text("WIP")
                                    .offset(x: CGFloat(index)*screenWidth)
                            }
                        }
                    }
                    .frame(width: screenWidth, height: screenHeight*0.22)
                    .animation(.easeInOut, value: zStackOffset)
                    .animation(.easeInOut, value: zStackOffsetChanged)
                    .offset(x: zStackOffset + zStackOffsetChanged)
                    .gesture(DragGesture()
                                .onChanged{value in
                        zStackOffsetChanged = value.translation.width
                    }
                                .onEnded{value in
                        zStackOffsetChanged = 0
                        if(value.translation.width < 0){
                            //Swipe from middle(right) to left, move the current image to the left
                            if(previewsIndex < 10-1){
                                previewsIndex += 1
                                zStackOffset -= screenWidth
                            }
                        } else if(value.translation.width > 0){
                            //Swipe from middle(or left) to right, move the current image to the right
                            if(previewsIndex != 0){
                                previewsIndex -= 1
                                zStackOffset += screenWidth
                            }
                        }


                    })
                    Spacer()
                }
                VStack{
                    Spacer()
                    HStack{
                        ForEach(0..<10, id: \.self){index in
                            if(index == previewsIndex){
                                Circle()
                                    .fill(.blue)
                                    .frame(width: 15, height: 15)
                            }else{
                                Circle()
                                    .fill(Color(.systemGray2))
                                    .frame(width: 10, height: 10)
                            }
                        }
                    }
                    .padding(.bottom, 2)
                }
            }
            
        }
        .frame(width: screenWidth, height: screenHeight*0.25)
        //END OF CUSTOM TABVIEW

    }
    
}

struct OtherScrollableElements: View{
    

    var body: some View{
        VStack(alignment: .leading){
            
            VStack(alignment: .leading){
                Text("Included with prime")
                    .padding(.horizontal, 30)
                    .font(.system(size: 13))
                    .foregroundColor(.blue)
                Text("Top movies \(Image(systemName: "chevron.right"))")
                    .fontWeight(.bold)
                    .font(.system(size: 18))
                    .padding(.horizontal, 30)
                ZStack{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 15){
                            ForEach(0..<20, id: \.self){index in
                                Button(action:{
                                    
                                }){
                                    ZStack{
                                        Rectangle()
                                            .fill(Color(.systemGray2))
                                            .frame(width: screenWidth*0.36, height: screenHeight*0.1)
                                            .cornerRadius(10)
                                        Text("WIP")
                                    }
                                }
                            }
                        }
                        .offset(x: 30)
                    }
                }
                .frame(width: screenWidth, height: 0.1*screenHeight)
            }
            .padding(.top, 20)
            
            
            VStack(alignment: .leading){
                Text("Included with prime")
                    .padding(.horizontal, 30)
                    .font(.system(size: 13))
                    .foregroundColor(.blue)
                Text("Sci-fi movies")
                    .fontWeight(.bold)
                    .font(.system(size: 18))
                    .padding(.horizontal, 30)
                ZStack{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 15){
                            ForEach(0..<20, id: \.self){index in
                                Button(action: {
                                    
                                }){
                                    ZStack{
                                        Rectangle()
                                            .fill(Color(.systemGray2))
                                            .frame(width: screenWidth*0.36, height: screenHeight*0.1)
                                            .cornerRadius(10)
                                        Text("WIP")
                                    }
                                }
                            }
                        }
                        .offset(x: 30)
                    }
                }
                .frame(width: screenWidth, height: 0.1*screenHeight)
            }
            .padding(.top, 25)

            
            
            VStack(alignment: .leading){
                Text("Included with prime")
                    .padding(.horizontal, 30)
                    .font(.system(size: 13))
                    .foregroundColor(.blue)
                Text("Top TV")
                    .fontWeight(.bold)
                    .font(.system(size: 18))
                    .padding(.horizontal, 30)
                ZStack{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 15){
                            ForEach(0..<20, id: \.self){index in
                                Button(action: {
                                    
                                }){
                                    ZStack{
                                        Rectangle()
                                            .fill(Color(.systemGray2))
                                            .frame(width: screenWidth*0.36, height: screenHeight*0.1)
                                            .cornerRadius(10)
                                        Text("WIP")
                                    }
                                }                            }
                        }
                        .offset(x: 30)
                    }
                }
                .frame(width: screenWidth, height: 0.1*screenHeight)
            }
            .padding(.top, 25)
            
       
            VStack(alignment: .leading){
                Text("Included with prime")
                    .padding(.horizontal, 30)
                    .font(.system(size: 13))
                    .foregroundColor(.blue)
                Text("Action and adventure movies \(Image(systemName: "chevron.right"))")
                    .fontWeight(.bold)
                    .font(.system(size: 18))
                    .padding(.horizontal, 30)
                ZStack{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 15){
                            ForEach(0..<20, id: \.self){index in
                                Button(action: {
                                    
                                }){
                                    ZStack{
                                        Rectangle()
                                            .fill(Color(.systemGray2))
                                            .frame(width: screenWidth*0.36, height: screenHeight*0.1)
                                            .cornerRadius(10)
                                        Text("WIP")
                                    }
                                }
                            }
                        }
                        .offset(x: 30)
                    }
                }
                .frame(width: screenWidth, height: 0.1*screenHeight)
            }
            .padding(.top, 25)
            
            VStack(alignment: .leading){
                Text("Included with prime")
                    .padding(.horizontal, 30)
                    .font(.system(size: 13))
                    .foregroundColor(.blue)
                Text("Movies in English \(Image(systemName: "chevron.right"))")
                    .fontWeight(.bold)
                    .font(.system(size: 18))
                    .padding(.horizontal, 30)
                ZStack{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 15){
                            ForEach(0..<20, id: \.self){index in
                                Button(action: {
                                    
                                }){
                                    ZStack{
                                        Rectangle()
                                            .fill(Color(.systemGray2))
                                            .frame(width: screenWidth*0.36, height: screenHeight*0.1)
                                            .cornerRadius(10)
                                        Text("WIP")
                                    }
                                }
                            }
                        }
                        .offset(x: 30)
                    }
                }
                .frame(width: screenWidth, height: 0.1*screenHeight)
            }
            .padding(.top, 25)
            
            VStack(alignment: .leading){
                Text("Included with prime")
                    .padding(.horizontal, 30)
                    .font(.system(size: 13))
                    .foregroundColor(.blue)
                Text("Drama TV >")
                    .fontWeight(.bold)
                    .font(.system(size: 18))
                    .padding(.horizontal, 30)
                ZStack{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 15){
                            ForEach(0..<20, id: \.self){index in
                                Button(action: {
                                    
                                }){
                                    ZStack{
                                        Rectangle()
                                            .fill(Color(.systemGray2))
                                            .frame(width: screenWidth*0.36, height: screenHeight*0.1)
                                            .cornerRadius(10)
                                        Text("WIP")
                                    }
                                }
                            }
                        }
                        .offset(x: 30)
                    }
                }
                .frame(width: screenWidth, height: 0.1*screenHeight)
            }
            .padding(.top, 25)
            
            VStack(alignment: .leading){
                Text("Included with prime")
                    .padding(.horizontal, 30)
                    .font(.system(size: 13))
                    .foregroundColor(.blue)
                Text("Thriller movies \(Image(systemName: "chevron.right"))")
                    .fontWeight(.bold)
                    .font(.system(size: 18))
                    .padding(.horizontal, 30)
                ZStack{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 15){
                            ForEach(0..<20, id: \.self){index in
                                Button(action: {
                                    
                                }){
                                    ZStack{
                                        Rectangle()
                                            .fill(Color(.systemGray2))
                                            .frame(width: screenWidth*0.36, height: screenHeight*0.1)
                                            .cornerRadius(10)
                                        Text("WIP")
                                    }
                                }
                            }
                        }
                        .offset(x: 30)
                    }
                }
                .frame(width: screenWidth, height: 0.1*screenHeight)
            }
            .padding(.top, 25)
            
            VStack(alignment: .leading){
                Text("Included with prime")
                    .padding(.horizontal, 30)
                    .font(.system(size: 13))
                    .foregroundColor(.blue)
                Text("Horror movies \(Image(systemName: "chevron.right"))")
                    .fontWeight(.bold)
                    .font(.system(size: 18))
                    .padding(.horizontal, 30)
                ZStack{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 15){
                            ForEach(0..<20, id: \.self){index in
                                Button(action: {
                                    
                                }){
                                    ZStack{
                                        Rectangle()
                                            .fill(Color(.systemGray2))
                                            .frame(width: screenWidth*0.36, height: screenHeight*0.1)
                                            .cornerRadius(10)
                                        Text("WIP")
                                    }
                                }
                            }
                        }
                        .offset(x: 30)
                    }
                }
                .frame(width: screenWidth, height: 0.1*screenHeight)
            }
            .padding(.top, 25)
            
            VStack(alignment: .leading){
                Text("Included with prime")
                    .padding(.horizontal, 30)
                    .font(.system(size: 13))
                    .foregroundColor(.blue)
                Text("Comedy movies \(Image(systemName: "chevron.right"))")
                    .fontWeight(.bold)
                    .font(.system(size: 18))
                    .padding(.horizontal, 30)
                ZStack{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 15){
                            ForEach(0..<20, id: \.self){index in
                                Button(action: {
                                    
                                }){
                                    ZStack{
                                        Rectangle()
                                            .fill(Color(.systemGray2))
                                            .frame(width: screenWidth*0.36, height: screenHeight*0.1)
                                            .cornerRadius(10)
                                        Text("WIP")
                                    }
                                }
                            }
                        }
                        .offset(x: 30)
                    }
                }
                .frame(width: screenWidth, height: 0.1*screenHeight)
            }
            .padding(.top, 25)
            
            VStack(alignment: .leading){
                Text("Included with prime")
                    .padding(.horizontal, 30)
                    .font(.system(size: 13))
                    .foregroundColor(.blue)
                Text("Ready to laugh?")
                    .fontWeight(.bold)
                    .font(.system(size: 18))
                    .padding(.horizontal, 30)
                ZStack{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 15){
                            ForEach(0..<20, id: \.self){index in
                                Button(action: {
                                    
                                }){
                                    ZStack{
                                        Rectangle()
                                            .fill(Color(.systemGray2))
                                            .frame(width: screenWidth*0.36, height: screenHeight*0.1)
                                            .cornerRadius(10)
                                        Text("WIP")
                                    }
                                }
                            }
                        }
                        .offset(x: 30)
                    }
                }
                .frame(width: screenWidth, height: 0.1*screenHeight)
            }
            .padding(.top, 25)
        }
    }
}


struct Temporary_Previews: PreviewProvider {
    static var previews: some View {
        TabSelection()
            .environmentObject(MyModelClass())
    }
}

