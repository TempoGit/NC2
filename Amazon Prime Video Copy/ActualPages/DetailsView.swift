//
//  DetailsView.swift
//  Amazon Prime Video Copy
//
//  Created by Salvatore Manna on 10/12/21.
//

import SwiftUI

//TO DO: When the while scrolling I get to Related and More Details, they should become part of navigation and get blocked on top of the screen, don't know how to do it though

struct DetailsView: View {

    @EnvironmentObject var myModelClassInstance: MyModelClass
    var currentElement: Movie
    
    
    @State private var actors: [String] = []
    
    @State private var orangeRent: Bool = false
    @State private var orangeBuy: Bool = false
    
    @State private var audioLanguages: [String] = []
    @State private var subtitlesLanguages: [String] = []
    
    //Variables to handle the selection of the two tabs: Related(or Episodes) and More Details
    @State private var relatedHeight: CGFloat = 1.5
    @State private var moreDetailsHeight: CGFloat = 0
    
    
    @State private var starringActors: String = ""
    @State private var supportingActors: String = ""
    @State private var directorsArray: [String] = []
    
    @State private var didYouKnowArray: [String] = []
    @State private var reviewsArray: [String] = []
    @State private var goofsArray: [String] = []
    @State private var quotesArray: [String] = []
    @State private var episodesTitlesArray: [String] = []
    
    
    @State private var lineLimitVariable: Int = 3
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
            ZStack{
                InViewDarkGray
                    .ignoresSafeArea()
                
                if(myModelClassInstance.dismissValue == true){
                    ZStack{
                        
                    }.onAppear(){
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ScrollView(showsIndicators: false){
                    VStack(alignment: .leading){
                        if(currentElement.HasMoviePoster == "1"){
                            Image(uiImage: UIImage(data: Data(base64Encoded: currentElement.MoviePoster)!)!)
                                .resizable()
                                .frame(width: screenWidth, height: screenHeight*0.25)
                        } else {
                            Rectangle()
                                .fill(Color(.systemGray3))
                                .frame(width: screenWidth, height: screenHeight*0.25)
                        }
                        Text(currentElement.Title)
                            .font(.system(size: 35))
                            .fontWeight(.bold)
                            .padding(.horizontal, 30)
                            .padding(.bottom, 1)
                        if(currentElement.HasSeries == "1"){
                            Text("Season \(currentElement.SeriesNumber) \(Image(systemName: "chevron.down"))")
                                .padding(.horizontal, 30)
                                .onTapGesture(perform: {
                                    myModelClassInstance.showDetails = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.001){
                                        myModelClassInstance.offsetForDismiss = 0
                                    }
                                })
                        } else if (currentElement.SeriesNumber != 0 && currentElement.HasSeries == "0"){
                            Text("Season \(currentElement.SeriesNumber)")
                                .padding(.horizontal, 30)
                        }
                        if(currentElement.IsPrime == "1"){
                            primeWritingButtons(currentElement: currentElement)
                        }
                        else {
                            if(currentElement.RentPrice != "Empty"){
                                OrangeRentButtons(currentElement: currentElement)
                            } else if(currentElement.BuyPrice != "Empty"){
                                OrangeBuyButtons(currentElement: currentElement)
                            }
                        }
                        HStackOptions(currentElement: currentElement)
                            .padding(.bottom, 30)

                        PlotAndDetails(currentElement: currentElement, subtitlesLanguages: subtitlesLanguages, audioLanguages: audioLanguages)
                        
                        //If there are episodes to display then I create the two selections, MoreDeatils and Episodes
                        if(currentElement.NumberOfEpisodes != 0){
                            EpisodesDetailsView(relatedHeight: $relatedHeight, moreDetailsHeight: $moreDetailsHeight, currentElement: currentElement)

                            if(relatedHeight == 1.5){
                                episodesElement(episodesTitlesArray: episodesTitlesArray, numberOfEpisodes: currentElement.NumberOfEpisodes)

                                relatedElements(actors: actors, directorsArray: directorsArray)

                            } else if(moreDetailsHeight == 1.5){
                                moreDetailsElement(currentElement: currentElement, didYouKnowArray: didYouKnowArray, goofsArray: goofsArray, quotesArray: quotesArray, reviewsArray: reviewsArray, directors: directorsArray, starringActors: starringActors, supportingActors: supportingActors)
                            }


                        } else {
                            //If there aren't episodes to display I just show the two tabs Related and MoreDetails
                            RelatedDetailsSelection(relatedHeight: $relatedHeight, moreDetailsHeight: $moreDetailsHeight)

                            if(relatedHeight == 1.5){
                                relatedElements(actors: actors, directorsArray: directorsArray)

                            } else if(moreDetailsHeight == 1.5){
                                moreDetailsElement(currentElement: currentElement, didYouKnowArray: didYouKnowArray, goofsArray: goofsArray, quotesArray: quotesArray, reviewsArray: reviewsArray, directors: directorsArray, starringActors: starringActors, supportingActors: supportingActors)
                            }

                        }



                        Rectangle()
                            .fill()
                            .opacity(0.001)
                            .frame(width: screenWidth, height: screenHeight/12)

                    }
                }
                //END OF SCROLLVIEW
                

                
                
            }
            .onAppear(perform: {
                
                myModelClassInstance.currentElement = currentElement
                
                if(currentElement.AudioLanguages != "Empty"){
                    audioLanguages = currentElement.AudioLanguages.components(separatedBy: ", ")
                }
                if(currentElement.SubtitleLanguages != "Empty"){
                    subtitlesLanguages = currentElement.SubtitleLanguages.components(separatedBy: ", ")
                }
                
                
                
                if(currentElement.RentPrice != "Empty"){
                    orangeRent = true
                } else {
                    if(currentElement.BuyPrice != "Empty"){
                        orangeBuy = true
                    }
                }
                
                if(currentElement.Actors != "Empty"){
                    actors = currentElement.Actors.components(separatedBy: ", ")
                    for index in 0..<actors.count{
                        if(index == 0){
                            starringActors = actors[index]
                        } else if(index < 3 && index != 0){
                            starringActors.append(", \(actors[index])")
                        } else if(index == 4){
                            supportingActors = actors[index]
                        } else {
                            supportingActors.append(", \(actors[index])")
                        }
                    }
                }

                
                if(currentElement.DidYouKnow != "Empty"){
                    didYouKnowArray = currentElement.DidYouKnow.components(separatedBy: " (-) ")
                }
                
                if(currentElement.Director != "Empty"){
                    directorsArray = currentElement.Director.components(separatedBy: ", ")
                }
                
                if(currentElement.Goofs != "Empty"){
                    goofsArray = currentElement.Goofs.components(separatedBy: " (-) ")
                }
                
                if(currentElement.Quotes != "Empty"){
                    quotesArray = currentElement.Quotes.components(separatedBy: " (-) ")
                }
                
                if(currentElement.CustomerReviews != "Empty"){
                    reviewsArray = currentElement.CustomerReviews.components(separatedBy: " (-) ")
                }
                
                if(currentElement.EpisodesTitles != "Empty"){
                    episodesTitlesArray = currentElement.EpisodesTitles.components(separatedBy: " (-) ")
                }
                
                //If the element I am displaying has more than one series in the database or in general is planned to have more than one season then I search through all of the elements in the database. If i find the same tag, I append the number of the series of the element that matches the tag to the array "seriesNumbers". Calling .count on seriesNumbers gives me the number of series for that tag stored in the database. Furthemore I check wether I have more than 0 elements in the "seriesNumbers" array, if I do I proceed to sort them so that I can better display them in the season picker
                if(currentElement.HasSeries == "1"){
                    for movie in myModelClassInstance.myMovies{
                        if(movie.Tag == currentElement.Tag){
                            myModelClassInstance.seriesNumbersAndId.append(SeriesNumbersAndId(seriesNumbers: movie.SeriesNumber, seriesId: movie.Identifier))
                        }
                    }
                    if(myModelClassInstance.seriesNumbersAndId.count != 0){
                        myModelClassInstance.seriesNumbersAndId.sort{ $0.seriesNumbers < $1.seriesNumbers}
                    }
                }
                
            })
            .preferredColorScheme(.dark)
            //When I dismiss the view I simply empty the array that holds all of the seriesNumbers of a particular tag, but I do that only if there are actually elements
            .onDisappear(perform: {
                if(myModelClassInstance.seriesNumbersAndId.count != 0){
                    myModelClassInstance.seriesNumbersAndId.removeAll()
                }
            })
        
    }

