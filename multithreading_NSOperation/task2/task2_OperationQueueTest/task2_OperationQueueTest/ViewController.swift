import UIKit

class ViewController: UIViewController {

    let operationQueue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        runTestCases()
    }

    func runTestCases() {
        let operationA = BlockOperation {
            print("Operation A started")
            for _ in 0..<1000000 {
                // do nothing
            }
            print("Operation A finished")
        }
        
        let operationB = BlockOperation {
            print("Operation B started")
            for _ in 0..<1000000 {
                // do nothing
            }
            print("Operation B finished")
        }
        
        let operationC = BlockOperation {
            print("Operation C started")
            for _ in 0..<1000000 {
                // do nothing
            }
            print("Operation C finished")
        }
        
        let operationD = BlockOperation {
            print("Operation D started")
            for _ in 0..<1000000 {
                // do nothing
            }
            print("Operation D finished")
        }
        
        let operationE = BlockOperation {
            print("Operation E started")
            for _ in 0..<1000000 {
                // do nothing
            }
            print("Operation E finished")
        }
        
        // case 1, allowing 6 concurent operations
//        operationQueue.maxConcurrentOperationCount = 6
        
        // case 2, changing to 2 in order to limit pararelism
//        operationQueue.maxConcurrentOperationCount = 2
        
        // case3, adding dependencies c, b
//        operationB.addDependency(operationC)
//        operationD.addDependency(operationB)
        
        // case 4, set low priority to operation a
        operationA.queuePriority = .low

        operationQueue.addOperations(
            [operationA, operationB, operationC, operationD, operationE],
            waitUntilFinished: false
        )
    }
}
