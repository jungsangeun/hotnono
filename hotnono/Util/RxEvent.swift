//
//  RxEvent.swift
//  hotnono
//
//  Created by jungsangeun on 2018. 8. 10..
//  Copyright © 2018년 jungsangeun. All rights reserved.
//

import Foundation
import RxSwift

class RxEvent {
    
    static let sharedInstance = RxEvent()
    
    private var dictSubject = [EventName : BehaviorSubject<Any>]()
    
    init() {
        print("Created RxEvent");
    }
    
    func sendEvent(event: EventName) {
        sendEvent(event: event, data: "")
    }
    
    func sendEvent(event: EventName, data: Any) {
        if dictSubject.keys.contains(event) {
            let subject = dictSubject[event]
            subject?.onNext(data)
        } else {
            let subject = BehaviorSubject(value: data)
            dictSubject[event] = subject
            subject.onNext(data)
        }
    }
    
    func getEvent(event: EventName, initValue: Any) -> Observable<Any> {
        if dictSubject.keys.contains(event) {
            if let subject = dictSubject[event] {
                return subject
            } else {
                let subject = BehaviorSubject(value: initValue)
                dictSubject[event] = subject
                return subject
            }
        } else {
            let subject = BehaviorSubject(value: initValue)
            dictSubject[event] = subject
            return subject
        }
    }
    
    func clear(event: EventName) {
        if dictSubject.keys.contains(event) {
            let subject = dictSubject[event]
            subject?.onCompleted()
            subject?.dispose()
            dictSubject.removeValue(forKey: event)
        }
    }
    
    func clearAll() {
        for key in dictSubject.keys {
            clear(event: key)
        }
        dictSubject.removeAll()
    }
}

enum EventName {
    case CatchAllPlayer
}
