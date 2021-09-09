
//  Created by Anurag Bhakuni on 15/01/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.

import UIKit

@objc class ILColor: NSObject {
    
    @objc public class func color(index : Int) -> UIColor {
        
        if index == 1 {
            //blue #3c374d
            return UIColor.init(red: 60/255, green: 55/255, blue: 77/255, alpha: 1)
        }
        else if index == 2 {
            //  dark blue text color #50597b
            return UIColor.init(red: 80/255, green: 89/255, blue: 123/255, alpha: 1)
        }
            
        else if index == 3 {
            //whiite color #FFFFFF
            return UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        }
        else if index == 4 {
            // black color #000000
            return UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        }
        else if index == 5 {
            // Gray color #414141
            return UIColor.init(red: 61/255, green: 61/255, blue: 61/255, alpha: 1)
        }
        else if index == 6 {
            // Gray color #f8f8f8
            return UIColor.init(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
        }
        else if index == 7 {
            // Blue color #0074c2
            return UIColor.init(red: 0/255, green: 116/255, blue: 194/255, alpha: 1)
            
        }
            
        else if index == 8 {
            // Blue color #0074c1
            return UIColor.init(red: 0/255, green: 116/255, blue: 193/255, alpha: 1)
            
        }
        else if index == 9 {
            // Blue color #0b4267
            return UIColor.init(red: 11/255, green: 66/255, blue: 103/255, alpha: 1)
            
        }
        else if index == 10 {
            // Black  Blur color #00000
            return UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            
        }
        else if index == 11 {
            // White Blur color #ffffff
            return UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.8)
            
        }
        else if index == 12 {
            // Red color #d11800
            return UIColor.init(red: 209/255, green: 24/255, blue: 0/255, alpha: 1)
            
        }
        else if index == 13 {
            // Black color #0b0b0b
            return UIColor.init(red: 11/255, green: 11/255, blue: 11/255, alpha: 1)
            
        }
        else if index == 14{
            // Gray color
            return UIColor.init(red: 198/255, green: 198/255, blue: 198/255, alpha: 1)
        }
        else if index == 15{
            // GREEN color
            return UIColor.init(red: 30/255, green: 131/255, blue: 0/255, alpha: 1)
        }
        else if index == 16{
            // BLACK color
            return UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
        }
        else if index == 17{
            // BLACK color
            return UIColor.init(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        }
        else if index == 18 {
            // Gray color #f8f8f8
            return UIColor.init(red: 210/255, green: 210/255, blue: 210/255, alpha: 1)
        }
        else if index == 19 {
            // Gray color #f8f8f8
            return UIColor.init(red: 213/255, green: 213/255, blue: 213/255, alpha: 1)
        }
        else if index == 20 {
            // Gray color #f8f8f8
            return UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
        }
        else if index == 21 {
            //whiite color #FFFFFF
            return UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.7)
        }
            
        else if index == 22 {
            // background appointment color #FAFAFA
            return UIColor.init(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
        }
        else if index == 23 {
            // primary color #157FAA
            return UIColor.init(red: 21/255, green: 127/255, blue: 170/255, alpha: 1.0)
        }
            
        else if index == 24 {
            // secondary color #015070
            return UIColor.init(red: 1/255, green: 80/255, blue: 112/255, alpha: 1.0)
        }
        else if index == 25 {
            // secondary color #014E6E
            return UIColor.init(red: 1/255, green: 78/255, blue: 110/255, alpha: 1.0)
        }
        else if index == 26 {
            // secondary color #777777
            return UIColor.init(red: 119/255, green: 119/255, blue: 119/255, alpha: 1.0)
        }
            
        else if index == 27 {
            // secondary color #e5e5e5
            return UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0)
        }
            
        else if index == 28 {
            // secondary color #626262
            return UIColor.init(red: 98/255, green: 98/255, blue: 98/255, alpha: 1.0)
        }
        else if index == 29 {
            // secondary color ##535353
            return UIColor.init(red: 83/255, green: 83/255, blue: 83/255, alpha: 1.0)
        }
        else if index == 30 {
            // secondary color #f2fbff
            return UIColor.init(red: 242/255, green: 251/255, blue: 255/255, alpha: 1.0)
        }
        else if index == 31 {
            // secondary color #151515
            return UIColor.init(red: 21/255, green: 21/255, blue: 21/255, alpha: 1.0)
        }
            
