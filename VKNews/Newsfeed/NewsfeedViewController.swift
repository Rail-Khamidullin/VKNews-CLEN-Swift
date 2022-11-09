//
//  NewsfeedViewController.swift
//  VKNews
//
//  Created by Rail on 03.11.2022.
//  Copyright (c) 2022 Хамидуллин Раиль. All rights reserved.
//

import UIKit

protocol NewsfeedDisplayLogic: class {
    func displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData)
}

class NewsfeedViewController: UIViewController, NewsfeedDisplayLogic {
    
    var interactor: NewsfeedBusinessLogic?
    var router: (NSObjectProtocol & NewsfeedRoutingLogic)?
    //    Создаём модель данных новостной ленты  FeedViewModel, которая содержит посты нашего массива
    private var feedViewModel = FeedViewModel.init(cells: [])
    //    Наша таблица
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = NewsfeedInteractor()
        let presenter             = NewsfeedPresenter()
        let router                = NewsfeedRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    // MARK: Routing
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        //        Убираем разделитель между ячейками
        tableView.separatorStyle = .none
        //        Убираем заливку таблицы
        tableView.backgroundColor = .clear
        //        Меняем цвет родительского view
        view.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        //    Регистрируем нашу ячейку NewsfeedCell
        tableView.register(UINib(nibName: "NewsfeedCell", bundle: nil), forCellReuseIdentifier: NewsfeedCell.reuseId)
        //    Отправляем запрос на получение данных для отображеия в новостной ленте (отправляемся в интерактор)
        interactor?.makeRequest(request: .getNewsFeed)
    }
    
    //  С помощью полученных и обработанных данных displayData вносит изменения в пользовательский интерфейс
    func displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData) {
        switch viewModel {
        
        case .displayNewsfeed(feedViewModel: let feedViewModel):
            //            Заполняем нашу структуру FeedViewModel полученным сконвертированными данными из presenter
            self.feedViewModel = feedViewModel
            //            Обновляем нашу таблицу
            tableView.reloadData()
        }
    }
}

extension NewsfeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //        Создаём ячейку
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsfeedCell.reuseId, for: indexPath) as! NewsfeedCell
        
        //        Достаём ячейку с массивом данных
        let cellViewModel = feedViewModel.cells[indexPath.row]
        //        Передаём в наши объекты данные для отображения
        cell.set(viewModel: cellViewModel)
        return cell
    }
    
    //    Метод, который ловит нажатие на ячейку
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    //        print("select row: \(indexPath.row)")
    ////        Хотим получить новостные данные и отправляемся в интеректор
    //        interactor?.makeRequest(request: .getFeed)
    //    }
    
    //    Устанавливаем высоту ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 212
    }
}
