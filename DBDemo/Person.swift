
import Foundation

class Person
{
    var data: String = ""
    var name: String = ""
    var age: Int = 0
    var id: Int = 0
    
    init(id:Int, name:String, age:Int, data:String)
    {
        self.id = id
        self.name = name
        self.age = age
        self.data = data
    }
    
}
