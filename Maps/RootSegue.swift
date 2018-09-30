//
//  RootSegue.swift
//  Maps
//
//  Created by Artem Kufaev on 30/09/2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit

class RootSegue: UIStoryboardSegue {
    override func perform() {
        UIApplication.shared.delegate?.window??.rootViewController = destination
    }
}
