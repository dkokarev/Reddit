//
//  ViewControllerExtension.swift
//  Reddit
//
//  Created by Danil Kokarev on 30.07.2018.
//  Copyright © 2018 Danil Kokarev. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func shareImage(image: UIImage) {
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        controller.excludedActivityTypes = [.airDrop, .assignToContact, .addToReadingList, .copyToPasteboard]
        self.present(controller, animated: true, completion: nil)
    }
    
}
