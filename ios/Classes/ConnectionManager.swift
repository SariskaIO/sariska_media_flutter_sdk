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

    func release() {
        connection = nil
    }

    @objc public func createConnection(_ dictionary: [String: Any]){
        connection = Connection.init(token: dictionary["token"] as! String,
                    roomName: dictionary["roomName"] as! String, isNightly: false)
    }

    @objc func destroy(){
        connection?.disconnect()
    }

    @objc func connect(){
        connection?.connect()
    }

    @objc func disconnect(){
        connection?.disconnect()
    }

    @objc func addFeature(_ features: [String: Any]){
        connection?.addFeature(features)
    }

    @objc func removeFeature(_ features: [String: Any]){
        connection?.removeFeature(features)
    }

    @objc func addConnectionListeners(_ dictionary: [String: Any]){
        connection?.addEventListener(dictionary["event"] as! String, callback: { [self] in
            print("Connection Established")
            emitter(dictionary["event"] as! String, dictionary)
        })
    }

    @objc func setToken(token: String){
        connection?.setToken(token)
    }

    @objc func removeEventListener(event: String){
        connection?.removeEventListener(event)
    }
}