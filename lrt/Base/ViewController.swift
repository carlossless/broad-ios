//
//  ViewController.swift
//  lrt
//
//  Created by Karolis Stasaitis on 31/05/2017.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation
import UIKit

public class ViewController<ViewType: UIView> : UIViewController {
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func loadView() {
        view = ViewType()
    }
    
    public var controlledView: ViewType {
        return view as! ViewType
    }
    
}