    //ON DISAPPEAR EMPTY THE ARRAY THAT HOLDS ALL OF THE MOVIES AND THE FEATURED ONES, OTHERWISE IT WILL QUERY THE DATABASE AGAIN
}


struct primeWritingButtons: View{
    
    var currentElement: Movie
    
    var body: some View{
        Text("prime \n\(Text("Watch for 0.00 with Prime").foregroundColor(.white).font(.system(size: 13)))")
            .foregroundColor(.blue)
            .font(.system(size: 20))
            .padding(.horizontal, 30)
        Button(action: {
            
        }){
            ZStack{
                Rectangle()
                    .fill(.orange)
                    .frame(width: screenWidth*0.85, height: screenHeight/20)
                    .cornerRadius(5)
                    .padding(.horizontal, 30)
                Text("Watch with Prime\nStart your 30-day free trial")
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
            }
        }
        if(currentElement.RentPrice != "Empty"){
            Button(action: {
                
            }){
                ZStack{
                    Rectangle()
                        .fill(Color(.systemGray2))
                        .frame(width: screenWidth*0.85, height: screenHeight/20)
                        .cornerRadius(5)
                        .padding(.horizontal, 30)
                    if(currentElement.IsUHD == "1"){
                        Text("Rent movie UHD €\(currentElement.RentPrice)")
                            .foregroundColor(.white)
                    } else {
                        Text("Rent movie SD €\(currentElement.RentPrice)")
                            .foregroundColor(.white)
                    }
                }
            }
        }
        if(currentElement.BuyPrice != "Empty"){
            Button(action: {
                
            }){
                ZStack{
                    Rectangle()
                        .fill(Color(.systemGray2))
                        .frame(width: screenWidth*0.85, height: screenHeight/20)
                        .cornerRadius(5)
                        .padding(.horizontal, 30)
                    if(currentElement.IsUHD == "1"){
                        Text("Buy movie UHD €\(currentElement.BuyPrice)")
                            .foregroundColor(.white)
                    } else {
                        Text("Buy movie SD €\(currentElement.BuyPrice)")
                            .foregroundColor(.white)
                    }
                }
            }
        }
        if(currentElement.MoreBuyOptions == "1"){
            Button(action: {
                
            }){
                ZStack{
                    Rectangle()
                        .fill(Color(.systemGray2))
                        .frame(width: screenWidth*0.85, height: screenHeight/20)
                        .cornerRadius(5)
                        .padding(.horizontal, 30)
                        Text("More purchase options")
                            .foregroundColor(.white)
                }
            }
        }
        
        
    }
}