        else if index == 32 {
            // secondary color #adadad
            return UIColor.init(red: 173/255, green: 173/255, blue: 173/255, alpha: 1.0)
        }
        else if index == 33 {
            // secondary color #ee4c3c
            return UIColor.init(red: 238/255, green: 76/255, blue: 60/255, alpha: 1.0)
        }
        else if index == 34 {
            // secondary color #363636
            return UIColor.init(red: 54/255, green: 54/255, blue: 54/255, alpha: 1.0)
        }
        
        else if index == 35 {
                   // secondary color #2a363b
            return UIColor.init(red: 43/255, green: 45/255, blue: 47/255, alpha: 1)
               }
        
        else if index == 36 {
               // secondary color #6a6a6a
        return UIColor.init(red: 106/255, green: 106/255, blue: 106/255, alpha: 1)
           }
        else if index == 37 {
               // secondary color #4e4e4e
        return UIColor.init(red: 76/255, green: 76/255, blue: 76/255, alpha: 1)
           }
        else if index == 38 {
            // secondary color #383838
            return UIColor.init(red: 56/255, green: 56/255, blue: 56/255, alpha: 1.0)
        }
        else if index == 39 {
            // secondary color #5f5f5f
            return UIColor.init(red: 95/255, green: 95/255, blue: 95/255, alpha: 1.0)
        }
        else if index == 40 {
                   // secondary color #2b2b2b
                   return UIColor.init(red: 43/255, green: 43/255, blue: 43/255, alpha: 1.0)
               }

        else if index == 41 {
                   // background appointment color #F8FAF8A8
                   return UIColor.init(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
               }
        else if index == 42 {
                          // background appointment color #444444
                          return UIColor.init(red: 68/255, green: 68/255, blue: 68/255, alpha: 1.0)
                      }
        else if index == 43 {
            // background appointment color #1f1f1f
            return UIColor.init(red: 31/255, green: 31/255, blue: 31/255, alpha: 1.0)
        }
        else if index == 44 {
            // background appointment color #1f1f1f
            return UIColor.init(red: 223/255, green: 223/255, blue: 223/255, alpha: 1.0)
        }
        else if index == 45 {
            // background appointment color #62b2d4
            return UIColor.init(red: 98/255, green: 178/255, blue: 212/255, alpha: 1.0)
        }
        else if index == 46 {
            // background appointment color #e8e8e8
            return UIColor.init(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0)
        }
        else if index == 47 {
                   // background appointment color #a9d0e0
                   return UIColor.init(red: 169/255, green: 208/255, blue: 224/255, alpha: 1.0)
               }
        else if index == 48 {
            // background appointment color #f7f7f7
            return UIColor.init(red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0)
        }
        else if index == 49 {
            // background appointment color #f0f0f0
            return UIColor.init(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        }
        else if index == 50 {
            // background appointment color #AFAEAE
            return UIColor.init(red: 175/255, green: 174/255, blue: 174/255, alpha: 1.0)
        }
        
        else if index == 51 {
                   // background appointment color #36987c
                   return UIColor.init(red: 54/255, green: 152/255, blue: 124/255, alpha: 1.0)
               }
        
    else if index == 52 {
                     // background appointment color #797979
                     return UIColor.init(red: 121/255, green: 121/255, blue: 121/255, alpha: 1.0)
                 }
        
        else if index == 53 {
            return UIColor.init(red: 34/255, green: 34/255, blue: 34/255, alpha: 1.0)
        }
        else if index == 54 {
            return UIColor.init(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0)
        }
        else if index == 55 {
            return UIColor.init(red: 214/255, green: 243/255, blue: 255/255, alpha: 1.0)
        }
        else if index == 56 {
            return UIColor.init(red: 255/255, green: 251/255, blue: 224/255, alpha: 1.0)
        }
        else if index == 57 {
            return UIColor.init(red: 227/255, green: 93/255, blue: 93/255, alpha: 1.0)
        }
        else if index == 58 {
            return UIColor.init(red: 5/255, green: 145/255, blue: 102/255, alpha: 1.0)
        }
        else if index == 59 {
            return UIColor.init(red: 57/255, green: 57/255, blue: 57/255, alpha: 1.0)
        }
        
        else if index == 60 {
            //yellow
            return UIColor.init(red: 250/255, green: 183/255, blue: 30/255, alpha: 1.0)
        }
        else if index == 61 {
            //yellow
            return UIColor.init(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0)
        }
        else if index == 62 {
            //yellow
            return UIColor.init(red: 0/255, green: 13/255, blue: 18/255, alpha: 1.0)
        }
        return UIColor.clear
    }
}
