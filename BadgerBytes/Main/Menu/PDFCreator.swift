
import UIKit
import PDFKit
import Firebase

class PDFCreator: NSObject {
    let orderId: String
    
    init(orderId: String) {
        self.orderId = orderId
    }
    
    func createOrder() -> Data {
      // 1
      let pdfMetaData = [
        kCGPDFContextCreator: "Flyer Builder",
        kCGPDFContextAuthor: "raywenderlich.com",
        kCGPDFContextTitle: orderId
      ]
      let format = UIGraphicsPDFRendererFormat()
      format.documentInfo = pdfMetaData as [String: Any]
      
      // 2
      let pageWidth = 8.5 * 72.0
      let pageHeight = 11 * 72.0
      let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
      
      // 3
      let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
      // 4
      let data = renderer.pdfData { (context) in
        // 5
        context.beginPage()
        // 6
        
        
        getItemsFromOrder(pageRect: pageRect, orderId: orderId)
      
      }
      
      return data
    }
    
    
    // write order
    func getItemsFromOrder(pageRect: CGRect, orderId: String) {
        let textFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .natural
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let textAttributes = [
          NSAttributedString.Key.paragraphStyle: paragraphStyle,
          NSAttributedString.Key.font: textFont
        ]
        
        let textRect = CGRect(
          x: 10,
          y: 10,
          width: pageRect.width - 20,
          height: pageRect.height - pageRect.height / 5.0
        )
        
        
        
        //let allMenuItems = Database.database().reference().child("menuItems")
        
//        var receipt = "test"
//        var itemOrderOnReceipt = ""
        
//        var name = "uh"
//        var price = ""
        
        // get menu items
//        allMenuItems.getData { (error, snapshot) in
//
//            // children of menu items
//            let items = snapshot.children.allObjects as! [DataSnapshot]
//            // get items
//            for item in items {
//                //let allData = item.children.allObjects as! [DataSnapshot]
//                // get data points of each item
////                for itemData in allData {
//                let data = item.value as? NSDictionary
////                    print(data)
//
//                name = data?["name"] as? String ?? ""
//
//                let attributedText = NSAttributedString(
//                    string: name,
//                    attributes: textAttributes
//                )
//                attributedText.draw(in: textRect)
//
////                }
//            }
//
//        }
//
//        print(name)
        
        
//        allMenuItems.observe(.childAdded, with: { items in
//            let data = items.value as? [String: Any]
//
//            //let category = data!["category"] as? String ?? ""
//            let name = data!["name"] as? String ?? ""
//            let price = data!["price"] as? String ?? ""
//
//            print(name)
//            print(price)
//
//            itemOrderOnReceipt = name
//
//            receipt = receipt + itemOrderOnReceipt + "\n"
//        })
        
        
        let attributedText = NSAttributedString(
               string: "yooo",
               attributes: textAttributes
        )
        attributedText.draw(in: textRect)
    }
}