struct OrangeRentButtons: View{
    
    var currentElement: Movie
    
    var body: some View{
        Button(action: {
            
        }){
            ZStack{
                Rectangle()
                    .fill(.orange)
                    .frame(width: screenWidth*0.85, height: screenHeight/20)
                    .cornerRadius(5)
                    .padding(.horizontal, 30)
                if(currentElement.IsUHD == "1"){
                    Text("Rent movie UHD €\(currentElement.RentPrice)")
                        .foregroundColor(.black)
                } else {
                    Text("Rent movie SD €\(currentElement.RentPrice)")
                        .foregroundColor(.black)
                }
            }
        }
        if(currentElement.BuyPrice != "Empty"){
            Button(action: {
                
            }){
                ZStack{
                    Rectangle()
                        .fill(Color(.systemGray2))
                        .frame(width: screenWidth*0.85, height: screenHeight/20)
                        .cornerRadius(5)
                        .padding(.horizontal, 30)
                    if(currentElement.IsUHD == "1"){
                        Text("Buy movie UHD €\(currentElement.BuyPrice)")
                            .foregroundColor(.white)
                    } else {
                        Text("Buy movie SD €\(currentElement.BuyPrice)")
                            .foregroundColor(.white)
                    }
                }
            }
        }
        if(currentElement.MoreBuyOptions == "1"){
            Button(action: {
                
            }){
                ZStack{
                    Rectangle()
                        .fill(Color(.systemGray2))
                        .frame(width: screenWidth*0.85, height: screenHeight/20)
                        .cornerRadius(5)
                        .padding(.horizontal, 30)
                        Text("More purchase options")
                            .foregroundColor(.white)
                }
            }
        }
        
    }
}

struct OrangeBuyButtons: View{
    var currentElement: Movie
    
