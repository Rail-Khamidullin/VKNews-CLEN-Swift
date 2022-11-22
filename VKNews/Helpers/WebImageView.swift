//
//  WebImageView.swift
//  VKNews
//
//  Created by Rail on 08.11.2022.
//  Copyright © 2022 Хамидуллин Раиль. All rights reserved.
//

import UIKit


//   Класс, который загружает с сервера изображения и отправляет их в кеш для дальнейшего переиспользования
class WebImageView: UIImageView {
    
//    Св-во для хранения ссылки на изображение
    private var currentUrlString: String?
    
    //    Метод для получения иконки профиля человека или группы из сети по url адресу
    func set(imageUrl: String? ) {
        
//        Добавляем доступ к конкретной url ссылки
        currentUrlString = imageUrl
        
        //        Проверям url адресс
        guard let imageUrl = imageUrl, let url = URL(string: imageUrl) else {
            //            Если не удалось извлечь картинку, то выводим nil
            self.image = nil
            return
        }
        
        //        Проверяем было ли загружено уже изображение (имеется оно в нашем Кеш)
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            //            Если да, то присваиваем изображению данные из кеш
            self.image = UIImage(data: cachedResponse.data)
            return
        }
        
        //        Если в Кеш данных нет, то достаём данные для изображения из сети
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            //            Загружаем асинхронно в главной очереди
            DispatchQueue.main.async {
                if let data = data,
                   let response = response {
                    //                    Вызываем метод передачи загруженных изображений в кеш
                    self?.handleloadedImage(data: data, response: response)
                }
            }
        }
        dataTask.resume()
    }
    
    //    Метод обработки загруженных изображений с целью передачи в кеш
    private func handleloadedImage(data: Data, response: URLResponse) {
        //        Можем ли достать url от нашего response
        guard let responseURL = response.url else { return }
        //        Создаём кешированый ответ на запрос
        let cachedResponse = CachedURLResponse(response: response, data: data)
        //        Кто будет хранить кешированый ответ url для указаного запроса
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseURL))
        
        /// В целях более лучшего отображения изображений, чтобы не было старых изображений старой ячейки при прокрутки и обновления ленты (при переиспользовании ячейки)
//        Если наш url в кеш = текущему url
        if responseURL.absoluteString == currentUrlString {
//            Присваиваем полученное изображение
            self.image = UIImage(data: data)
        }
    }
}
