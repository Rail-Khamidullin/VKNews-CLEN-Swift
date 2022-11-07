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
//  Посколько мы из Интректора вызвали request.getFeed попадаем сюда, то
    switch response {
    case .presentNewsfeed:
        print(" . presentNewsfeed Presenter")
//        Данные которые получили и обработали (свернули в модель для отображения) передаём в файл viewController
        viewController?.displayData(viewModel: .displayNewsfeed)
    case .some:
        print(". some Presenter")
    }
  }
  
}