    var body: some View{
        Button(action: {
            
        }){
            ZStack{
                Rectangle()
                    .fill(.orange)
                    .frame(width: screenWidth*0.85, height: screenHeight/20)
                    .cornerRadius(5)
                    .padding(.horizontal, 30)
                if(currentElement.IsUHD == "1"){
                    Text("Buy movie UHD €\(currentElement.BuyPrice)")
                        .foregroundColor(.black)
                } else {
                    Text("Buy movie SD €\(currentElement.BuyPrice)")
                        .foregroundColor(.black)
                }
            }
        }
        if(currentElement.MoreBuyOptions == "1"){
            Button(action: {
                
            }){
                ZStack{
                    Rectangle()
                        .fill(Color(.systemGray2))
                        .frame(width: screenWidth*0.85, height: screenHeight/20)
                        .cornerRadius(5)
                        .padding(.horizontal, 30)
                        Text("More purchase options")
                            .foregroundColor(.white)
                }
            }
        }
    }
}

struct  HStackOptions:View {
    
    @EnvironmentObject var myModelClassInstance: MyModelClass

    var currentElement: Movie

    
    var body: some View{
        HStack(spacing: 30){
            Spacer()
            if(currentElement.TrailerLink != "Empty"){
                Button(action: {
                    myModelClassInstance.showTrailer = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.001){
                        myModelClassInstance.offsetForDismiss = 0
                    }
                }){
                    VStack(spacing: 5){
                        Image(systemName: "play")
                            .font(.system(size: 30))
                            .foregroundColor(Color(.systemGray))
                        Text("Trailer")
                            .font(.system(size: 15))
                            .foregroundColor(Color(.systemGray))
                    }
                }
            }
            Button(action: {
                
            }){
                VStack(spacing: 5){
                    Image(systemName: "plus")
                        .font(.system(size: 30))
                        .foregroundColor(Color(.systemGray))
                    Text("Watchlist")
                        .font(.system(size: 15))
                        .foregroundColor(Color(.systemGray))
                }
            }
            Button(action: {
                
            }){
                VStack(){
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 30))
                        .foregroundColor(Color(.systemGray))
                    Text("Share")
                        .font(.system(size: 15))
                        .foregroundColor(Color(.systemGray))
                }
            }
            Spacer()

        }
        .padding(.top, 4)
    }

}


struct PlotAndDetails: View{
    @EnvironmentObject var myModelClassInstance: MyModelClass
    
    var currentElement: Movie
    var subtitlesLanguages: [String]
    var audioLanguages: [String]
    
    @State private var lineLimitPlot: Int = 3
    
