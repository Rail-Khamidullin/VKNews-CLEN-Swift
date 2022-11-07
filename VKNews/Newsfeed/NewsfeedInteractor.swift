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

class NewsfeedInteractor: NewsfeedBusinessLogic {

  var presenter: NewsfeedPresentationLogic?
  var service: NewsfeedService?
  
  func makeRequest(request: Newsfeed.Model.Request.RequestType) {
    if service == nil {
      service = NewsfeedService()
    }
    
    switch request {
    
    case .some:
        print(". some Interactor")
//       Мы попадаем в метод getFeed (здесь мы будем делать сетевой запрос)
    case .getFeed:
        print(". getFeed Interactor")
//        Данные которые мы получим будем передавать в метод ниже 
        presenter?.presentData(response: .presentNewsfeed )
    }
  }
  
}
