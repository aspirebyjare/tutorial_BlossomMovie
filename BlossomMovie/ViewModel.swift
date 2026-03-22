//
//  ViewModel.swift
//  BlossomMovie
//
//  Created by Jared Smith on 3/21/26.
//

import Foundation

@Observable
class ViewModel {
    enum FetchStatus{
        case notStarted
        case fetching
        case success
        case failed(underlyingError: Error)
    }
    private(set) var homeStatus: FetchStatus = .notStarted
    private(set) var videoIdStatus: FetchStatus = .notStarted
    private(set) var upcomingStatus: FetchStatus = .notStarted
    
    private let dataFetcher = DataFetcher()
    var trendingMovies: [Title] = []
    var trendingTV: [Title] = []
    var topRatedMovies: [Title] = []
    var topRatedTV: [Title] = []
    var upcomingMovies: [Title] = []
    var heroTitle = Title.previewTitles[0]
    var videoId = ""
    
    func getTitles() async {
        homeStatus = .fetching
        //this if statement ensures that we only make the api calls if we don't have them
        // in a different kind of app, we may actually want more recurring calls for data,
        // in this case it is unlikely that the data being fetched will change between opening
        // the app and closing it
        if trendingMovies.isEmpty{
            
            do{
                async let tMovies = dataFetcher.fetchTitles(for: "movie", by: "trending")
                async let tTV = dataFetcher.fetchTitles(for: "tv", by: "trending")
                async let tRMovies = dataFetcher.fetchTitles(for: "movie", by: "top_rated")
                async let tRTV =  dataFetcher.fetchTitles(for: "tv", by: "top_rated")
                
                
                trendingMovies = try await tMovies
                trendingTV = try await tTV
                topRatedMovies = try await tRMovies
                topRatedTV = try await tRTV
                
                if let title = trendingMovies.randomElement(){
                    heroTitle = title
                }
                
                homeStatus = .success
            } catch {
                print(error)
                homeStatus = .failed(underlyingError: error)
            }
        } else {
            homeStatus = .success
        }
    }
    
    func getVideoId(for title: String) async {
        videoIdStatus = .fetching
        
        do{
            videoId = try await dataFetcher.fetchVideoId(for: title)
            videoIdStatus = .success
        }catch{
            print(error)
            videoIdStatus = .failed(underlyingError: error)
        }
    }
    
    func getUpcomingMovies() async {
        upcomingStatus = .fetching
        
        do{
            upcomingMovies = try await dataFetcher.fetchTitles(for: "movie", by: "upcoming")
            upcomingStatus = .success
        }catch{
            print(error)
            upcomingStatus = .failed(underlyingError:  error)
        }
    }
}
