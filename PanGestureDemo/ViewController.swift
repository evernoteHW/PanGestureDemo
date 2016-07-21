//
//  ViewController.swift
//  PanGestureDemo
//
//  Created by WeiHu on 7/7/16.
//  Copyright © 2016 WeiHu. All rights reserved.
//

import UIKit

enum BtnType {
    case None
    case LeftUp
    case RightUp
    case LeftDown
    case RighDown
    case Center
}

class ViewController: UIViewController {
    /// private
    private var _demoView: UIView!
    private var _imageView1: UIImageView!
    private var _imageView2: UIImageView!
    private var _imageView3: UIImageView!
    private var _imageView4: UIImageView!
    
    private var layoutConstraint_left: NSLayoutConstraint!
    private var layoutConstraint_width: NSLayoutConstraint!
    private var layoutConstraint_top: NSLayoutConstraint!
    private var layoutConstraint_height: NSLayoutConstraint!
    
    private var startedPoint: CGPoint = CGPointZero
    private var btnType: BtnType = .None
    private var demoViewStartedFrame: CGRect = CGRectZero
    private var isMoveBegin: Bool = false
    
    private let maxWidth: CGFloat = 3*40
    private let maxHeight: CGFloat = 3*40
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViews()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
extension ViewController{
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let point: CGPoint = touch?.locationInView(self.view) ?? CGPointZero
        startedPoint = point
        demoViewStartedFrame = self.demoView.frame
        //最原始的位置
        
        if CGRectContainsPoint(demoView.frame, point){
            let pointFingerInView: CGPoint = touch?.locationInView(demoView) ?? CGPointZero
            if CGRectContainsPoint(CGRectMake(0, 0, 50, 50), pointFingerInView){
                btnType = .LeftUp
            }else if CGRectContainsPoint(CGRectMake(demoView.frame.size.width - 50, 0, 50, 50), pointFingerInView){
                btnType = .RightUp
            }else if CGRectContainsPoint(CGRectMake(0,  demoView.frame.size.height - 50, 50, 50), pointFingerInView){
                btnType = .LeftDown
            }else if CGRectContainsPoint(CGRectMake( demoView.frame.size.width - 50,  demoView.frame.size.height - 50, 50, 50), pointFingerInView){
                btnType = .RighDown
            }else{
                btnType = .Center
            }
        }
        
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let point: CGPoint = touch?.locationInView(self.view) ?? CGPointZero
        
        let movedWidth = point.x - startedPoint.x
        let movedHeight = point.y - startedPoint.y
        //设置最大和最小值
        //最小值 2 个按钮 宽度 + 中间间隔
        //最大值和最小值之间
            switch btnType {
            case .None:
                break
            case .LeftUp:
                //0~(self.view.width-3*40)
                layoutConstraint_left.constant = min(CGRectGetMaxX(demoViewStartedFrame) - maxWidth, max(CGRectGetMinX(demoViewStartedFrame) + movedWidth,0))
                layoutConstraint_width.constant = CGRectGetMaxX(demoViewStartedFrame) - layoutConstraint_left.constant
                
                layoutConstraint_top.constant = min(CGRectGetMaxY(demoViewStartedFrame) - maxHeight,max(CGRectGetMinY(demoViewStartedFrame) + movedHeight,0))
                layoutConstraint_height.constant = CGRectGetMaxY(demoViewStartedFrame) - layoutConstraint_top.constant
            case .RightUp:
                layoutConstraint_width.constant = min(max(CGRectGetWidth(demoViewStartedFrame) + movedWidth,maxWidth),CGRectGetWidth(self.view.frame) - layoutConstraint_left.constant)
                
                layoutConstraint_top.constant = min(CGRectGetMaxY(demoViewStartedFrame) - maxHeight,max(CGRectGetMinY(demoViewStartedFrame) + movedHeight,0))
                layoutConstraint_height.constant = CGRectGetMaxY(demoViewStartedFrame) - layoutConstraint_top.constant
            case .LeftDown:
                layoutConstraint_left.constant = min(CGRectGetMaxX(demoViewStartedFrame) - maxWidth,max(CGRectGetMinX(demoViewStartedFrame) + movedWidth,0))
                layoutConstraint_width.constant = CGRectGetMaxX(demoViewStartedFrame) - layoutConstraint_left.constant
                
                layoutConstraint_height.constant = min(CGRectGetHeight(self.view.frame) - layoutConstraint_top.constant,max(CGRectGetHeight(demoViewStartedFrame) + movedHeight,maxHeight))
            case .RighDown:
                
                layoutConstraint_width.constant = min(max(CGRectGetWidth(demoViewStartedFrame) + movedWidth,maxWidth),CGRectGetWidth(self.view.frame) - layoutConstraint_left.constant)
                layoutConstraint_height.constant = min(max(CGRectGetHeight(demoViewStartedFrame) + movedHeight,maxHeight),CGRectGetHeight(self.view.frame) - layoutConstraint_top.constant)
            case .Center:
                
                layoutConstraint_left.constant = min(max(demoViewStartedFrame.origin.x + movedWidth,0),CGRectGetWidth(self.view.frame) - CGRectGetWidth(demoViewStartedFrame))
                layoutConstraint_top.constant = min(max(demoViewStartedFrame.origin.y + movedHeight,0),CGRectGetHeight(self.view.frame) - CGRectGetHeight(demoViewStartedFrame))
            }
        
        
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        btnType = .None
    }
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        btnType = .None
    }
}
extension ViewController{
    
