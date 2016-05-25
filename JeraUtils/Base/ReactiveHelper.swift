//
//  ReactiveHelper.swift
//  Glambox
//
//  Created by Alessandro Nakamuta on 1/28/16.
//  Copyright © 2016 Glambox. All rights reserved.
//

import RxSwift
import Kingfisher

public extension ObservableType where E == NSURL? {
    public func downloadImage(placeholder placeholder: UIImage? = nil) -> Observable<UIImage?> {
        return flatMapLatest { imageURL -> Observable<UIImage?> in
            if let imageURL = imageURL {
                return Observable<UIImage?>.create({ (observer) -> Disposable in
                    observer.onNext(placeholder)
                    
                    let retrieveImageTask = KingfisherManager.sharedManager.retrieveImageWithURL(imageURL, optionsInfo: [.Transition(ImageTransition.Fade(1))], progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) in
                        if let error = error{
                            observer.onError(error)
                        }
                        
                        if let image = image{
                            observer.onNext(image)
                            observer.onCompleted()
                        }
                    })
                    return AnonymousDisposable {
                        retrieveImageTask.cancel()
                    }
                })
            }

            return Observable.just(placeholder)
        }
    }
}
