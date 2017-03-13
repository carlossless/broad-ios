//
//  SelectionNavigationController.swift
//  lrt
//
//  Created by Karolis Stasaitis on 07/03/2017.
//  Copyright © 2017 delanoir. All rights reserved.
//

import UIKit

class SelectionNavigationController : UINavigationController, ModelBased {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        pushViewController(MainViewController(), animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for model: MainViewModel) {
        if let main = viewControllers.first as? MainViewController {
            main.configure(for: model)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.backgroundColor = UIColor(hex: 0x373D55)
        self.navigationBar.barTintColor = UIColor(hex: 0x373D55)
        self.navigationBar.isTranslucent = false
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
