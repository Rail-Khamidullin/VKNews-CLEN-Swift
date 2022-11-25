//
//  ExtensionTableViewCell.swift
//  VKNews
//
//  Created by Rail on 16.11.2022.
//  Copyright © 2022 Хамидуллин Раиль. All rights reserved.
//

import Foundation
import UIKit

//   Расширение для ячейки в таблице, посколько она создала слой UITableViewCellContentView поверх 2 слоя. Чтобы объекты реагировали на нажатие, они должны быть добавлены как contentView.addSubview(...), делаем это автоматически
extension UITableViewCell {
    open override func addSubview(_ view: UIView) {
        super.addSubview(view)
        sendSubviewToBack(contentView)
    }
}
