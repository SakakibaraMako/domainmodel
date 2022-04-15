struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//

//enum MoneyError: Error {
//    case InvalidCurrency(desired: String)
//    case InvalidAmount(amount: Int)
//}

public struct Money {
    var amount : Int
    var currency : String
//    private let currencies = ["USD", "GBP", "EUR", "CAN"]
    
    init(amount: Int, currency: String) {
//        guard amount >= 0 else {
//            throw MoneyError.InvalidAmount(amount: amount)
//            }
//        guard currencies.contains(currency) else {
//            throw MoneyError.InvalidCurrency(desired: currency)
//        }
        self.amount = amount
        self.currency = currency
    }
    
    func convert(_ target: String) -> Money {
        let usd = toUSD()
        switch target {
        case "GBP": return usd.USDToGBP()
        case "EUR": return usd.USDToEUR()
        case "CAN": return usd.USDToCAN()
        default: return usd
        }
    }
    
    func add(_ money: Money) -> Money {
        let this = convert(money.currency)
        return Money(amount: this.amount + money.amount, currency: money.currency)
    }
    
    private func toUSD() -> Money {
        switch self.currency {
        case "GBP": return Money(amount: self.amount * 2, currency: "USD")
        case "EUR": return Money(amount: Int(self.amount * 2 / 3), currency: "USD")
        case "CAN": return Money(amount: Int(self.amount * 4 / 5), currency: "USD")
        default: return Money(amount: self.amount, currency: self.currency)
        }
    }
    
    private func USDToGBP() -> Money {
        return Money(amount: Int(self.amount / 2), currency: "GBP")
    }
    
    private func USDToEUR() -> Money {
        return Money(amount: Int(self.amount * 3 / 2), currency: "EUR")
    }
    
    private func USDToCAN() -> Money {
        return Money(amount: Int(self.amount * 5 / 4), currency: "CAN")
    }
    
}

////////////////////////////////////
// Job
//
public class Job {
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    var title: String
    var type: JobType
    
    init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }
    
    func calculateIncome(_ hour: Int) -> Int {
        switch self.type {
        case .Hourly(let hourly): return Int(hourly * Double(hour))
        case .Salary(let salary): return Int(salary)
        }
    }
    
    func raise(byAmount: Int) {
        raise(byAmount: Double(byAmount))
    }
    
    func raise(byAmount: Double) {
        switch self.type {
        case .Hourly(let hourly): self.type = .Hourly(hourly + byAmount)
        case .Salary(let salary): self.type = .Salary(salary + UInt(byAmount))
        }
    }
    
    func raise(byPercent: Double) {
        switch self.type {
        case .Hourly(let hourly): raise(byAmount: hourly * byPercent)
        case .Salary(let salary): raise(byAmount: Double(salary) * byPercent)
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    var firstName: String
    var lastName: String
    var age: Int
    var job: Job? {
        didSet {
            if age < 21 { self.job = nil }
        }
    }
    var spouse: Person? {
        didSet {
            if age < 21 { self.spouse = nil }
        }
    }
    
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    func toString() -> String{
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(String(describing: job)) spouse:\(String(describing: spouse))]"
    }
}

////////////////////////////////////
// Family
//
public class Family {
    var members: [Person]
    
    init(spouse1: Person, spouse2: Person) {
        if spouse1.spouse == nil { self.members = [] }
        if spouse2.spouse == nil { self.members = [] }
        self.members = [spouse1, spouse2]
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
    }
    
    func haveChild(_ child: Person) -> Bool{
        guard members[0].age >= 21 || members[1].age >= 21 else { return false }
        self.members.append(child)
        return true
    }
    
    func householdIncome() -> Int {
        var sum = 0
        for member in members {
            if member.job != nil {
                sum += member.job!.calculateIncome(2000)
            }
        }
        return sum
    }
    
}
