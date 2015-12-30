//
//  CalendarViewController.swift
//  SimpleCalendarSwift
//
//  Created by Y.T. Hoshino on 2015/12/30.
//  Copyright © 2015年 Yuta Hoshino. All rights reserved.
//

import UIKit

class CalendarViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let ReuseIdentifier = "Cell"
    let DaysPerWeek = 7
    let CellMargin: CGFloat = 2.0
    var selectedDate: NSDate = NSDate() {
        willSet {
            // update title text
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy/M"
            title = formatter.stringFromDate(newValue)
        }
    }

    //MARK: - Action Methods
    @IBAction func didTapPrevButton(sender:AnyObject){
        if let newDate = selectedDate.monthAgoDate() {
            selectedDate = newDate
            collectionView?.reloadData()
        }
    }
    
    @IBAction func didTapNextButton(sender:AnyObject){
        if let newDate = selectedDate.monthLaterDate() {
            selectedDate = newDate
            collectionView?.reloadData()
        }
    }
    
    //MARK - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedDate = NSDate()
    }
    
    //MARK: - private moethods
    /// Return First date of the month
    private func firstDateOfMonth()->NSDate?{
        let components = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: selectedDate)
        components.day = 1
        let firstDateOfMonth = NSCalendar.currentCalendar().dateFromComponents(components)
        return firstDateOfMonth
    }
    
    /// Return date for specified indexPath
    private func dateForCellAtIndexPath (indexPath: NSIndexPath)->NSDate? {
        //calculate the ordinal number of first day
        let ordinalityOfFirstDay = NSCalendar.currentCalendar().ordinalityOfUnit(.Day, inUnit: .WeekOfMonth, forDate: firstDateOfMonth()!)
        
        // calculate the difference between "day number of cell at indexPath" and "day number of first day"
        let dateComponents = NSDateComponents()
        dateComponents.day = indexPath.item - (ordinalityOfFirstDay - 1)
        let date = NSCalendar.currentCalendar().dateByAddingComponents(dateComponents, toDate: firstDateOfMonth()!, options: [])
        return date
    }
    
    //MARK: - UICollectionViewDataSource methods
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // calculate number of weeks
        let rangeOfWeeks = NSCalendar.currentCalendar().rangeOfUnit(.WeekOfMonth, inUnit: .Month, forDate: firstDateOfMonth()!)
        
        let numberOfWeeks = rangeOfWeeks.length
        let numberOfItems = numberOfWeeks * DaysPerWeek
        
        return numberOfItems
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ReuseIdentifier, forIndexPath: indexPath) as! DayCell
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "d"
        cell.label.text = formatter.stringFromDate(dateForCellAtIndexPath(indexPath)!)
        
        return cell
    }
    //MARK: UICollectionViewDelegateFlowLayout methods
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let numberOfMargin = 8
        let width = floor((collectionView.frame.size.width - CellMargin * CGFloat(numberOfMargin)) / CGFloat(DaysPerWeek))
        let height = width * 1.5
        return CGSizeMake(width, height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(CellMargin, CellMargin, CellMargin, CellMargin)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CellMargin
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CellMargin
    }
}

extension NSDate {
    /// Return the date one month before the receiver.
    func monthAgoDate()->NSDate?{
        let addValue = -1
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = NSDateComponents()
        dateComponents.month = addValue
        return calendar.dateByAddingComponents(dateComponents, toDate: self, options: [])
    }
    
    /// Return the date one month after the receiver.
    func monthLaterDate()->NSDate?{
        let addValue = 1
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = NSDateComponents()
        dateComponents.month = addValue
        return calendar.dateByAddingComponents(dateComponents, toDate: self, options: [])
    }
}