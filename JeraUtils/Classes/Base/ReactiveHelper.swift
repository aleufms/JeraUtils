//
//  ReactiveHelper.swift
//  Glambox
//
//  Created by Alessandro Nakamuta on 1/28/16.
//  Copyright © 2016 Glambox. All rights reserved.
//

import RxSwift
import SDWebImage

extension ObservableType where E == NSURL? {
    func downloadImage(placeholder: UIImage? = nil) -> Observable<UIImage?> {
        return flatMapLatest { imageURL -> Observable<UIImage?> in
            if let imageURL = imageURL{
                return Observable<UIImage?>.create({ (observer) -> Disposable in
                    observer.onNext(placeholder)
                    
                    let downloadImageOperation = SDWebImageManager.sharedManager().downloadImageWithURL(imageURL, options: .AvoidAutoSetImage, progress: { (downloaded, total) -> Void in
//                        print("abc \(downloaded) / \(total)")
                        }, completed: { (image, error, _, _, _) -> Void in
                            if let error = error{
                                observer.onError(error)
                            }
                            
                            if let image = image{
                                observer.onNext(image)
                                observer.onCompleted()
                            }
                    })
                    
                    return AnonymousDisposable {
                        downloadImageOperation.cancel()
                    }
                })
            }
            
            return Observable.just(nil)
        }
    }
}