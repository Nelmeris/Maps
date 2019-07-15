//
//  MainViewController.swift
//  Maps
//
//  Created by Artem Kufaev on 30/09/2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController {
    
    @IBOutlet var router: MainRouter!
    
    @IBOutlet weak var mainBox: UIView! {
        didSet {
            mainBox.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var helloLabel: UITextView!
    @IBOutlet weak var changeMarkerButton: UIButton!
    @IBOutlet weak var resetMarkerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        
        guard let userName = Authorization.shared.userName else { fatalError() }
        helloLabel.text = "Добро пожаловать, \(userName)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let markerImagePath = documentsDirectory?.appendingPathComponent("MarkerImage.png").path
        
        if FileManager.default.fileExists(atPath: markerImagePath!) {
            resetMarkerButton.isEnabled = true
            resetMarkerButton.titleLabel?.textColor = .white
            changeMarkerButton.titleLabel?.text = "Изменить маркер"
        } else {
            resetMarkerButton.isEnabled = false
            resetMarkerButton.titleLabel?.textColor = .gray
            changeMarkerButton.titleLabel?.text = "Установить маркер"
        }
    }
    
    @IBAction func openMap(_ sender: Any) {
        router.toMap()
    }
    
    @IBAction func logout(_ sender: Any) {
        Authorization.shared.logout()
        router.toLogin()
    }

    @IBAction func changeMarker(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true)
    }
    
    @IBAction func resetMarker(_ sender: Any) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let markerImagePath = documentsDirectory?.appendingPathComponent("MarkerImage.png").path
        try? FileManager.default.removeItem(atPath: markerImagePath!)
        resetMarkerButton.isEnabled = false
        resetMarkerButton.titleLabel?.textColor = .gray
        changeMarkerButton.titleLabel?.text = "Установить маркер"
    }
    
}

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = extractImage(from: info)
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let markerImagePath = documentsDirectory?.appendingPathComponent("MarkerImage.png").path
        FileManager.default.createFile(atPath: markerImagePath!, contents: image?.pngData())
        
        picker.dismiss(animated: true)
    }
    
    private func extractImage(from info: [UIImagePickerController.InfoKey : Any]) -> UIImage? {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            return image
        } else {
            return nil
        }
    }
    
}
