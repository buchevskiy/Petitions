//
//  Petition.swift
//  Project 7
//
//  Created by Андрей Бучевский on 06.09.2021.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
