//
//  QRScanViewController.swift
//  QRecu
//
//  Created by Arimac on 2024-11-06.
//

import UIKit
import AVFoundation

protocol QRScanViewDelegate: AnyObject {
    func didReceiveData(_ data: String)
}

class QRScanViewController: UIViewController {
    
    let session = AVCaptureSession()
    weak var delegate: QRScanViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupCamera()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if session.isRunning {
            session.stopRunning()
        }
        session.inputs.forEach { session.removeInput($0) }
        session.outputs.forEach { session.removeOutput($0) }
    }
    
    private enum Constants {
        static let alertTitle = "Scanning is not supported"
        static let alertMessage = "Your device does not support scanning a code from an item. Please use a device with a camera."
        static let alertButtonTitle = "OK"
    }
    
    // MARK: - set up camera
    func setupCamera() {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            
            let output = AVCaptureMetadataOutput()
            
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            session.addInput(input)
            session.addOutput(output)
            
            output.metadataObjectTypes = [.qr]
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = view.bounds
            
            view.layer.addSublayer(previewLayer)
            DispatchQueue.main.async {
                self.session.startRunning()
            }
        } catch {
            showAlert()
            print(error)
        }
    }
    
    // MARK: - Alert
    func showAlert() {
        let alert = UIAlertController(title: Constants.alertTitle,
                                      message: Constants.alertMessage,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.alertButtonTitle,
                                      style: .default))
        present(alert, animated: true)
    }
}
    
extension QRScanViewController: AVCaptureMetadataOutputObjectsDelegate {

    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        
        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
                  metadataObject.type == .qr,
                  let stringValue = metadataObject.stringValue else { return }
        
        print(stringValue)
        session.stopRunning()
        DispatchQueue.main.async {
            self.delegate?.didReceiveData(stringValue)
            self.navigationController?.popViewController(animated: true)
        }
    }
}
