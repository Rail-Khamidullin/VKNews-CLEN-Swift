//
//  NewsfeedViewController.swift
//  VKNews
//
//  Created by Rail on 03.11.2022.
//  Copyright (c) 2022 Хамидуллин Раиль. All rights reserved.
//

import UIKit

//   Метода для отображения интерфейса
protocol NewsfeedDisplayLogic: class {
    func displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData)
}

class NewsfeedViewController: UIViewController, NewsfeedDisplayLogic, NewsFeedCodeDelegate {
    
    //    Экземпляр класса интерактор (сетевой запрос)
    var interactor: NewsfeedBusinessLogic?
    //    Экземпляр класса роутер в случае нескольких экранов
    var router: (NSObjectProtocol & NewsfeedRoutingLogic)?
    //    Создаём модель данных новостной ленты  FeedViewModel, которая содержит посты нашего массива
    private var feedViewModel = FeedViewModel.init(cells: [], footerTitle: nil)
    //    Наша таблица
    @IBOutlet weak var tableView: UITableView!
    //    Экземпляр класса TitleView
    private let titleView = TitleView()
    //    Экземпляр класса нижнего колонтитула, который будет инициализироваться только тогда, когда мы его вызываем
    private lazy var footerView = FooterView()
    //    Активити индикатор для tableView
    private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        //        Добавляем ему действие
        refreshControl.addTarget(self,
                                 action: #selector(refresh),
                                 for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: Setup (конфигурация модуля )
    
    //    Зависимости
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
        //        Зависимости
        setup()
        //        Вызываем метод настройки навигейшн бара
        setupTopBar()
        //        Настройка отображения таблицы
        setupTable()
        //    Отправляем запрос на получение данных для отображеия в новостной ленте (отправляемся в интерактор)
        interactor?.makeRequest(request: Newsfeed.Model.Request.RequestType.getNewsFeed)
        //        Отправляем запрос на получение данных для отображения фото профиля в навигейшн баре (отправляемся в интерактор)
        interactor?.makeRequest(request: Newsfeed.Model.Request.RequestType.getUser)
    }
    
    //    Настраиваем навигешн бар
    private func setupTopBar() {
        //        Настраиваем кастомный таб  бар
        let topBar = UIView(frame: UIApplication.shared.statusBarFrame)
        topBar.backgroundColor = .white
        //        Цвет тени
        topBar.layer.shadowColor = UIColor.black.cgColor
        //        Непрозрачность тени
        topBar.layer.shadowOpacity = 0.3
        //        Смещение тени
        topBar.layer.shadowOffset = CGSize.zero
        //        Радиус тени
        topBar.layer.shadowRadius = 8
        //        Добавляем topBar на view
        self.view.addSubview(topBar)
        //        Исчезновение бара при прокрутке вниз и появление при обратном
        self.navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //        Присваиваем загаловок навигейшн бара на наш созданный загаловок из TitleView
        self.navigationItem.titleView = titleView
    }
    
    //    Настройка отображения таблицы
    private func setupTable() {
        //        Расстояние сверху
        let topInset: CGFloat = 8
        //        Добавим данное расстояние от таблицы до навигейшн бара
        tableView.contentInset.top = topInset
        //        Убираем разделитель между ячейками
        tableView.separatorStyle = .none
        //        Убираем заливку таблицы
        tableView.backgroundColor = .clear
        //    Регистрируем нашу ячейку NewsfeedCell
        tableView.register(UINib(nibName: "NewsfeedCell", bundle: nil), forCellReuseIdentifier: NewsfeedCell.reuseId)
        //        Регистрируем новуу ячейку, где будем создавать отображение объектов программно
        tableView.register(NewsfeedCodeCell.self, forCellReuseIdentifier: NewsfeedCodeCell.reuseId)
        //        Добавляем refreshControl
        tableView.addSubview(refreshControl)
        //        Добавляем footerView
        tableView.tableFooterView = footerView
    }
    
    //    Действие на момент запуска индикатора
    @objc private func refresh() {
        interactor?.makeRequest(request: Newsfeed.Model.Request.RequestType.getNewsFeed)
    }
    
    //  С помощью полученных и обработанных данных displayData вносит изменения в пользовательский интерфейс
    func displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData) {
        switch viewModel {
        
        case .displayNewsfeed(feedViewModel: let feedViewModel):
            //            Заполняем нашу структуру FeedViewModel полученным сконвертированными данными из presenter
            self.feedViewModel = feedViewModel
            //            Обновляем нашу таблицу
            tableView.reloadData()
            //            Останавливаем работу контрола после загрузки
            refreshControl.endRefreshing()
            //            Вызываем метод setTitle у footerView для остановки работы активити индикатора и отображения необходимой записи в колонтитуле
            footerView.setTitle(feedViewModel.footerTitle)
            
        //            Отображаем наш titleView в навигейшн баре
        case .displayUser(userViewModel: let userViewModel):
            titleView.set(userViewModel: userViewModel)
        //            Отображаем наш колонтитул с работой активити индикатора
        case .displayFooterLoader:
            footerView.showLoader()
        }
    }
    
    //    Фиксирует местоположение на экране
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //        Если мы опустимся ниже середины новостной ленты, то будем выводить
        if scrollView.contentOffset.y < scrollView.contentSize.height / 1.1 {
            //            Отправляем запрос на обновление новостной ленты снизу, после скролла на верх
            interactor?.makeRequest(request: Newsfeed.Model.Request.RequestType.getNextBatch)
        }
    }
    
    // MARK: - реализуем функцию протокола NewsFeedCodeDelegate
    
    func revealPost(for cell: NewsfeedCodeCell) {
        //        Какая по счёту ячейка, текст которой нужно раскрыть
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        //        Достаём ячейку с массивом данных
        let cellViewModel = feedViewModel.cells[indexPath.row]
        //        Отправляем запрос на получение postId в интереактор
        interactor?.makeRequest(request: .revealPostIds(postId: cellViewModel.postId))
    }
}

extension NewsfeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        Кол-во ячеек в секции
        return feedViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        ///   1-ый вариант: Работа через XIB file
        /*
         //        Создаём ячейку
         let cell = tableView.dequeueReusableCell(withIdentifier: NewsfeedCell.reuseId, for: indexPath) as! NewsfeedCell
         */
        
        ///   2-ой вариант: Работать полностью программно
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsfeedCodeCell.reuseId, for: indexPath) as! NewsfeedCodeCell
        //        Достаём ячейку с массивом данных
        let cellViewModel = feedViewModel.cells[indexPath.row]
        //        Передаём в наши объекты данные для отображения
        cell.set(viewModel: cellViewModel)
        //        Делегат будет реализовывать ячейка
        cell.delegate = self
        
        return cell
    }
    
    //    Устанавливаем высоту ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = feedViewModel.cells[indexPath.row]
        return cellViewModel.sizes.totalHeight
    }
    
    //    При нажатии на moreTextButton пост с текстом будет увеличен и изменятся размеры ячейки. Данный метод автоматически высчитывает размеры ячейки таблицы.
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = feedViewModel.cells[indexPath.row]
        return cellViewModel.sizes.totalHeight
    }
}