    private func configureViews(){
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(demoView)
        self.consraintsForSubViews();
        
    }
    // MARK: - views actions

    // MARK: - getter and setter
    
    private var demoView: UIView {
        get{
            if _demoView == nil{
                _demoView = UIView()
                _demoView.translatesAutoresizingMaskIntoConstraints = false
                _demoView.backgroundColor = UIColor.orangeColor()
//                _demoView.layer.anchorPoint = CGPointMake(1, 1)
                _demoView.addSubview(imageView1)
                _demoView.addSubview(imageView2)
                _demoView.addSubview(imageView3)
                _demoView.addSubview(imageView4)
                //_imageView1
                _demoView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[view(==40)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": _imageView1]));
                _demoView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[view(==40)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": _imageView1]))
                
                //_imageView2
                _demoView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[view(==40)]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": _imageView2]));
                _demoView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[view(==40)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": _imageView2]))
                
                //_imageView3
                _demoView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[view(==40)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": _imageView3]));
                _demoView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[view(==40)]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": _imageView3]))
                
                //_imageView4
                _demoView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[view(==40)]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": _imageView4]));
                _demoView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[view(==40)]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": _imageView4]))

            }
            return _demoView
            
        }
        set{
            _demoView = newValue
        }
    }
   
    private var imageView1: UIImageView {
        get{
            if _imageView1 == nil{
                _imageView1 = UIImageView()
                _imageView1.translatesAutoresizingMaskIntoConstraints = false
                _imageView1.backgroundColor = UIColor.redColor()
             
            }
            return _imageView1
            
        }
        set{
            _imageView1 = newValue
        }
    }
    
    private var imageView2: UIImageView {
        get{
            if _imageView2 == nil{
                _imageView2 = UIImageView()
                _imageView2.translatesAutoresizingMaskIntoConstraints = false
                _imageView2.backgroundColor = UIColor.yellowColor()
                
            }
            return _imageView2
            
        }
        set{
            _imageView2 = newValue
        }
    }
    
    private var imageView3: UIImageView {
        get{
            if _imageView3 == nil{
                _imageView3 = UIImageView()
                _imageView3.translatesAutoresizingMaskIntoConstraints = false
                _imageView3.backgroundColor = UIColor.greenColor()
                
            }
            return _imageView3
            
        }
        set{
            _imageView3 = newValue
        }
    }
    
    private var imageView4: UIImageView {
        get{
            if _imageView4 == nil{
                _imageView4 = UIImageView()
                _imageView4.translatesAutoresizingMaskIntoConstraints = false
                _imageView4.backgroundColor = UIColor.brownColor()
                
            }
            return _imageView4
            
        }
        set{
            _imageView4 = newValue
        }
    }
    // MARK: - consraintsForSubViews
    private func consraintsForSubViews() {
        //_demoView
        let arr1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-50-[view(\(CGRectGetWidth(self.view.frame) - 100))]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": _demoView])
        layoutConstraint_left = arr1.first
        layoutConstraint_width = arr1.last
        self.view.addConstraints(arr1)
        
        let arr2 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-50-[view(==150)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": _demoView]);
        layoutConstraint_top = arr2.first
        layoutConstraint_height = arr2.last
        
        self.view.addConstraints(arr2)
    }
    
}

