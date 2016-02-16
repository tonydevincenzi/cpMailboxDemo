//
//  MailboxViewController.swift
//  cpMailbox
//
//  Created by Anthony Devincenzi on 2/15/16.
//  Copyright © 2016 Anthony Devincenzi. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {

    @IBOutlet weak var mailScrollView: UIScrollView!
    @IBOutlet weak var messageParentView: UIView!
    @IBOutlet weak var messageView: UIImageView!
    @IBOutlet weak var iconLeftContainer: UIView!
    @IBOutlet weak var iconRightContainer: UIView!
    @IBOutlet weak var iconArchive: UIImageView!
    @IBOutlet weak var iconDelete: UIImageView!
    @IBOutlet weak var iconSnooze: UIImageView!
    @IBOutlet weak var iconLists: UIImageView!
    @IBOutlet weak var messageFeed: UIImageView!
    @IBOutlet weak var listsView: UIImageView!
    @IBOutlet weak var snoozeView: UIImageView!
    
    var messageOriginalCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mailScrollView.contentSize = CGSize(width:320, height:683)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didPanMessage(sender: UIPanGestureRecognizer) {
        let velocity = sender.velocityInView(view)
        let translation = sender.translationInView(view)
        print(translation.x)

       if sender.state == UIGestureRecognizerState.Began {
            messageOriginalCenter = messageView.center
        } else if sender.state == UIGestureRecognizerState.Changed {
            messageView.center = CGPoint(x: messageOriginalCenter.x + translation.x, y: messageOriginalCenter.y)
            var convertedScale = convertValue(translation.x, r1Min: 0, r1Max: 60, r2Min: 0.2, r2Max: 1.0)
            iconLeftContainer.transform = CGAffineTransformMakeScale(convertedScale, convertedScale)
            convertedScale = convertValue(translation.x, r1Min: 0, r1Max: -60, r2Min: 0.2, r2Max: 1.0)
            iconRightContainer.transform = CGAffineTransformMakeScale(convertedScale, convertedScale)

            if translation.x > 60 {
                iconLeftContainer.transform = CGAffineTransformMakeTranslation(translation.x - 60, 0)
            } else if translation.x < -60 {
                iconRightContainer.transform = CGAffineTransformMakeTranslation(translation.x + 60, 0)
            }
            if translation.x >= 0 && translation.x <= 60 {
               //print("Grey zone swiping from left, do nothing")
                messageParentView.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0)
                iconSnooze.hidden = true
                iconLists.hidden = true
                iconArchive.hidden = false
            } else if translation.x >= 61 && translation.x <= 160 {
                //print("Green zone, archive")
                messageParentView.backgroundColor = UIColor(red: 97/255, green: 211/255, blue: 80/255, alpha: 1.0)
                iconArchive.hidden = false
                iconDelete.hidden = true
            } else if translation.x >= 161 && translation.x <= 320  {
                //print("Red zone, delete")
                iconDelete.hidden = false
                iconArchive.hidden = true
                messageParentView.backgroundColor = UIColor(red: 228/255, green: 61/255, blue: 39/255, alpha: 1.0)
            } else if translation.x <= 0 && translation.x >= -60 {
                //print("Grey zone swiping from right, do nothing")
                messageParentView.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0)
                iconArchive.hidden = true
                iconDelete.hidden = true
                iconSnooze.hidden = false
            } else if translation.x <= -61 && translation.x >= -160 {
                //print("Yellow zone, snooze")
                messageParentView.backgroundColor = UIColor(red: 248/255, green: 204/255, blue: 40/255, alpha: 1.0)
                iconSnooze.hidden = false
                iconLists.hidden = true
            } else if translation.x <= -161 && translation.x >= -320 {
                //print("Brown zone, lists")
                messageParentView.backgroundColor = UIColor(red: 206/255, green: 150/255, blue: 98/255, alpha: 1.0)
                iconSnooze.hidden = true
                iconLists.hidden = false
        }
        
        } else if sender.state == UIGestureRecognizerState.Ended {
        
            if translation.x > 60 {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.messageView.transform = CGAffineTransformMakeTranslation(328, 0)
                    self.iconLeftContainer.transform = CGAffineTransformMakeTranslation(328, 0)
                    delay(0.0, closure: { () -> () in
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            self.messageFeed.transform = CGAffineTransformMakeTranslation(0.0,-self.messageView.frame.height)
                        })
                    })
                })
            } else if translation.x < -60 {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.messageView.transform = CGAffineTransformMakeTranslation(-328, 0)
                    self.iconRightContainer.transform = CGAffineTransformMakeTranslation(-328, 0)
                    if translation.x <= -61 && translation.x >= -160 {
                        UIView.animateWithDuration(0.2, animations: { () -> Void in
                            self.snoozeView.alpha = 1
                        })
                    } else if translation.x <= -161 && translation.x >= -320 {
                        UIView.animateWithDuration(0.2, animations: { () -> Void in
                            self.listsView.alpha = 1
                        })
                    }
                })
            } else {
                UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] , animations: { () -> Void in
                    self.messageView.center = self.messageOriginalCenter
                    }, completion: { (Bool) -> Void in
                })
                iconLeftContainer.transform = CGAffineTransformMakeTranslation(0, 0)
            }
        }
    }
    
    @IBAction func onSnoozeTap(sender: UITapGestureRecognizer) {

        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.snoozeView.alpha = 0
            self.messageFeed.transform = CGAffineTransformMakeTranslation(0.0,-self.messageView.frame.height)
        })
    }
    
    @IBAction func onListsTap(sender: UITapGestureRecognizer) {
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.listsView.alpha = 0
            self.messageFeed.transform = CGAffineTransformMakeTranslation(0.0,-self.messageView.frame.height)
        })
    }
    
    
}

