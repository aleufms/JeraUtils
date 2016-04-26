////
////  MoyaCache.swift
////  Glambox
////
////  Created by Alessandro Nakamuta on 2/16/16.
////  Copyright © 2016 Glambox. All rights reserved.
////
//
//import Haneke
//import Moya
//import RxSwift
//
////Dummy Class wrapper to make Response implement NSCoding
//class ResponseCoding: NSObject, NSCoding{
//    var statusCode: Int
//    var data: NSData
//    var response: NSURLResponse?
//
//    override init() {
//        statusCode = 0
//        data = NSData()
//        super.init()
//    }
//
//    init(response: Response) {
//        self.statusCode = response.statusCode
//        self.data = response.data
//        self.response = response.response
//    }
//
//    required convenience init(coder decoder: NSCoder) {
//        self.init()
//        statusCode = decoder.decodeObjectForKey("statusCode") as! Int
//        data = decoder.decodeObjectForKey("data") as! NSData
//        response = decoder.decodeObjectForKey("response") as? NSURLResponse
//    }
//
//    func encodeWithCoder(coder: NSCoder) {
//        coder.encodeObject(data, forKey: "data")
//    }
//
//    func asResponse() -> Response{
//        return Response(statusCode: statusCode, data: data, response: response)
//    }
//}
//
//extension ResponseCoding : DataConvertible, DataRepresentable {
//
//    typealias Result = ResponseCoding
//
//    class func convertFromData(data: NSData) -> Result? {
//        let response = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! Result
//        return response
//    }
//
//    func asData() -> NSData! {
//        return NSKeyedArchiver.archivedDataWithRootObject(self)
//    }
//
//}
//extension Shared {
//    static var responseCache : Cache<ResponseCoding> {
//        struct Static {
//            static let name = "shared-responses"
//            static let cache = Cache<ResponseCoding>(name: name)
//        }
//        return Static.cache
//    }
//}
//
//class ResponseCache{
//    class func get<T: TargetType>(token: T) -> Observable<Response> {
//        return Observable.create {  observer in
//            ///Only cache GET requests
//            ///Commented because server only use POST
//            ///The caller have to specify if it will use cache
//            //            if token.method != .GET{
//            //                observer.onCompleted()
//            //                return NopDisposable.instance
//            //            }
//
//            let cache = Shared.responseCache.fetch(key: keyForToken(token))
//
//            cache.onSuccess { (responseCoding) in
//                observer.onNext(responseCoding.asResponse())
//                observer.onCompleted()
//            }
//
//            cache.onFailure({ (error) -> () in
//                if let error = error{
//                    observer.onError(error)
//                }else{
//                    observer.onCompleted()
//                }
//            })
//
//            return AnonymousDisposable {
//                //                cancellableToken?.cancel()
//            }
//        }
//    }
//
//    class func set<T: TargetType>(token: T, response: Response){
//        Shared.responseCache.set(value: ResponseCoding(response: response), key: keyForToken(token))
//    }
//
//    private class func keyForToken<T: TargetType>(token: T) -> String{
//        return "\(token.method.rawValue)+\(token.baseURL)+\(token.path)+\(token.parameters)"
//    }
//}
//
//extension RxMoyaProvider{
//
//    func requestWithCache(token: Target) -> Observable<Response> {
//        let cacheObservable = ResponseCache.get(token)
//        let requestObservable = request(token)
//
//
//        // Creates an observable that starts a request each time it's subscribed to.
//        return Observable.create { observer in
//            let cacheDisposable = cacheObservable.subscribeNext({ (response) -> Void in
//                observer.onNext(response)
//            })
//
//            let requestDisposable = requestObservable.subscribe({ (event) -> Void in
//                switch event{
//                case .Next(let response):
//                    ResponseCache.set(token, response: response)
//                    observer.onNext(response)
//                case .Error(let error):
//                    observer.onError(error)
//                case .Completed:
//                    observer.onCompleted()
//                }
//            })
//
//            return AnonymousDisposable {
//                cacheDisposable.dispose()
//                requestDisposable.dispose()
//            }
//        }
//    }
//}
