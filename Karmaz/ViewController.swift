//
//  ViewController.swift
//  Karmaz
//
//  Created by Наталья Атюкова on 31.07.2023.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

 
    @IBAction func startButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let regViewController = storyboard.instantiateViewController(identifier: "RegViewController") as? RegViewController else { return }
        regViewController.modalPresentationStyle = .fullScreen
        present(regViewController, animated: true, completion: nil)
    }
    
}

