//
//  MovieDetailsController.swift
//  CoppelExam
//
//  Created by Victor Aguayo on 04/10/22.
//


import UIKit

class MovieDetails : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        let backButton = UIBarButtonItem()
         backButton.title = "New Back Button Text"
         self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
}

