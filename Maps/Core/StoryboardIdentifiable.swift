//
//  StoryboardIdentifiable.swift
//  Maps
//
//  Created by Artem Kufaev on 01/10/2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit

protocol StoryboardIdentifiable {
    static var storyboardIdentifiable: String { get }
}

extension UIViewController: StoryboardIdentifiable { }

extension StoryboardIdentifiable where Self: UIViewController {
    
    static var storyboardIdentifiable: String {
        return String(describing: self)
    }
    
}

extension UIStoryboard {
    
    func instantiateViewController<T: UIViewController>(_: T.Type) -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifiable) as? T else {
            fatalError("ViewController с идентификатором \(T.storyboardIdentifiable) не найден")
        }
        
        return viewController
    }
    
}
