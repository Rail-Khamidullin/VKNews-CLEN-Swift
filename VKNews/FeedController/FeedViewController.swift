//
//  FeedViewController.swift
//  VKNews
//
//  Created by Rail on 01.11.2022.
//  Copyright © 2022 Хамидуллин Раиль. All rights reserved.
//

import UIKit


class FeedViewController: UIViewController {
    
//    Достаём объект класса NetworkService
    private let networkService = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
//        Вызовим метод getFeed
        networkService.getFeed()
    }
}
