//
//  TextFieldManager.swift
//  spotify
//
//  Created by Gustavo Adolfo Cardona Quintero on 17/02/24.
//

import UIKit

protocol TextFieldManagerDelegate: AnyObject {
    func textFieldManager(_ textFieldManager: TextFieldManager)
}

class TextFieldManager {
    private unowned var delegate: TextFieldManagerDelegate?
    
    init(delegate: TextFieldManagerDelegate) {
        self.delegate = delegate
    }
}

/*extension TextFieldManager: UITextFieldDelegate {
    
}*/