    var body: some View{
        VStack(alignment: .leading, spacing: 5){
            Text(currentElement.Plot)
                .font(.system(size: 17))
                .padding(.horizontal, 30)
                .lineLimit(lineLimitPlot)
                .onTapGesture(perform: {
                    if(lineLimitPlot == 3){
                        lineLimitPlot = 50
                    } else {
                        lineLimitPlot = 3
                    }
                })
            if(currentElement.ElementType == "Anime" && currentElement.NumberOfEpisodes != 0){
                Text("Anime)")
                    .padding(.horizontal, 30)
                    .foregroundColor(Color(.systemGray))
            } else if(currentElement.ElementType == "Tv" ){
                Text("IMDb \(currentElement.RatingImdb)")
                    .padding(.horizontal, 30)
                    .foregroundColor(Color(.systemGray))
            } else if(currentElement.ElementType == "Movie"){
                Text("IMDb \(currentElement.RatingImdb)")
                    .padding(.horizontal, 30)
                    .foregroundColor(Color(.systemGray))
            } else {
                Text("IMDb \(currentElement.RatingImdb) Anime")
                    .padding(.horizontal, 30)
                    .foregroundColor(Color(.systemGray))
            }
            HStack{
                Text("\(currentElement.Year)")
                    .foregroundColor(Color(.systemGray))
                if(currentElement.NumberOfEpisodes != 0){
                    Text("\(currentElement.NumberOfEpisodes) episodes")
                        .foregroundColor(Color(.systemGray))
                }else{
                    Text("\(currentElement.Runtime)")
                        .foregroundColor(Color(.systemGray))
                }
                Text("\(currentElement.Pegi)")
                    .font(.system(size: 14))
                    .padding(2)
                    .background(Rectangle().stroke())
                    .foregroundColor(Color(.systemGray))
                if(currentElement.IsUHD == "1"){
                    Text("UHD")
                        .font(.system(size: 12))
                        .fontWeight(.bold)
                        .padding(2)
                        .background(Rectangle().stroke())
                        .foregroundColor(Color(.systemGray))
                }
                if(currentElement.AudioLanguages.contains("Audio Description")){
                    Text("AD)))")
                        .font(.system(size: 12))
                        .fontWeight(.bold)
                        .padding(2)
                        .background(Rectangle().stroke())
                        .foregroundColor(Color(.systemGray))
                }
                if(currentElement.SubtitleLanguages != "Empty"){
                    //TO DO: ADD the small icon for subtitles, still need to find it
                }

            }
            .padding(.horizontal, 30)
            Text("Languages: Audio (\(audioLanguages.count)), Subtitles (\(subtitlesLanguages.count)) \(Image(systemName: "chevron.down"))")
                .padding(.horizontal, 30)
                .foregroundColor(Color(.systemGray))
                .onTapGesture(perform: {
                    myModelClassInstance.showLanguages = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.001){
                        myModelClassInstance.offsetForDismiss = 0
                    }
                })
            // TO DO: Add the small arrow to show more about subtitles, still need to find it
            
            Rectangle()
                .fill(Color(.systemGray3))
                .frame(width: screenWidth*0.85, height: 0.5)
                .padding(.horizontal, 30)
                .padding(.top)
                .padding(.bottom)
            Text("By ordering or viewing, you agree to our Terms. Sold by Amazon Digital UK Ltd.")
                .foregroundColor(Color(.systemGray))
                .padding(.horizontal, 30)
                .onAppear(perform: {
                    print("HEY")
                })
                
        }
    }
}

struct RelatedDetailsSelection: View{
    
    @Binding var relatedHeight: CGFloat
    @Binding var moreDetailsHeight: CGFloat
    
    
    var body: some View{
        HStack{
            Spacer()
            Text("Related")
                .fontWeight(.bold)
                .onTapGesture(perform: {
                    if(relatedHeight != 1.5){
                        relatedHeight = 1.5
                        moreDetailsHeight = 0
                    }
                })
            Spacer()
            Text("More Details")
                .fontWeight(.bold)
                .onTapGesture(perform: {
                    if(moreDetailsHeight != 1.5){
                        moreDetailsHeight = 1.5
                        relatedHeight = 0
                    }
                })
            Spacer()
        }
        .padding(.top, 5)
        .padding(.horizontal, 30)
        HStack(spacing: 0){
            Rectangle()
                .fill(.white)
                .frame(width: 0.5*screenWidth, height: 0.5 + relatedHeight)
            Rectangle()
                .fill(.white)
                .frame(width: 0.5*screenWidth, height: 0.5 + moreDetailsHeight)
            
        }
        
    }
}

struct EpisodesDetailsView: View {
    @Binding var relatedHeight: CGFloat
    @Binding var moreDetailsHeight: CGFloat
    
    var currentElement: Movie
    
    var body: some View{
        HStack{
            Spacer()
            Text("Episodes (\(currentElement.NumberOfEpisodes))")
                .fontWeight(.bold)
                .onTapGesture(perform: {
                    if(relatedHeight != 1.5){
                        relatedHeight = 1.5
                        moreDetailsHeight = 0
                    }
                })
            Spacer()
            Text("More Details")
                .fontWeight(.bold)
                .onTapGesture(perform: {
                    if(moreDetailsHeight != 1.5){
                        moreDetailsHeight = 1.5
                        relatedHeight = 0
                    }
                })
            Spacer()
        }
        .padding(.top, 5)
        .padding(.horizontal, 30)
        HStack(spacing: 0){
            Rectangle()
                .fill(.white)
                .frame(width: 0.5*screenWidth, height: 0.5 + relatedHeight)
            Rectangle()
                .fill(.white)
                .frame(width: 0.5*screenWidth, height: 0.5 + moreDetailsHeight)
            
        }
        
    }
    
}

struct relatedElements: View{
    
    var actors: [String]
    var directorsArray: [String]
    
