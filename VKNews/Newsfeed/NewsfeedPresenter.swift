//
//  NewsfeedPresenter.swift
//  VKNews
//
//  Created by Rail on 03.11.2022.
//  Copyright (c) 2022 Хамидуллин Раиль. All rights reserved.
//

import UIKit

protocol NewsfeedPresentationLogic {
    func presentData(response: Newsfeed.Model.Response.ResponseType)
}

class NewsfeedPresenter: NewsfeedPresentationLogic {
    weak var viewController: NewsfeedDisplayLogic?
    
    func presentData(response: Newsfeed.Model.Response.ResponseType) {
        //  Посколько мы из Интректора вызвали request.getNewsFeed попадаем сюда, то
        switch response {
        
        //        Данные которые получили и обработали (свернули в модель для отображения нужного нам формата) передаём в файл viewController
        case .presentNewsfeed(feed: let feed):
            
            //        Полученные данные из сети вставляем в наш конвертер
            let cells = feed.items.map { (feedItem) in
                cellViewModel(from: feedItem)
            }
            //        Вставляем в структуру данных ячейки сконвертируемый формат полученных данных из сети
            let feedViewModel = FeedViewModel.init(cells: cells)
            //        Передаём в отображение нашу модель
            viewController?.displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData.displayNewsfeed(feedViewModel: feedViewModel))
        }
    }
    
    //        Конвертируем формат FeedResponse.items в формат FeedCellViewModel.cells
    private func cellViewModel( from feedItem: FeedItem) -> FeedViewModel.Cell {
        
        //        Возвращаем нашу структуру с данными для ячейки
        return FeedViewModel.Cell.init(iconUrlString: "",
                                       name: "Future name",
                                       date: "Future date",
                                       text: feedItem.text,
                                       likes: String(feedItem.likes?.count ?? 0),
                                       comments: String(feedItem.comments?.count ?? 0),
                                       shares: String(feedItem.reposts?.count ?? 0),
                                       views: String(feedItem.views?.count ?? 0))
        
    }
}
