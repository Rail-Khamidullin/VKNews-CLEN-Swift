//
//  NewsfeedInteractor.swift
//  VKNews
//
//  Created by Rail on 03.11.2022.
//  Copyright (c) 2022 Хамидуллин Раиль. All rights reserved.
//

import UIKit

protocol NewsfeedBusinessLogic {
    func makeRequest(request: Newsfeed.Model.Request.RequestType)
}

//   Зддесь проходят сетевые запросы, обращение к базам данных
class NewsfeedInteractor: NewsfeedBusinessLogic {
    
    var presenter: NewsfeedPresentationLogic?
    var service: NewsfeedService?
    //    Достаём экземпляр структуры с сетевым запрсом
    private var dataFetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())
    
    func makeRequest(request: Newsfeed.Model.Request.RequestType) {
        if service == nil {
            service = NewsfeedService()
        }
        
        switch request {
        ///      Мы попадаем в метод getNewsFeed из  viewDidLoad контроллера NewsfeedViewController (здесь мы будем делать сетевой запрос)
        //        Метод getNewsFeed показывает нам все данные, которые приходят из интернета в нужном нам формате, ассоциативное значение (FeedResponse)
        case .getNewsFeed:
            dataFetcher.getFeed { [weak self] (feedResponse) in
                
                //                Проверяем на наличие данных
                guard let feedResponse = feedResponse else { return }
                //                Передаём полученны данные в презентер
                self?.presenter?.presentData(response: Newsfeed.Model.Response.ResponseType.presentNewsfeed(feed: feedResponse))
            }
        }
    }
}
