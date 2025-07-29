import UIKit

class ViewController: UIViewController {
    
    let operationQueue = OperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        testDependencyAndCancel()
//        testWithoutDependency()
    }

    func testDependencyAndCancel() {
        let operationB = BlockOperation {
            print("Operation B started")
            for _ in 0..<1000000 {
                // do nothing
            }
            print("Operation B finished")
        }
        
        let operationA = BlockOperation {
            print("Operation A started")
            operationB.cancel()
            for _ in 0..<1000000 {
                // do nothing
            }
            print("Operation A finished")
        }
        
        operationB.addDependency(operationA)
        operationQueue.addOperations([operationA, operationB], waitUntilFinished: false)
    }
    
    func testWithoutDependency() {
        let operationB = BlockOperation {
            print("Operation B started")
            for _ in 0..<1000000 {
                // do nothing
            }
            print("Operation B finished")
        }
        
        let operationA = BlockOperation {
            print("Operation A started")
            operationB.cancel()
            for _ in 0..<1000000 {
                // do nothing
            }
            print("Operation A finished")
        }
        
        operationQueue.addOperations([operationA, operationB], waitUntilFinished: false)
    }
}
