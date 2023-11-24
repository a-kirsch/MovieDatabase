//
//  PopUpModalViewController.swift
//  AdamKirsch-Lab4
//
//  Created by Adam Kirsch on 10/24/23.
//

import UIKit

protocol PopUpModalViewControllerDelegate: AnyObject {
    func popUpModalViewControllerExtension(sender: PopUpModalViewController, didSelectNumber: Int)
}

class PopUpModalViewController: UIViewController {
    
    weak var delegate: PopUpModalViewControllerDelegate?
    static func instantiate() -> PopUpModalViewController? {
        return PopUpModalViewController(nibName: nil, bundle: nil)
    }
    
    
    @IBOutlet weak var popupView: UIView!
    
    @IBOutlet weak var fullDescription: UILabel!
    
    var movieDescription: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullDescription.text = movieDescription
        fullDescription.numberOfLines = 0
    }
    
}