    var body: some View{
        VStack(alignment: .leading){
            Text("Customers also watched")
                .fontWeight(.bold)
                .padding(.horizontal, 30)
            ZStack{
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 10){
                        ForEach(0..<10, id: \.self){index in
                            ZStack{
                                Rectangle()
                                    .fill(Color(.systemGray4))
                                    .frame(width: screenWidth*0.38, height: screenHeight*0.09)
                                    .cornerRadius(5)
                                Text("WIP")
                                    .foregroundColor(Color(.systemGray))
                            }
                        }
                    }
                    .offset(x: 30)
                }
            }
            .frame(width: screenWidth, height: screenHeight*0.09)
        }
        .padding(.top, 20)
        
        VStack(alignment: .leading){
            VStack(alignment: .leading, spacing: 0){
                Text("Cast & Crew")
                    .fontWeight(.bold)
                HStack{
                    Text("Details from")
                        .foregroundColor(Color(.systemGray))
                    Text("IMDb")
                        .fontWeight(.bold)
                        .padding(2)
                        .background(Rectangle().stroke())
                        .foregroundColor(Color(.systemGray))
                }
                    
            }
            .padding(.horizontal, 30)
            
            if(actors.count == 0){
                Text("There are no informations about the cast & crew")
                    .padding(.horizontal, 30)
                    .foregroundColor(Color(.systemGray))
            }else{
                ZStack{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 10){
                            ForEach(0..<actors.count, id: \.self){index in
                                Button(action: {
                                    
                                }) {
                                    ZStack{
                                        Rectangle()
                                            .fill(Color(.systemGray4))
                                            .frame(width: screenWidth*0.28, height: screenHeight*0.17)
                                            .cornerRadius(5)
                                        VStack{
                                            Spacer()
                                            Text("\(actors[index])")
                                                .foregroundColor(Color(.systemGray))
                                                .multilineTextAlignment(.center)
                                        }
                                    }
                                    .frame(width: screenWidth*0.28, height: screenHeight*0.17)

                                }                              }
                            }
                            .offset(x: 30)
                    }
                }
                .frame(width: screenWidth, height: screenHeight*0.17)
            }
        }
        .padding(.top, 20)
        
        if(directorsArray.count != 0){
            VStack(alignment: .leading){
                ForEach(0..<directorsArray.count, id: \.self){index in
                    HStack(alignment: .top, spacing: 10){
                        Button(action: {
                            
                        }){
                            ZStack{
                                Rectangle()
                                    .fill(Color(.systemGray4))
                                    .frame(width: screenWidth*0.3, height: screenHeight*0.2)
                                    .cornerRadius(5)
                                VStack{
                                    Spacer()
                                    Text("\(directorsArray[index])")
                                        .foregroundColor(Color(.systemGray))
                                        .multilineTextAlignment(.center)
                                }
                            }
                            .frame(width: screenWidth*0.3, height: screenHeight*0.2)
                        }
                        VStack(alignment: .leading, spacing: 10){
                            Text("Director")
                            Text("Director bio WIP")
                                .foregroundColor(Color(.systemGray))
                        }
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 30)
                }
            }
        } else {
            VStack(alignment: .leading){
                Text("Director(s)")
                Text("There are currently no informations about the director(s)")
                    .foregroundColor(Color(.systemGray))
            }
            .padding(.top , 20)
            .padding(.horizontal, 30)
        }
    }
    
    
}

struct episodesElement: View{
    
    var episodesTitlesArray: [String]
    var numberOfEpisodes: Int
    
    var body: some View{
        if(episodesTitlesArray.count != 0){
            VStack{
                ForEach(0..<numberOfEpisodes, id: \.self){index in
                    Button(action: {
                        
                    }){
                        ZStack{
                            Rectangle()
                                .fill(Color(.systemGray3))
                                .frame(width: screenWidth, height: 50)
                                VStack{
                                    HStack{
                                        Text("Episode \(index)")
                                            .fontWeight(.bold)
                                        Spacer()
                                    }
                                    HStack{
                                        Text("\(episodesTitlesArray[index])")
                                            .lineLimit(1)
                                            .foregroundColor(Color(.systemGray))
                                        Spacer()
                                    }
                                }
                                .padding(.horizontal, 50)
                        }
                        .frame(width: screenWidth, height: 50)
                    }
                }
            }
        } else {
            VStack{
                ForEach(0..<numberOfEpisodes, id: \.self){index in
                    Button(action: {
                        
                    }){
                        ZStack{
                            Rectangle()
                                .fill()
                            VStack(alignment: .leading){
                                Text("Episode \(index)")
                                    .fontWeight(.bold)
                            }
                            .padding(.horizontal, 30)
                        }
                        .frame(width: screenWidth, height: 50)
                    }
                }
            }
        }
    }
}

