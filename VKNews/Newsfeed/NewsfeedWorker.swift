//
//  NewsfeedWorker.swift
//  VKNews
//
//  Created by Rail on 03.11.2022.
//  Copyright (c) 2022 Хамидуллин Раиль. All rights reserved.
//

import UIKit

//   Класс для запроса данных
class NewsfeedService {
    
    //    Доступ к объектам аутентификации и сетевым запросам
    var authService: AuthService
    var networking: Networking
    var fetcher: DataFetcher
    
    //    Массив с постами Айди (в случае если потребуется несколько значений)
    private var reveledPostIds = [Int]()
    //    feedResponse будет принимать полученные данные из сети
    private var feedResponse: FeedResponse?
    //    Св-во для хранения ключа в формате unix time
    private var newFromInProcess: String?
    
    init() {
        self.authService = SceneDelegate.shared().authService
        self.networking = NetworkService(authService: authService)
        self.fetcher = NetworkDataFetcher(networking: networking)
    }
    
    //    Получаем изображения пользователя
    func getUser(completion: @escaping (UserResponse?) -> ()) {
        fetcher.getUser { (userResponce) in
            //            Передаём данные дальше
            completion(userResponce)
        }
    }
    
    //    Делаем запрос на полученние данных согласно структуре FeedResponse
    func getFeed(completion: @escaping ([Int], FeedResponse) -> ()) {
        //        Вызываем метод по запросу данных из сети, где nextBatchFrom = nil, потому что данное св-во не используется в этом запросе
        fetcher.getFeed(nextBatchFrom: nil) { [weak self] (feed) in
            //            Передаём полученные данные в наше св-во feedResponse
            self?.feedResponse = feed
            //                Проверяем на наличие данных
            guard let feedResponse = self?.feedResponse else { return }
            //            Передаём данные дальше
            completion(self!.reveledPostIds, feedResponse)
        }
    }
    
    //    Получаем идентификатор поста
    func revealPostIds(forPostId postId: Int, completion: @escaping ([Int], FeedResponse) -> ()) {
        
        //        Добавляем в наш массив с постами
        reveledPostIds.append(postId)
        //                Проверяем на наличие данных
        guard let feedResponse = self.feedResponse else { return }
        //            Передаём данные дальше
        completion(self.reveledPostIds, feedResponse)
    }
    
    //    Получаем новые посты из сети, которые добавляются внизу таблицы после старых новостей без дублирования и замены
    func getNewsBatch(completion: @escaping ([Int], FeedResponse) -> ()) {
        //        Передаём в наше св-во ключ
        newFromInProcess = feedResponse?.nextFrom
        //        Вызываем метод по запросу данных из сети
        fetcher.getFeed(nextBatchFrom: newFromInProcess) { [weak self] (feed) in
            //            Проверяем наличие данных
            guard let feed = feed else { return }
            //            проверяем совпадает ли ключ загрузки новой ленты с ключём загрузки предыдущей
            guard self?.feedResponse?.nextFrom != feed.nextFrom else { return }
            //            Проверяем наличие feed
            if self?.feedResponse == nil {
                self?.feedResponse = feed
            } else {
                //                Добавляем массив новостей
                self?.feedResponse?.items.append(contentsOf: feed.items)
                
                //                Фиксируем все профили
                var profiles = feed.profiles
                //                Проверяем существование старых профилей
                if let oldProfiles = self?.feedResponse?.profiles {
                    //                    Если да, то пробежимся по старому профилю через метод filter
                    let oldProfilesFiltered = oldProfiles.filter { (oldProfile) -> Bool in
                        //                        При каждой итерации значение будет добавляться в массив oldProfilesFiltred, если из всего списка новых профилей не существует ни одного профиля с тем же id
                        !feed.profiles.contains(where: { $0.id == oldProfile.id })
                    }
                    //                    Если это так
                    profiles.append(contentsOf: oldProfilesFiltered)
                }
                //                Добавляем новые профили
                self?.feedResponse?.profiles = profiles
                
                //                Фиксируем все группы
                var groups = feed.groups
                //                Проверяем существование старых групп
                if let oldGroups = self?.feedResponse?.groups {
                    //                    Если да, то пробежимся по старой группе через метод filter
                    let oldGroupsFiltered = oldGroups.filter { (oldGroup) -> Bool in
                        //                        При каждой итерации значения будет добавляться в массив oldGroupsFiltered, если из всего списка новых групп не существует ни одной группы с тем же id
                        !feed.groups.contains(where: { $0.id == oldGroup.id })
                    }
                    //                    Если это так
                    groups.append(contentsOf: oldGroupsFiltered)
                }
                //                Добавляем массив групп
                self?.feedResponse?.groups = groups
                //                Добавляем массив новых новостей без дублирования старых
                self?.feedResponse?.nextFrom = feed.nextFrom
            }
            //            Проверяем feedResponse
            guard let feedResponse = self?.feedResponse else { return }
            //            Передаём данные дальше
            completion(self!.reveledPostIds, feedResponse)
        }
    }
}
