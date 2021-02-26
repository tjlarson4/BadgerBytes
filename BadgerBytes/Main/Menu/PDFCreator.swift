
import UIKit
import PDFKit
import Firebase

class PDFCreator: NSObject {
    var menuItems = [MenuItem]()
    
    override init() {
    }
    
    func createOrder() -> Data {
      let pdfMetaData = [
        kCGPDFContextCreator: "Flyer Builder",
        kCGPDFContextAuthor: "raywenderlich.com",
      ]
      let format = UIGraphicsPDFRendererFormat()
      format.documentInfo = pdfMetaData as [String: Any]
      let pageWidth = 8.5 * 72.0
      let pageHeight = 11 * 72.0
      let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
      let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
      let data = renderer.pdfData { (context) in
        context.beginPage()
        
        let dC = MenuItem(name: "Double Cheseburger", price: "8", category: "Burgers", imageURL: "", id: "")
        let gCC = MenuItem(name: "Grilled Chickeen Sandwich", price: "8", category: "Chicken", imageURL: "", id: "")
        let cGG = MenuItem(name: "Crispy Chicken Sandwich", price: "8", category: "Chicken", imageURL: "", id: "")
        let cT = MenuItem(name: "Shrimp Basket", price: "9", category: "Seafood", imageURL: "", id: "")
        
        self.menuItems.append(dC)
        self.menuItems.append(gCC)
        self.menuItems.append(cGG)
        self.menuItems.append(cT)
        
        let receiptString = toString(pageRect: pageRect)
        
        let titleBottomY = addTitle(pageRect: pageRect)
        
        print(titleBottomY)
        
        let orderBottomY = addOrder(receipt: receiptString, pageRect: pageRect, titleBottomY: titleBottomY)
        
        print(orderBottomY)
        
        // let paymentLineBottomY = addPaymentLine(pageRect: pageRect, orderBottomY: orderBottomY)
        
        
        
        
        // getItemsFromOrder(orderId: orderId)
      }
      
      return data
    }
    
    
    // retrieve item info in order from DB
    func getItemsFromOrder(orderId: String) {
        
        menuItems = []
        
        let ref = Database.database().reference().child("menuItems")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else { return}
                
                let menuItem = MenuItem(id: key, dictionary: dictionary)
                
                print(menuItem.name)
                
                self.menuItems.append(menuItem)
            })
            
        }) { (err) in
            print("Failed to fetch items from menu:", err)
        }
    }
    
    // convert items in order to string
    func toString(pageRect: CGRect) -> String {
        var order = ""
        var total = 0.0

        for menuItem in menuItems {
            let name = menuItem.name
            let price = menuItem.price
            
            total = total + Double(price)!
            
            let itemToString = "$" + price + "    " + name + "\n"
            
            order = order + itemToString
        }
        
        order = order + "----------------------------------------------------------------\n"
        
        order = order + "$" + String(total)
        

        return order
    }
        
    
    func addTitle(pageRect: CGRect) -> CGFloat {
        let titleFont = UIFont.systemFont(ofSize: 40.0, weight: .bold)
        let titleAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: titleFont]
        let attributedTitle = NSAttributedString(
            string: "BadgerBytes",
            attributes: titleAttributes
        )
        
        let titleStringSize = attributedTitle.size()
        
        let titleStringRect = CGRect(
            x: (pageRect.width - titleStringSize.width) / 2.0,
            y: 40,
            width: titleStringSize.width,
            height: titleStringSize.height
        )
        
        attributedTitle.draw(in: titleStringRect)
        
        print(titleStringRect.origin.y)
        print(titleStringRect.size.height)
        
        return titleStringRect.origin.y + titleStringRect.size.height
    }
    
    
    func addOrder(receipt: String, pageRect: CGRect, titleBottomY: CGFloat) -> CGFloat {
        let textFont = UIFont.systemFont(ofSize: 20.0, weight: .regular)
        let style = NSMutableParagraphStyle()
        style.alignment = .natural
        style.lineBreakMode = .byWordWrapping
        let textAttributes = [
          NSAttributedString.Key.paragraphStyle: style,
          NSAttributedString.Key.font: textFont
        ]
        
        let attributedText = NSAttributedString(
          string: receipt,
          attributes: textAttributes
        )
        
        let orderRect = CGRect(
          x: 20,
          y: 75 + titleBottomY,
          width: pageRect.width - 20,
          height: pageRect.height - pageRect.height / 20.0
        )
        
        attributedText.draw(in: orderRect)
        
        print(orderRect.origin.y)
        print(orderRect.size.height)
        
        return orderRect.origin.y + orderRect.size.height
    }
}
        
        
        
        
        
        
        
        
        
        
        
        
//        let textFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)
//
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.alignment = .natural
//        paragraphStyle.lineBreakMode = .byWordWrapping
//
//        let textAttributes = [
//          NSAttributedString.Key.paragraphStyle: paragraphStyle,
//          NSAttributedString.Key.font: textFont
//        ]
//
//        let textRect = CGRect(
//          x: 10,
//          y: 10,
//          width: pageRect.width - 20,
//          height: pageRect.height - pageRect.height / 5.0
//        )
        
        
        
        
        
        
        
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
        
        
//        let attributedText = NSAttributedString(
//               string: "yooo",
//               attributes: textAttributes
//        )
//        attributedText.draw(in: textRect)

