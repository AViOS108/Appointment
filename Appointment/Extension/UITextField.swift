//  Created by Anurag Bhakuni on 15/01/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.



import Foundation
import UIKit


  
class LeftPaddedTextField: UITextField {

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width-40, height: bounds.height)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width-40, height: bounds.height)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width-40, height: bounds.height)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x:bounds.width - 18 , y: bounds.height/2 - 5, width: 14, height: 10)
        
    }
   
    
}
