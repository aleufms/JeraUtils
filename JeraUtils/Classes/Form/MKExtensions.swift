//
//  MKExtensions.swift
//  Glambox
//
//  Created by Alessandro Nakamuta on 2/1/16.
//  Copyright © 2016 Glambox. All rights reserved.
//

import UIKit
import MK
import RxSwift

extension TextField{
    public var rx_errorText: AnyObserver<String?> {
        return AnyObserver { [weak self] event in
            MainScheduler.ensureExecutingOnScheduler()
            
            switch event {
            case .Next(let value):
                if let value = value{
                    self?.detailLabelHidden = false
                    self?.detailLabel?.text = value
                }else{
                    self?.detailLabelHidden = true
                    self?.detailLabel?.text = nil
                }
            case .Error(let error):
                self?.detailLabelHidden = false
                self?.detailLabel?.text = (error as NSError).localizedDescription
                break
            case .Completed:
                break
            }
        }
    }
}

//extension TextView{
//    public var rx_errorText: AnyObserver<String?> {
//        return AnyObserver { [weak self] event in
//            MainScheduler.ensureExecutingOnScheduler()
//            
//            switch event {
//            case .Next(let value):
//                if let value = value{
////                    self?.detailLabelHidden = false
////                    self?.detailLabel?.text = value
//                }else{
////                    self?.detailLabelHidden = true
////                    self?.detailLabel?.text = nil
//                }
//            case .Error(let error):
////                self?.detailLabelHidden = false
////                self?.detailLabel?.text = (error as NSError).localizedDescription
//                break
//            case .Completed:
//                break
//            }
//        }
//    }
//}