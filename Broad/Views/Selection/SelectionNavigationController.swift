//
//  SelectionNavigationController.swift
//  Broad
//
//  Created by Karolis Stasaitis on 07/03/2017.
//  Copyright © 2017 delanoir. All rights reserved.
//

import UIKit

class SelectionNavigationController : UINavigationController, ModelBased {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        pushViewController(SelectionViewController(), animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for model: SelectionViewModel) {
        if let main = viewControllers.first as? SelectionViewController {
            main.configure(for: model)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.backgroundColor = UIColor(hex: 0x373D55)
        self.navigationBar.barTintColor = UIColor(hex: 0x373D55)
        self.navigationBar.tintColor = UIColor(hex: 0xFFFFFF)
        self.navigationBar.isTranslucent = false
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
}
