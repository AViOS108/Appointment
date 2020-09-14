//
//  CalenderView.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 21/08/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit


struct CalenderModal {
    
    var strText : String?
    var StrDate : String?
    var isClickable : Bool?
    var isSelected : Bool?
    
}


protocol CalenderViewDelegate{
       func dateSelected(calenderModal : CalenderModal)
       
   }
   

class CalenderView: UIView,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout ,UIGestureRecognizerDelegate{
    
    var delegate : CalenderViewDelegate!

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var nslayoutConstraintCollectionHeight: NSLayoutConstraint!
    var pointSign : CGPoint?
    var viewControllerI : UIViewController?
    @IBOutlet weak var lblMonth: UILabel!
    var numberOFDays, firstWeekDay: Int!
    
    @IBOutlet weak var viewCollection: UICollectionView!
    
    @IBOutlet weak var btnLeft: UIButton!
    
    var calenderModalArr = [CalenderModal]()
    
    var currentIndex = 0;
  
    func customize()  {
        
        self.tag = 19682
        btnLeft.setImage(UIImage.init(named: "Left_arrow"), for: .normal)
        btnRight.setImage(UIImage.init(named: "right_arrow"), for: .normal)
        creatModalForSelectMonth()
        self.tapGesture();
        if let point = self.pointSign
        {
            self.drawArrowFromPoint()
        }
        // corner radius
        viewContainer.layer.cornerRadius = 10
        
        // border
        viewContainer.layer.borderWidth = 1.0
        viewContainer.layer.borderColor = ILColor.color(index: 27).cgColor
        
        // shadow
        viewContainer.layer.shadowColor = ILColor.color(index: 27).cgColor
        viewContainer.layer.shadowOffset = CGSize(width: 3, height: 3)
        viewContainer.layer.shadowOpacity = 0.7
        viewContainer.layer.shadowRadius = 4.0
        viewContainer.clipsToBounds = true
        viewContainer.layer.masksToBounds = true
    }
    
