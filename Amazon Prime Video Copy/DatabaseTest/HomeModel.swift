//
//  HomeModel.swift
//  Amazon Prime Video Copy
//
//  Created by Salvatore Manna on 09/12/21.
//

import UIKit
import SwiftUI

var InViewDarkGray = Color(red: 0.124, green: 0.177, blue: 0.23)

var screenWidth = UIScreen.main.bounds.size.width
var screenHeight = UIScreen.main.bounds.size.height

protocol HomeModelDelegate {
    
    func itemsDownloaded(movies: [Movie])
}

class HomeModel: NSObject {

    var delegate: HomeModelDelegate?
    
    func getItems(){
        
        
        //Hit the web service
        let serviceUrl = "https://amazonprimevideodatabase.000webhostapp.com/service.php"
        let url = URL(string: serviceUrl)
        
        if let url = url {
            //If I actually retrieve a url I create a url session
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url, completionHandler: {(data, response, error) in
                if error == nil {
                    //Succeded
                    
                    //I call the parseJson function to actually parse the data
                    self.parseJson(data: data!)
                } else {
                    //An error occurred
                }
                
            })
            
            task.resume()
        }

        
        
        
    }
    
    func parseJson(data: Data){
        //Parsing the data
        
        //Declaring an empty array to hold the values from the 
        var movieArray = [Movie]()
        
        do{
            //Here I parse data as a Json object
            let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as! [Any]
            
            //here I loop through each result of the json array
            for jsonResult in jsonArray {
                //Here I cast json results as a dictionary
                let jsonDict = jsonResult as! [String:String]
                
                //Here I force unwrap the values in jsonDict, the thing to do would be to check each and every value before assignining them because if they are NIL the code might break
                
                let mov = Movie(Identifier: Int(jsonDict["Identifier"]!)!,
                                Title: jsonDict["Title"]!,
                                Plot: jsonDict["Plot"]!,
                                Year: jsonDict["Year"]!,
                                Runtime: jsonDict["Runtime"]!,
                                RatingImdb: jsonDict["RatingImdb"]!,
                                MoviePoster: jsonDict["MoviePoster"]!,
                                MovieThumbnail: jsonDict["MovieThumbnail"]!,
                                IsFeatured: jsonDict["IsFeatured"]!,
                                ElementType: jsonDict["Type"]!,
                                IsPrime: jsonDict["IsPrime"]!,
                                NumberOfEpisodes: Int(jsonDict["NumberOfEpisodes"]!)!,
                                Genres: jsonDict["Genres"]!,
                                RentPrice: jsonDict["RentPrice"]!,
                                BuyPrice: jsonDict["BuyPrice"]!,
                                Pegi: jsonDict["Pegi"]!,
                                Actors: jsonDict["Actors"]!,
                                Director: jsonDict["Director"]!,
                                AudioLanguages: jsonDict["AudioLanguages"]!,
                                SubtitleLanguages: jsonDict["SubtitleLanguages"]!,
                                IsUHD: jsonDict["IsUHD"]!,
                                MoreBuyOptions: jsonDict["MoreBuyOptions"]!,
                                TrailerLink: jsonDict["TrailerLink"]!,
                                Studio: jsonDict["Studio"]!,
                                CustomerReviews: jsonDict["CustomerReviews"]!,
                                DidYouKnow: jsonDict["DidYouKnow"]!,
                                Quotes: jsonDict["Quotes"]!,
                                Goofs: jsonDict["Goofs"]!,
                                HasSeries: jsonDict["HasSeries"]!,
                                HasMovieThumbnail: jsonDict["HasMovieThumbnail"]!,
                                HasMoviePoster: jsonDict["HasMoviePoster"]!,
                                Tag: jsonDict["Tag"]!,
                                SeriesNumber: Int(jsonDict["SeriesNumber"]!)!,
                                EpisodesTitles: jsonDict["EpisodesTitles"]!)
                
                //I then append the mov variable that holds the results of the json fetch inside of the array I declared up
                movieArray.append(mov)
            }
            
            //If there is someone who is declared as a HomeModelDelegate and conforms to that protocolo, then it means there is an instance of delegate, if there is an instance of delegate then call this function
            delegate?.itemsDownloaded(movies: movieArray)
            
        } catch {
            print("There was an error")
        }
        
    }
    
    
}

struct SeriesNumbersAndId {
    var seriesNumbers: Int
    var seriesId: Int
}

final class MyModelClass: ObservableObject {
    var myMovies: [Movie]
    var isFirstTime: Bool
    var toSortSeries: Bool
    var seriesNumbersAndId: [SeriesNumbersAndId]
    var currentElement: Movie
    var featuredIndexes: [Int]
    var onOpening: Bool
    var showNewPage: Bool
    
    
    init(){
        myMovies = []
        isFirstTime = true
        toSortSeries = false
        seriesNumbersAndId = []
        currentElement = Movie()
        featuredIndexes = []
        onOpening = true
        tagForTabView = 0
        showNewPage = false
    }
    
//    @Published var myMovies: [Movie] = []
    @Published var showDetailsFullPage: String? = nil
    @Published var showDetails: Bool = false
    @Published var numberOfSeries: Int = 0
    @Published var showLanguages: Bool = false
    @Published var showTrailer: Bool = false
    @Published var offsetForDismiss: CGFloat = screenHeight
    @Published var offsetForOpacity: CGFloat = 0.6
    @Published var dismissValue = false

    
    
    var tagForTabView: Int{
        didSet {
                    if tagForTabView == 0 {
                        print("Tapped on the bar and did an action")
                        dismissValue = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            self.dismissValue = false
                        }
                    }
//                    objectWillChange.send(self)
                }
    }
    
    
    
}

