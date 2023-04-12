//
//  CameraViewController.swift
//  LeafLog
//
//  Created by Jonathan Tipton on 4/10/23.
//

import UIKit

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLayoutSubviews() {
        // border becomes a diamond instead of a circle if done in viewDidLoad()
        imageView.layer.borderColor = UIColor.init(named: "appGreen")?.cgColor
        imageView.layer.borderWidth = 5
        imageView.layer.cornerRadius = imageView.frame.size.height / 2
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .bottomRight
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.textColor = UIColor.init(named: "titleColor")

        print(imageView.layer.bounds.width)
#if targetEnvironment(simulator)
        print("In simulator! Test camera feature on a real device.")
#else
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.allowsEditing = false
        picker.showsCameraControls = false
        picker.cameraCaptureMode = .photo
        addChild(picker)
        picker.view.clipsToBounds = true
        picker.navigationBar.isHidden = true
        picker.view.isUserInteractionEnabled = true
        picker.view.tag = 1
        picker.view.addSubview(createCameraOverlay(for: picker.view))   //addSubview() required for gesture recognizer to work, use cameraOverlayView option below if only adding UI
        //picker.cameraOverlayView? = createCameraOverlay(for: picker.view)
        imageView.addSubview(picker.view)
#endif
    }
    
    @objc func takePhoto(_ sender: UITapGestureRecognizer) {
        guard let picker = imageView.viewWithTag(1)?.next as? UIImagePickerController else { self.titleLabel.text = "ERROR!"
            return
        }
        picker.takePicture()
        sender.view?.removeFromSuperview()
        UIView.transition(with: titleLabel, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.titleLabel.text = "Great!"
        })
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        
        let cropRect = CGRect(x: 0, y: (image.size.height / 2) - (image.size.width / 2), width: image.size.width, height: image.size.width)
        
        //image not initialized using a CIImage object
        let imageRef = image.cgImage?.cropping(to: cropRect)
        imageView.image = UIImage(cgImage: imageRef!)
        picker.removeFromParent()
    }
    
    func createCameraOverlay(for view: UIView) -> UIView {
        let overlayView = UIView(frame: view.frame)
        overlayView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(takePhoto(_:)))
        overlayView.addGestureRecognizer(tap)
        return overlayView
    }
}
