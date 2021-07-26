//
//  HorizontalCalender.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 10/07/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit


extension HorizontalCalender
{
    
  
    
}





enum HeaderType {
    case student
    case ER
}

protocol HorizontalCalenderDelegate {
    
}

class HorizontalCalender: UIView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var enumHeadType : HeaderType!
    var movingIndex = 0, movFwd = true
    var delegate : HorizontalCalenderDelegate?
    
    @IBOutlet weak var nslayoutConstraintViewTopHeight: NSLayoutConstraint!
    @IBOutlet weak var ViewTop: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var btnLeftDirection: UIButton!
    @IBOutlet weak var btnRightDirection: UIButton!
    
    var studentHeader = [StudentHeaderModel]()
    
    
    var timer : Timer?
    
    
    @IBAction func tappedLeftMonth(_ sender: UIButton) {
       }
       @IBAction func tappedRightMonth(_ sender: UIButton) {
       }
       @IBOutlet weak var viewCollection: UICollectionView!
   
        
    
    func customize()  {
        switch enumHeadType {
        case .student:
            studentHeader = [StudentHeaderModel]()
            invalidTimeR()
            let studentHeaaderObject1 = StudentHeaderModel.init(describtion: "Check your coach's available dates and time to request an appointment instantly", title: "Schedule an Appointment", ImageName: "header3")
            
            let studentHeaaderObject2 = StudentHeaderModel.init(describtion: "See notes and next shared by the coach after your appointment. You can also make your own notes!", title: "Notes and Next Steps", ImageName: "header1")
            
            let studentHeaaderObject = StudentHeaderModel.init(describtion: "Know your career coaches and schedule appointments with them to solve all your career-related problems!", title: "Coaching Appointments", ImageName: "header2")
            
            studentHeader.append(studentHeaaderObject)
            studentHeader.append(studentHeaaderObject1)
            studentHeader.append(studentHeaaderObject2)
            nslayoutConstraintViewTopHeight.constant = 0
            self.ViewTop.isHidden = true
            
            self.setTimer()
        case .ER:
        self.pageControl.isHidden = true
            break
        default: break
        }
        self.viewCollection.isPagingEnabled = true;
        viewCollection.reloadData();
    }
  
    
    func setTimer()  {
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            if self!.movFwd{
                self?.viewCollection.scrollToNextItem()
                self!.movingIndex = self!.movingIndex + 1
                if self!.movingIndex == 2{
                    self!.movFwd = false
                }
            }
            else{
                self?.viewCollection.scrollToPreviousItem()
                self!.movingIndex = self!.movingIndex - 1
                if self!.movingIndex == 0{
                    self!.movFwd = true
                }
            }
            
            self!.pageControl.currentPage = self!.movingIndex
        }
    }
    
    func backToBasic(){
        
        movingIndex = 0
        movFwd = true
        pageControl.currentPage = 0
    }
    
    func  invalidTimeR()  {
        timer?.invalidate()
        timer = nil;
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            return 3
            
        }
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            
            return 1
            
        }
        
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            switch enumHeadType {
            case .student:
                
                viewCollection?.register(UINib.init(nibName: "HorizontalAppointmentInfoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HorizontalAppointmentInfoCollectionViewCell")
                
                let cell = viewCollection.dequeueReusableCell(withReuseIdentifier: "HorizontalAppointmentInfoCollectionViewCell", for: indexPath) as! HorizontalAppointmentInfoCollectionViewCell
                cell.studentHeader = self.studentHeader[indexPath.row];
                cell.customization()
                
                return cell
                
            case .ER:
                
                viewCollection?.register(UINib.init(nibName: "HorizonatlDateCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HorizonatlDateCollectionViewCell")
                
                let cell = viewCollection.dequeueReusableCell(withReuseIdentifier: "HorizonatlDateCollectionViewCell", for: indexPath) as! HorizonatlDateCollectionViewCell
                
                cell.customize()
                
                return cell
                
            case .none:
                viewCollection?.register(UINib.init(nibName: "HorizonatlDateCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HorizonatlDateCollectionViewCell")
                
                let cell = viewCollection.dequeueReusableCell(withReuseIdentifier: "HorizonatlDateCollectionViewCell", for: indexPath) as! HorizonatlDateCollectionViewCell
                
                cell.customize()
                
                return cell
            }
            
            
          
            
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

        switch enumHeadType {
        case .student:
            self.layoutIfNeeded()
            return CGSize.init(width: self.frame.width, height: self.frame.height);

        case .ER: break
            return CGSize.init(width: 76, height: 80);

        default: break
            return CGSize.init(width: 76, height: 80);

        }
        
        return CGSize.init(width: 76, height: 80);


      }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        invalidTimeR()
        for cell in viewCollection.visibleCells {
            let indexPath = viewCollection.indexPath(for: cell)
            movingIndex = indexPath?.row as! Int
        }
        if self.movingIndex == 2{
            self.movFwd = false
        }
        if self.movingIndex == 0{
            self.movFwd = true
        }
        pageControl.currentPage = self.movingIndex

        
        self.setTimer()
    }


       func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
         print("1111111")
       }
       
    
    
    
    
    
    
}



extension UICollectionView {
    
    @objc func scrollToNextItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x + self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
   }

    func scrollToPreviousItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x - self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
    }

    func moveToFrame(contentOffset : CGFloat) {
        self.setContentOffset(CGPoint(x: contentOffset, y: self.contentOffset.y), animated: true)
    }
}
