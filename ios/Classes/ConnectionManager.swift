//
// Created by Dipak Sisodiya on 10/06/23.
//
import Foundation
import sariska

class ConnectionManager: NSObject {

    var connection: Connection?

    public func createConnection(_ dictionary: [String: Any]){
        connection = Connection.init(token: dictionary["token"] as! String,
                    roomName: dictionary["roomName"] as! String, isNightly: false)
    }

    func connect(){
        //connection?.connect()
    }

    func disconnect(){
        //connection?.disconnect()
    }

    func addEventListener(_ dictionary: [String: Any]){
        print(dictionary)
    }
}