struct moreDetailsElement: View {
    
    
    
    var currentElement: Movie
    @State var lineLimitVariable: Int = 3
    
    var didYouKnowArray: [String]
    var goofsArray: [String]
    var quotesArray: [String]
    var reviewsArray: [String]
    var directors: [String]
    var starringActors: String
    var supportingActors: String
    
    var body: some View{
        VStack(alignment: .leading){
            VStack(alignment: .leading, spacing: 1){
                Text("Genre")
                    .fontWeight(.bold)
                if(currentElement.Genres != "NoGenre"){
                    Text("\(currentElement.Genres)")
                        .foregroundColor(Color(.systemGray))
                } else {
                    Text("There are no informations about the genre")
                        .foregroundColor(Color(.systemGray))
                }
            }
            .padding(.bottom, 3)
            
            VStack(alignment: .leading, spacing: 1){
                Text("Director")
                    .fontWeight(.bold)
                if(currentElement.Director != "Empty"){
                    Text("\(currentElement.Director)")
                        .foregroundColor(Color(.systemGray))
                } else {
                    Text("There are no informations about director(s)")
                        .foregroundColor(Color(.systemGray))
                }
            }
            .padding(.bottom, 3)
            
            VStack(alignment: .leading, spacing: 1){
                Text("Starring Actors")
                    .fontWeight(.bold)
                if(starringActors != ""){
                    Text("\(starringActors)")
                        .foregroundColor(Color(.systemGray))
                } else {
                    Text("There are no informations about starring actors")
                        .foregroundColor(Color(.systemGray))
                }
            }
            .padding(.bottom, 3)
            
            VStack(alignment: .leading, spacing: 1){
                Text("Supporting actors")
                    .fontWeight(.bold)
                if(supportingActors != ""){
                    Text("\(supportingActors)")
                        .foregroundColor(Color(.systemGray))
                } else {
                    Text("There are no informations about supporting actors")
                        .foregroundColor(Color(.systemGray))
                }
            }
            .padding(.bottom, 3)
            
            VStack(alignment: .leading, spacing: 1){
                Text("Studio")
                    .fontWeight(.bold)
                if(currentElement.Studio != "Empty"){
                    Text("\(currentElement.Studio)")
                        .foregroundColor(Color(.systemGray))
                } else {
                    Text("There are no information about the studio")
                        .foregroundColor(Color(.systemGray))
                }
            }
            .padding(.bottom, 3)
            
            VStack(alignment: .leading, spacing: 1){
                Text("Viewing rights")
                    .fontWeight(.bold)
                Text("For video purchases, watch as often as you want (except as described in the Prime Video Terms of Use). For video rentals, you have 30 days to start watching. Once started, you tipically have 48 hours to finish rentals (as shown on video detail pages). Videos can be watched while this device or other compatible devices are connected to the internet. If available, you may download the video. Additional restrictions apply. Please see the Prime Video Usage Rules for more information.")
                    .lineLimit(lineLimitVariable)
                    .foregroundColor(Color(.systemGray))
                    .onTapGesture(perform: {
                        if (lineLimitVariable == 3){
                            lineLimitVariable = 30
                        } else {
                            lineLimitVariable = 3
                        }
                    })
                if(lineLimitVariable == 30){
                    Text("Prime Video Terms of Use")
                        .foregroundColor(.blue)
                        .padding(.top, 10)
                    Text("Prime Video Usage Rules")
                        .foregroundColor(.blue)
                        .padding(.top, 10)
                }
            }
            .padding(.bottom, 3)
            
            Rectangle()
                .fill(Color(.systemGray3))
                .frame(width: screenWidth*0.85, height: 0.5)
                .padding(.top)
                .padding(.bottom)
            
            moreDetailsElementSecondHalf(didYouKnowArray: didYouKnowArray, goofsArray: goofsArray, quotesArray: quotesArray, reviewsArray: reviewsArray)
            
        }
        .padding(.top, 10)
        .padding(.horizontal, 30)

        
        
        
        
    }
    
    
}

