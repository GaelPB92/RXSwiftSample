//
//  ViewController.swift
//  RXSwiftSample
//
//  Created by Gael Perez on 8/3/17.
//  Copyright © 2017 peber. All rights reserved.
//

import UIKit
import RxSwift


struct dummyStruct {
    var uid = ""
    
    init(withID uid:String){
        self.uid = uid
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Examples of SwiftRX to perform tasks on background
        
        print("***************************************************")
        print("Receives and array of 1k objects to process")
        print("***************************************************")
        
        
        let disposeBag = DisposeBag()
        var arrayOfDummyStructs = [dummyStruct]()
        
        print("Creating Array of Objects")
        for i in 0 ... 1000 {
            arrayOfDummyStructs.append(dummyStruct(withID: "\(i)"))
        }
        
        print("Array of Objects created")
        let d = DummyClass()
        
        
        let queue = SerialDispatchQueueScheduler(qos: .default)
        
        
        Observable.from(arrayOfDummyStructs)
                .observeOn(queue)
                .subscribe(
                    onNext: {
                        let value = $0.uid
                        DispatchQueue.main.async {
                            d.printName(value)
                        }
                    },
                    onError: { error in
                        print(error)
                    },
                    onCompleted: nil,
                    onDisposed: nil
                )
                .addDisposableTo(disposeBag)
        
        
        print("-----This is finished first-----")
        
        
        print("***************************************************")
        print("Sends 1k objects individually")
        print("***************************************************")
        for i in 1000 ... 2000 {
            let d = DummyClass()
            DispatchQueue.main.async {
                Observable.from(optional: dummyStruct(withID: "\(i)"))
                    .observeOn(queue)
                    .subscribe(
                        onNext: {
                            let value = $0.uid
                            DispatchQueue.main.async {
                                d.printName(value)
                            }
                        },
                        onError: nil,
                        onCompleted: nil,
                        onDisposed: nil
                    )
                    .addDisposableTo(disposeBag)
            }
            
        }
        print("-----This is finished second-----")
        
    }
    
}

