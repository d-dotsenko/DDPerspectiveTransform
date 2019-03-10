//
//  ViewController.swift
//  DDPerspectiveTransformExample
//
//  Created by Dmitriy Dotsenko on 24/02/2019.
//  Copyright © 2019 Dmitriy Dotsenko. All rights reserved.
//

import UIKit
import DDPerspectiveTransform

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let editItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                       target: self,
                                       action: #selector(openEdit))
        
        let libraryItem = UIBarButtonItem(barButtonSystemItem: .camera,
                                          target: self,
                                          action: #selector(openLibrary))
        
        self.navigationItem.leftBarButtonItem = libraryItem
        self.navigationItem.rightBarButtonItem = editItem
        
        if (self.image == nil) {
            openLibrary()
        }
    }
    
    @objc func openLibrary() {
        let pickerView = UIImagePickerController.init()
        pickerView.delegate = self
        pickerView.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        present(pickerView, animated: true, completion: nil)
    }
    
    @objc func openEdit() {
        guard let image = image else {
            return
        }
        self.edit(image: image)
    }
    
    func edit(image: UIImage) {
        let cropViewController = DDExampleCropViewController()
        cropViewController.delegate = self
        cropViewController.image = image
        cropViewController.pointSize = CGSize(width: 40, height: 40)

        navigationController?.pushViewController(cropViewController, animated: true)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        self.image = image
        picker.dismiss(animated: true) {
            self.edit(image: image)
        }
    }
}

extension ViewController: DDPerspectiveTransformProtocol {
    func perspectiveTransformingDidFinish(controller: DDPerspectiveTransformViewController, croppedImage: UIImage) {
        self.imageView?.image = croppedImage
        _ = controller.navigationController?.popViewController(animated: true)
    }
    
    func perspectiveTransformingDidCancel(controller: DDPerspectiveTransformViewController) {
        _ = controller.navigationController?.popViewController(animated: true)
    }
}
