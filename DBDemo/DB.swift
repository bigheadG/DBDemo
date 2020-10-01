
import Foundation
import SQLite3

class DB
{
    init()
    {
        db = sqliteDatabase()
        createTable()
    }

    let dbPath: String = "myDb.sqlite"
    var db:OpaquePointer?

    func sqliteDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS person(id INTEGER PRIMARY KEY,name TEXT,age INTEGER, data TEXT);"
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &statement, nil) == SQLITE_OK
        {
            if sqlite3_step(statement) == SQLITE_DONE
            {
                print("person table created.")
            } else {
                print("person table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(statement)
        
        //create Index
        createIdx()
    }
    
    func createIdx() {
        
        let indexString = "CREATE UNIQUE INDEX data_idx ON person(name,age);"
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, indexString, -1, &statement, nil) == SQLITE_OK
        {
            if sqlite3_step(statement) == SQLITE_DONE
            {
                print("person table created.")
            } else {
                print("person table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(statement)
    }
    
    func insert(id:Int, name:String, age:Int,data:String)
    {
        let persons = read()
        for p in persons
        {
            if p.id == id
            {
                return
            }
        }
        let statementString = "INSERT or Replace INTO person (id, name, age,data) VALUES (NULL, ?, ?,?);"
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, statementString, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_int(statement, 2, Int32(age))
            sqlite3_bind_text(statement, 3, (data as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Successfully inserted/replace row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(statement)
    }
    
    func read() -> [Person] {
        let statementString = "SELECT * FROM person;"
        var statement: OpaquePointer? = nil
        var psns : [Person] = []
        if sqlite3_prepare_v2(db, statementString, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = sqlite3_column_int(statement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                let year = sqlite3_column_int(statement, 2)
                let data = String(describing: String(cString: sqlite3_column_text(statement, 3)))
                psns.append(Person(id: Int(id), name: name, age: Int(year),data:data))
                print("Query Result:")
                print("\(id) | \(name) | \(year)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(statement)
        return psns
    }
    
    func deleteByID(id:Int) {
        let statementStirng = "DELETE FROM person WHERE id = ?;"
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, statementStirng, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(id))
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(statement)
    }
    
}
