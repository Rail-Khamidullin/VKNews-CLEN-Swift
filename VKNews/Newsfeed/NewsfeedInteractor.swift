//
//  NewsfeedInteractor.swift
//  VKNews
//
//  Created by Rail on 03.11.2022.
//  Copyright (c) 2022 Хамидуллин Раиль. All rights reserved.
//

import UIKit

//   Метод через который общается контроллер с интерактором зависит от абстракции
protocol NewsfeedBusinessLogic {
    func makeRequest(request: Newsfeed.Model.Request.RequestType)
}

//   Зддесь проходят сетевые запросы, обращение к базам данных
class NewsfeedInteractor: NewsfeedBusinessLogic {
    
    //    Объект протокола NewsfeedPresentationLogic для получения данных из NewsfeedPresenter
    var presenter: NewsfeedPresentationLogic?
    //    Объект с запросом данных
    var service: NewsfeedService?
    
    //    Метод через который общается контроллер с интерактором
    func makeRequest(request: Newsfeed.Model.Request.RequestType) {
        if service == nil {
            service = NewsfeedService()
        }
        
        switch request {
        case .getNewsFeed:
            //            Делаем запрос на полученние данных согласно структуре FeedResponse
            service?.getFeed(completion: { [weak self] (reveledPostIds, feedResponse) in
                //                Передаём данные в презентер
                self?.presenter?.presentData(response: Newsfeed.Model.Response.ResponseType.presentNewsfeed(feed: feedResponse, reveledPostIds: reveledPostIds))
            })
        case .getUser:
            service?.getUser(completion: { [weak self] (user) in
                //                Передаём данные в презентер
                self?.presenter?.presentData(response: Newsfeed.Model.Response.ResponseType.presentUserInfo(user: user))
            })
        case .revealPostIds(postId: let postId):
            service?.revealPostIds(forPostId: postId, completion: { [weak self] (reveledPostIds, feed) in
                //                Передаём данные в презентер
                self?.presenter?.presentData(response: Newsfeed.Model.Response.ResponseType.presentNewsfeed(feed: feed, reveledPostIds: reveledPostIds))
            })
        case .getNextBatch:
            //            Передаём сигнал для отображения колонтитула в презентер
            self.presenter?.presentData(response: Newsfeed.Model.Response.ResponseType.presentFooterLoader)
            service?.getNewsBatch(completion: { [weak self] (reveledPostIds, feedResponse) in
                //                Передаём данные в презентер
                self?.presenter?.presentData(response: Newsfeed.Model.Response.ResponseType.presentNewsfeed(feed: feedResponse, reveledPostIds: reveledPostIds))
            })
        }
    }
}
