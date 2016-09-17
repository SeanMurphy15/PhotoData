//
//  ViewController.swift
//  PhotoBlitz
//
//  Created by Sean Murphy on 9/10/16.
//  Copyright © 2016 Sean Murphy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase
import AVFoundation

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate{

	let storageRef = FIRStorage.storage().reference()
	let databaseRef = FIRDatabase.database().reference()


	let userID = "PbfzlhM9fya6OXzy9EyiEyCYoJG2"

	let captureSession = AVCaptureSession()
	let stillImageOutput = AVCapturePhotoOutput()
	var error: NSError?
	override func viewDidLoad() {
		super.viewDidLoad()
		print(databaseRef)
		if let discoverySession = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInTelephotoCamera], mediaType: AVMediaTypeVideo, position: AVCaptureDevicePosition.front){


			do {
				let input = try AVCaptureDeviceInput(device: discoverySession.devices.first)
				captureSession.addInput(input)
			} catch _ {
				print("error: \(error?.localizedDescription)")
			}
			captureSession.sessionPreset = AVCaptureSessionPresetPhoto
			captureSession.startRunning()
			if captureSession.canAddOutput(stillImageOutput) {
				captureSession.addOutput(stillImageOutput)
			}
			if let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) {
				previewLayer.bounds = view.bounds
				previewLayer.position = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
				previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
				let cameraPreview = UIView(frame: CGRect(x: 0.0, y: 0.0, width: view.bounds.size.width, height: view.bounds.size.height))
				cameraPreview.layer.addSublayer(previewLayer)
				view.addSubview(cameraPreview)
			}
		}

	}

	func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
		let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: previewPhotoSampleBuffer!, previewPhotoSampleBuffer: photoSampleBuffer)
		//				UIImageWriteToSavedPhotosAlbum(UIImage(data: imageData)!, nil, nil, nil)
		self.saveToFirebase(nsdata: imageData!)

	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	let albumID = UUID().uuidString

		func saveToFirebase(nsdata: Data){
			let data: Data = nsdata
			let imageID = NSUUID().uuidString
			let metadata = FIRStorageMetadata()
			metadata.contentType = "image/jpeg"
			let image = storageRef.child("albums/\(albumID)/\(imageID)")
				let uploadTask = image.put(data, metadata: metadata) { metadata, error in
					if (error != nil) {
						print(error)
					} else {
						let downloadURL = metadata!.downloadURL
						print(downloadURL)
					}
				}
	
		}

}
