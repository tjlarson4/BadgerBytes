//
//  ReceiptBuilderViewController.swift
//  BadgerBytes
//
//  Created by David Portugal on 2/23/21.
//

import UIKit
import PDFKit
import Firebase

class ReceiptBuilderVC: UIViewController {

    override func viewDidLoad() {
        view.backgroundColor = UIColor.blue
        setUpButton()
    }
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        return sv
    }()
    
    let pdfReceiptButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 9
        btn.add(text: "pdf receipt", font: UIFont(boldWithSize: 18), textColor: .subtitle_label)
        btn.layer.borderColor = UIColor.subtitle_label.cgColor
        btn.layer.borderWidth = 1
        btn.addTarget(self, action: #selector(handlePDFReceipt), for: .touchUpInside)
        
        return btn
    }()
    
    @objc func handlePDFReceipt() {
        print("pdf receipt button pressed")
        
//        let vc = PDFReceiptVC()
    
        //let pdfCreator = PDFCreator()

        //let documentData = pdfCreator.createOrder()
        
//        let pdfView = PDFView(frame: view.bounds)
//        view.addSubview(pdfView)
//        
//        let pdfDocument = PDFDocument(data: documentData)
//        pdfView.document = pdfDocument
        
        // pdfView.removeFromSuperview()
    }
    
    func setUpButton() {
        self.view.addSubviews(views: [scrollView])
        self.scrollView.addSubviews(views: [pdfReceiptButton])

        scrollView.fillSuperview()
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 2000)

        pdfReceiptButton.anchor(nil, left: view.leftAnchor, bottom: scrollView.safeAreaLayoutGuide.bottomAnchor, right: scrollView.rightAnchor, topConstant: 200, leftConstant: 30, bottomConstant: 40, rightConstant: 30, widthConstant: 0, heightConstant: 50)
        pdfReceiptButton.anchorCenterXToSuperview()
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print("segue initiated")
//        if (segue.identifier == "receiptViewSegue") {
//            guard
//                let vc = segue.destination as? PDFReceiptVC
//            else { return }
//
//            let pdfCreator = PDFCreator(
//                title: "BadgerBytes"
//            )
//
//            vc.documentData = pdfCreator.createOrder()
//        }
//    }

}
