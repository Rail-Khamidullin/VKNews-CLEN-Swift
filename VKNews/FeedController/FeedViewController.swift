//
//  FeedViewController.swift
//  VKNews
//
//  Created by Rail on 01.11.2022.
//  Copyright © 2022 Хамидуллин Раиль. All rights reserved.
//

import UIKit

//   Контроллер с отображением новостей
class FeedViewController: UIViewController {
    
    //    Установим внешнюю зависимость, таким образом класс будет зависеть от Абстракции (protocol)
    private let networkDataFetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBlue
        
        //        Обращаемся к методу с декодироваинем данных, проверяем правильность работы
        networkDataFetcher.getFeed { (feedResponse) in
            
            guard let feedResponse = feedResponse else { return }
            
            feedResponse.items.map { (feedItem) in
                print(feedItem.views)
            }
        }
    }
}
