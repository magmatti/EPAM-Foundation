import Foundation

class Counter: @unchecked Sendable {
    private var value = 0
    private var lock = NSLock()

    func increment() {
        lock.lock()
        value += 1
        lock.unlock()
    }
    
    func getValue() -> Int {
        return value
    }
}

func runCounterTask() {
    let counter = Counter()

    let thread1 = Thread {
        for _ in 1...1000 {
            counter.increment()
        }
    }

    let thread2 = Thread {
        for _ in 1...1000 {
            counter.increment()
        }
    }

    thread1.start()
    thread2.start()

    while thread1.isExecuting || thread2.isExecuting {
        usleep(100)
    }

    print("Final counter value: \(counter.getValue()) (Expected: 2000, now its correct every time due to lock implementation)")
}

runCounterTask()
