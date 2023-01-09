//
//  DetailTaskPresenter.swift
//  FirebaseAuthentication
//
//  Created by Алексей on 1/9/23.
//

import Foundation

protocol DetailTaskPresenterProtocol{
    var view: DetailTaskProtocol? { get set }
    init(view: DetailTaskProtocol, router: RouterProtocol)
}

class DetailTaskPresenter: DetailTaskPresenterProtocol {

    weak var view: DetailTaskProtocol?
    var router: RouterProtocol?
    
    required init(view: DetailTaskProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
}
