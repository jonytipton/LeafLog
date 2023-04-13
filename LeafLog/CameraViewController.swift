//
//  CameraViewController.swift
//  LeafLog
//
//  Created by Jonathan Tipton on 4/10/23.
//

import UIKit

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var instructionLabel: UILabel!
    @IBOutlet var continueButton: UIButton!
    var firstTake = true
    
    override func viewDidLayoutSubviews() {
        // border becomes a diamond instead of a circle if done in viewDidLoad()
        imageView.layer.borderColor = UIColor.init(named: "appGreen")?.cgColor
        imageView.layer.borderWidth = 5
        imageView.layer.cornerRadius = imageView.frame.size.height / 2
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.textColor = UIColor.init(named: "titleColor")

        print(imageView.layer.bounds.width)
#if targetEnvironment(simulator)
        print("In simulator! Test camera feature on a real device.")
#else
        createImagePicker()
#endif
    }
    
    @objc func createImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.showsCameraControls = false
        picker.cameraCaptureMode = .photo
        picker.view.clipsToBounds = true
        picker.navigationBar.isHidden = true
        picker.view.isUserInteractionEnabled = true
        picker.view.tag = 1
        addChild(picker)
        picker.view.addSubview(createCameraOverlay(for: picker.view))   //addSubview() required for gesture recognizer to work, use cameraOverlayView option below if only adding UI
        //picker.cameraOverlayView? = createCameraOverlay(for: picker.view)
        imageView.addSubview(picker.view)
        
        navigationItem.setRightBarButton(.none, animated: true)
        UIView.transition(with: titleLabel, duration: 0.5, options: .transitionFlipFromBottom, animations: {
            self.titleLabel.text = "Take A Pic"
        })
        UIView.transition(with: self.stackView, duration: 0.5, options: .transitionCrossDissolve, animations: { [unowned self] in
            self.instructionLabel.alpha = 1
            self.continueButton.alpha = 0
            self.instructionLabel.isHidden = false
            self.continueButton.isHidden = true
        })
    }
    
    @objc func takePhoto(_ sender: UITapGestureRecognizer) {
        guard let picker = imageView.viewWithTag(1)?.next as? UIImagePickerController else { self.titleLabel.text = "ERROR!"
            return
        }
        picker.takePicture()
        sender.view?.removeFromSuperview()
        UIView.transition(with: titleLabel, duration: 0.5, options: .transitionCrossDissolve, animations: { [unowned self] in
            self.titleLabel.text = "Looks Good!"
        })
        UIView.transition(with: self.stackView, duration: 0.5, options: .transitionCrossDissolve, animations: { [unowned self] in
            self.instructionLabel.alpha = 0
            self.instructionLabel.isHidden = true
            self.continueButton.isHidden = false
            self.continueButton.alpha = 1
        })
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(createImagePicker)), animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        
        //Align UIImage with camera preview
        let cropRect = CGRect(x: 0, y: picker.view.frame.height + 250, width: image.size.height / 2 , height: image.size.height / 2)
        let cgImage = image.cgImage!
        let croppedCGImage = cgImage.cropping(to: cropRect)
        let croppedImage = UIImage(
            cgImage: croppedCGImage!, scale: image.imageRendererFormat.scale, orientation: image.imageOrientation)
        picker.view.removeFromSuperview()
        picker.removeFromParent()
        imageView.image = croppedImage
    }
    
    func createCameraOverlay(for view: UIView) -> UIView {
        let overlayView = UIView(frame: view.frame)
        overlayView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(takePhoto(_:)))
        overlayView.addGestureRecognizer(tap)
        return overlayView
    }
}
