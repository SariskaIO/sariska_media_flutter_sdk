//
// Created by Dipak Sisodiya on 10/06/23.
//
import Foundation
import sariska

class ConnectionManager: Connection {
    private var emitter: (_ action: String, _ m: [String: Any?]?) -> Void
    var connection: Connection?

    init(_ emitter: @escaping (_ action: String, _ m: [String: Any?]?) -> Void) {
        self.emitter = emitter
    }

    func Release() {
        connection = nil
    }

    @objc func createConnection(_ params: NSDictionary) {
        //connection = Connection(params["token"] as! NSString)
        connection = Connection.init(token: params["token"] as! String,
                roomName: params["roomName"] as! String, isNightly: false
        )
    }

    @objc override func connect() {
        connection?.connect()
    }

    @objc override func disconnect() {
        connection?.disconnect()
    }

    @objc func removeFeature() {
    }

}