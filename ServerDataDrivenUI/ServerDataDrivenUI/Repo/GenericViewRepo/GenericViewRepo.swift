//
//  GenericViewRepo.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 18/06/22.
//

import UIKit

class GenericViewRepo {
    let componentDataModels: [UIComponentDataModel]
    
    init() {
        let viewDataModel: ViewDataModel = Utils.loadJson(filename: "ViewDataModelData")!
        self.componentDataModels = viewDataModel.views["login"] ?? []
    }
}