    func tapGesture()  {
           let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
           tap.delegate = self
           self.isUserInteractionEnabled = true
           self.addGestureRecognizer(tap)
       }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {

        viewControllerI!.dismiss(animated: false) {
          }

       }
       
       
       func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
           if touch.view?.isDescendant(of: self) == true && touch.view?.tag != 19682  {
               return false
            }
            return true
       }
    
    
    func creatModalForSelectMonth()  {
        
        let Todayformatter = DateFormatter()
        Todayformatter.dateFormat = "yyyy-MM-dd"
        let todayDate = Todayformatter.string(from: Date())
        
        
        
        calenderModalArr = [CalenderModal]()
        let dateFormatter = DateFormatter()
        let date = Date()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let comp: DateComponents = Calendar.current.dateComponents([.year, .month], from: date)
        var startOfMonth = Calendar.current.date(from: comp)!
        var dateCompStartChange = DateComponents()
        
        if currentIndex != 0
        {
            dateCompStartChange.month = currentIndex ;
            startOfMonth = Calendar.current.date(byAdding: dateCompStartChange, to: startOfMonth)!

        }
                   //print(dateFormatter.stringFromDate(startOfMonth)
        firstWeekDay = startOfMonth.get_WeekDay()
        numberOFDays = startOfMonth.get_Day()
        
       
         let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE16)
        
        let dateFormatterText = DateFormatter()
        dateFormatterText.dateFormat = "MMM yyyy"        
        UILabel.labelUIHandling(label: lblMonth, text: dateFormatterText.string(from: startOfMonth), textColor:ILColor.color(index: 28) , isBold: false, fontType: fontMedium)
        
        for str in ["S","M","T","W","T","F","S"]{
            var calenderMo = CalenderModal()
            calenderMo.isClickable = false
            calenderMo.isSelected = false
            calenderMo.strText = str
            calenderModalArr.append(calenderMo)
        }
        
        let noBlank = (firstWeekDay - 1)
        let loopCount = numberOFDays  + noBlank
        var index = 0
        var comps2 = DateComponents()

        while ( loopCount > index) {
            var calenderMo = CalenderModal()
            
            if noBlank > index{
                calenderMo.isClickable = false
                calenderMo.isSelected = false
                calenderMo.strText = ""
            }
            else{
                calenderMo.isClickable = true
                calenderMo.strText = String(index - noBlank + 1 )
                comps2.day =  (index - noBlank)
                let date = Calendar.current.date(byAdding: comps2, to: startOfMonth)!
                calenderMo.StrDate = dateFormatter.string(from: date)
                
                if todayDate == calenderMo.StrDate{
                    calenderMo.isSelected = true

                }
                else{
                    calenderMo.isSelected = false

                }
                
            }
            calenderModalArr.append(calenderMo)
            
            index = index + 1;
        }
       
        self.viewCollection.reloadData()
        
        let height = viewCollection.collectionViewLayout.collectionViewContentSize.height
        nslayoutConstraintCollectionHeight.constant = height
        self.viewCollection.reloadData()

    }
    
    
    func drawArrowFromPoint() {
        //design the path
        let path = UIBezierPath()
        path.move(to: CGPoint.init(x: abs(self.pointSign!.x) - 10 , y: 18))
        path.addLine(to: CGPoint.init(x: abs(self.pointSign!.x) , y: 0))
        path.addLine(to: CGPoint.init(x: abs(self.pointSign!.x) + 10, y: 18))
        //design path in layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1.0
        // border
        shapeLayer.borderWidth = 1.0
        shapeLayer.borderColor = ILColor.color(index: 27).cgColor

       
        self.layer.addSublayer(shapeLayer)
    }
    
    
    
    
    
    @IBOutlet weak var btnRight: UIButton!
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return calenderModalArr.count
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        viewCollection?.register(UINib.init(nibName: "CalenderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CalenderCollectionViewCell")
        
        let cell = viewCollection.dequeueReusableCell(withReuseIdentifier: "CalenderCollectionViewCell", for: indexPath) as! CalenderCollectionViewCell
        cell.delegate = self
        cell.calenderModal = self.calenderModalArr[indexPath.row];
        cell.customize()
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
     
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.viewCollection.frame.width/7, height: 40);
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    @IBAction func btnleftTapped(_ sender: UIButton) {
        currentIndex = currentIndex - 1
        creatModalForSelectMonth()

      }
    
    @IBAction func btnRightTapped(_ sender: UIButton) {
        currentIndex = currentIndex + 1
        creatModalForSelectMonth()

    }
}
extension Date {
    
   //Function Will return the number of day of the month.
        func  get_Day() -> NSInteger {
            let calendar = Calendar.current
           let range = calendar.range(of: .day, in: .month, for: self)!
           return range.count

        }
    //Will return the number day of week. like Sunday =1 , Monday = 2
    func  get_WeekDay() -> NSInteger {
        let calendar = Calendar.current
        return  calendar.component(.weekday, from: self)
    }
}

extension CalenderView:CalenderCollectionViewCellDelegate
{
    func dateSelected(calenderModal: CalenderModal) {
        
        if calenderModal.isClickable!{
            
        }
        else{
            return
        }
        let indexAlreadySelected =    self.calenderModalArr.firstIndex(where: {$0.isSelected == true})
        
        if let index = indexAlreadySelected
        {
            var calenderAlreadySelected = self.calenderModalArr[indexAlreadySelected!];
            self.calenderModalArr.remove(at: indexAlreadySelected!);
            calenderAlreadySelected.isSelected = false
            self.calenderModalArr.insert(calenderAlreadySelected, at: indexAlreadySelected!)
        }
        let indexSelected =    self.calenderModalArr.firstIndex(where: {$0.StrDate == calenderModal.StrDate})
        
        var calenderIndexSelected = self.calenderModalArr[indexSelected!];
        self.calenderModalArr.remove(at: indexSelected!);
        calenderIndexSelected.isSelected = true
        self.calenderModalArr.insert(calenderIndexSelected, at: indexSelected!)
         self.viewCollection.reloadData()
        viewControllerI!.dismiss(animated: false) {
                }
        delegate.dateSelected(calenderModal: calenderIndexSelected);
        
    }
    
    
}
