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
        
        DispatchQueue.main.async {
            Observable.from(arrayOfDummyStructs)
                .subscribe(
                    onNext: {
                        d.printName($0.uid)
                },
                    onError: nil,
                    onCompleted: { print("Operations are completed") },
                    onDisposed: nil
                )
                .addDisposableTo(disposeBag)
        }
        
        print("This is finished first")
        
        
        print("***************************************************")
        print("Sends 1k objects individually")
        print("***************************************************")
        for i in 1000 ... 2000 {
            let d = DummyClass()
            DispatchQueue.main.async {
                Observable.from(optional: dummyStruct(withID: "\(i)"))
                    .subscribe(
                        onNext: {
                            d.printName($0.uid)
                    },
                        onError: nil,
                        onCompleted: { print("Operation is completed") },
                        onDisposed: nil
                    )
                    .addDisposableTo(disposeBag)
            }
            
        }
        print("This is finished first")
        
    }
    
}

