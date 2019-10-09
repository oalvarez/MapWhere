
import Foundation

public func map<A>(where p: @escaping (A) -> Bool,
                   then f: @escaping (A) -> A) -> ([A]) -> [A] {
  return {
    $0.map {
      if p($0) { return f($0) }
      else { return $0 }
    }
  }
}

var greaterThanTwenty =
  [-20, 1, 15, 25]                      //You can pass directly closures
    |> map(where: { $0 <= 20 },         //To the predicate
           then:  { abs($0) + 20 } )    //And the transformation

greaterThanTwenty
//[40, 21, 35, 25]

let predicate = { $0 <= 10 }
let transformation = { abs($0) + 10 }

let greaterThanTen =                   //Or you can pass them as variables
  map(where:predicate, then: transformation)

let sample = [1, 3, 5, 15, 19, 4] |> greaterThanTen
//[11, 13, 15, 15, 19, 14]

struct User {
  var name: String
  var distance: Int
  var invite: Bool = false
  
  var isAround: Bool {
    return distance < 10
  }
  
  init(name: String, distance: Int) {
    self.name = name
    self.distance = distance
  }
}

let users = [
  User(name: "Bob", distance: 50),
  User(name: "Brandon", distance: 5),
  User(name: "Steven", distance: 7)
]
          
//You can also use keypaths to properties of your own type as predicates

let deliver =                       //Transforms the invite property
  map(where: ^\User.isAround,       //of the users where isAround equals true
      then: set(^\.invite, true))

let getInvitedNames =
  deliver                           //Using the previous function
    >>> filter { $0.invite }        //Filters the invited ones
    >>> map { $0.name }             //Ang gets the names

let invitedNames =
  users |> getInvitedNames          //Applies the function to the array

print(invitedNames)
//["Brandon", "Steven"]
