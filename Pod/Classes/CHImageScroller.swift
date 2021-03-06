//
//  ViewController.swift
//  CHImageScroller
//
//  Created by Connor on 8/15/15.
//  
//

import UIKit

public class CHImageScroller: UIView, UIScrollViewDelegate {
    
    let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
    let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    
    var scrollView: UIScrollView!
    var images: NSArray!
    var imageViews: NSMutableArray!
    var exitButton: UIButton!
    
    required public init(images: NSArray, startingIndex: Int, frame: CGRect)
    {
        super.init(frame: frame)
        self.images = images
        self.imageViews = NSMutableArray()
        
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.backgroundColor = UIColor.clearColor()
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.bounds
            blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            
            self.addSubview(blurEffectView)         }
        else {
            self.backgroundColor = UIColor.blackColor()
        }
        
        self.setupScrollView(startingIndex)
        self.alpha = 0.0
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func presentImagePreview(){
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseInOut, animations: {
            self.alpha = 1.0
            }, completion: { finished in
        })
    }
    
    func setupScrollView(startingIndex: Int){
        self.scrollView = UIScrollView(frame: CGRectMake(0, self.center.y/2, SCREEN_WIDTH, SCREEN_WIDTH))
        self.scrollView.scrollEnabled = true
        self.scrollView.maximumZoomScale = 3.0
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.pagingEnabled = true
        self.scrollView.delegate = self
        self.addSubview(self.scrollView)
        
        self.addImageViews()
        self.addGestureRecognizers()
        
        self.scrollView.contentOffset = CGPointMake(self.bounds.size.width*CGFloat(startingIndex), 0)
    }
    
    func addImageViews() {
        var imageCount = 0
        for image in self.images {
            let imageView = UIImageView(frame: CGRectMake(SCREEN_WIDTH*CGFloat(imageCount), 0, SCREEN_WIDTH, self.scrollView.frame.size.height))
            imageView.tag = imageCount
            imageView.userInteractionEnabled = true
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            imageView.image = image as? UIImage
            self.scrollView.addSubview(imageView)
            
            self.imageViews.addObject(imageView)
            self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*CGFloat(++imageCount), SCREEN_WIDTH)
        }
    }
    
    func addGestureRecognizers(){
        let tapGesture = UITapGestureRecognizer(target: self, action: "exit")
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGesture)
        
        let swipeGesture1 = UISwipeGestureRecognizer(target: self, action: "exit")
        swipeGesture1.direction = UISwipeGestureRecognizerDirection.Up
        self.addGestureRecognizer(swipeGesture1)
        
        let swipeGesture2 = UISwipeGestureRecognizer(target: self, action: "exit")
        swipeGesture2.direction = UISwipeGestureRecognizerDirection.Down
        self.addGestureRecognizer(swipeGesture2)
        
        
    }
    
    public func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        let imageIndex = scrollView.contentOffset.y/SCREEN_WIDTH
        return self.imageViews.objectAtIndex(Int(imageIndex)) as? UIView
    }
    
    func exit(){
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut, animations: {
            self.alpha = 0.0
            }, completion: { finished in
        })
    }
}

