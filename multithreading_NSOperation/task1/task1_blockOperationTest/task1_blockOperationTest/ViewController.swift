import UIKit

class ViewController: UIViewController {
    
    let customQueue = OperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // choose which method you want to run
        
        runOnMainQueue()
        //runOnCustomQueue()
    }

    func runOnMainQueue() {
        let op = BlockOperation {
            print("Operation \"A\" started (main queue)")
            for _ in 0..<1000000 {
                // simulating work
            }
            print("Operation \"A\" finished (main queue)")
        }
        
        OperationQueue.main.addOperation(op)
    }
    
    func runOnCustomQueue() {
        let op = BlockOperation {
            print("Operation \"A\" started (custom queue)")
            for _ in 0..<1000000 {
                // simulating work
            }
            print("Operation \"A\" finished (custom queue)")
        }
        
        customQueue.addOperation(op)
    }
}
