//
// Created by Dipak Sisodiya on 10/06/23.
//
import Foundation
import sariska

class ConnectionManager: NSObject {

    private var emitter: (_ action: String, _ m: [String: Any?]?) -> Void

    var connection: Connection?

    init(_ emitter: @escaping (_ action: String, _ m: [String: Any?]?) -> Void) {
        self.emitter = emitter
    }

    func Release() {
        connection = nil
    }

    public func createConnection(_ dictionary: [String: Any]){
        connection = Connection.init(token: dictionary["token"] as! String,
                    roomName: dictionary["roomName"] as! String, isNightly: false)
    }

    func connect(){
        connection?.connect()
    }

    func disconnect(){
        connection?.disconnect()
    }

    func addEventListener(_ dictionary: [String: Any]){
        connection?.addEventListener(dictionary["event"] as! String, callback: { [self] in
            print("Connection Established")
            emitter(dictionary["event"] as! String, dictionary)
        })
    }
}