struct moreDetailsElementSecondHalf: View{
    
    
    var didYouKnowArray: [String]
    var goofsArray: [String]
    var quotesArray: [String]
    var reviewsArray: [String]
    
    var body: some View{
        Text("Customer Reviews")
            .font(.system(size: 20))
            .fontWeight(.bold)
            .padding(.bottom, 3)
        if(reviewsArray.count != 0){
            VStack(alignment: .leading){
                ForEach(0..<reviewsArray.count, id: \.self){index in
                    Text("\(reviewsArray[index])")
                        .foregroundColor(Color(.systemGray))
                        .padding(.bottom, 20)
                }
            }
            .padding(.bottom, 40)
        } else {
            Text("We don't have any reviews.")
                .foregroundColor(Color(.systemGray))
                .padding(.bottom, 40)
        }
        
        
        
        if(didYouKnowArray.count != 0){
            Text("Did you know?")
                .font(.system(size: 20))
                .fontWeight(.bold)
                .padding(.bottom, 3)
            VStack(alignment: .leading){
                ForEach(0..<didYouKnowArray.count, id: \.self){index in
                    Text("\(didYouKnowArray[index])")
                        .foregroundColor(Color(.systemGray))
                        .padding(.bottom, 20)
                }
            }
            .padding(.bottom, 10)
        } else {
            
        }
        
//        Text("Did you know?")
//            .font(.system(size: 20))
//            .fontWeight(.bold)
//            .padding(.bottom, 3)
//            .padding(.top, 40)
//        if(didYouKnowArray.count != 0){
//            VStack(alignment: .leading){
//                ForEach(0..<didYouKnowArray.count, id: \.self){index in
//                    Text("\(didYouKnowArray[index])")
//                        .foregroundColor(Color(.systemGray))
//                        .padding(.bottom, 20)
//                }
//            }
//            .padding(.bottom, 10)
//        } else {
//            Text("There are currently no informations here.")
//                .foregroundColor(Color(.systemGray))
//                .padding(.bottom, 10)
//        }
        
        
        if(quotesArray.count != 0){
            Text("Quotes")
                .font(.system(size: 20))
                .fontWeight(.bold)
                .padding(.bottom, 3)
            VStack(alignment: .leading){
                ForEach(0..<quotesArray.count, id: \.self){index in
                    Text("\(quotesArray[index])")
                        .foregroundColor(Color(.systemGray))
                        .padding(.bottom, 20)
                }
            }
            .padding(.bottom, 10)
        } else {
            
        }
        
//        Text("Quotes")
//            .font(.system(size: 20))
//            .fontWeight(.bold)
//            .padding(.bottom, 3)
//            .padding(.top, 10)
//        if(quotesArray.count != 0){
//            VStack(alignment: .leading){
//                ForEach(0..<quotesArray.count, id: \.self){index in
//                    Text("\(quotesArray[index])")
//                        .foregroundColor(Color(.systemGray))
//                        .padding(.bottom, 20)
//                }
//            }
//        } else {
//            Text("There are currently no quotes.")
//                .foregroundColor(Color(.systemGray))
//        }
        

        
        if(goofsArray.count != 0){
            Text("Goofs")
                .font(.system(size: 20))
                .fontWeight(.bold)
                .padding(.bottom, 3)
            VStack(alignment: .leading){
                ForEach(0..<goofsArray.count, id: \.self){index in
                    Text("\(goofsArray[index])")
                        .foregroundColor(Color(.systemGray))
                        .padding(.bottom, 20)
                }
            }
        } else {
            
        }
        
//        Text("Goofs")
//            .font(.system(size: 20))
//            .fontWeight(.bold)
//            .padding(.bottom, 3)
//        if(goofsArray.count != 0){
//            VStack(alignment: .leading){
//                ForEach(0..<goofsArray.count, id: \.self){index in
//                    Text("\(goofsArray[index])")
//                        .foregroundColor(Color(.systemGray))
//                        .padding(.bottom, 20)
//                }
//            }
//        } else {
//            Text("There are currently no goofs")
//                .foregroundColor(Color(.systemGray))
//        }
        
        
    }
    
}



//
struct DetailsView_Previews: PreviewProvider {


    static var previews: some View {
        TabSelection()
            .environmentObject(MyModelClass())
    }
}
