//
//  AllNewsModel.swift
//  Tidings
//
//  Created by Alex on 11/06/2017.
//  Copyright © 2017 Alexey Sobolevski. All rights reserved.
//

import Foundation
import SwiftSocket
import ObjectMapper

class AllNewsModel {
    
    public var feed : [News]?
    
    func setupConnection() {
        
        let client = TCPClient(address: "ec2-34-212-3-15.us-west-2.compute.amazonaws.com", port: 4444)
        
        switch client.connect(timeout: 10) {
        case .success:
            requestData(client: client)
        case .failure(let error):
            print(error)
        }
        client.close()
    }
    
    private func requestData(client: TCPClient) {
        let path = Bundle.main.path(forResource: "request", ofType: "txt")
        print("success")
        do {
            let request = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
            switch client.send(data: convertToJavaString(string: request)) {
            case .success:
                var resultJSON = "";
                var readInProgress = true
                while (readInProgress) {
                    if let data = client.read(1900*1) {
                        var dataFoo = data
                        dataFoo.removeFirst(2)
                        if let result = String(bytes: dataFoo, encoding: .utf8) {
                            resultJSON += result
                        }
                    } else {
                        readInProgress = false
                    }
                }
                feed = Mapper<Feed>().map(JSONString: resultJSON)?.news
            case .failure(let error):
                print(error)
            }
        }
        catch {
        }
    }
    
    private func convertToJavaString(string: String) -> Data {
        let len = string.lengthOfBytes(using: String.Encoding.utf8)
        var buffer = [Byte]()
        buffer.append((Byte(0xff & (len >> 8))))
        buffer.append((Byte(0xff & len)))
        var outData = Data.init(capacity: 2)
        outData.append(buffer, count: 2)
        outData.append(string.data(using: String.Encoding.utf8)!)
        return outData
    }
    
    private func convertFromJavaString(data: [Byte]) -> String? {
        let length = data.count
        let bytes = data
        
        if (length < 2) {
            return nil
        }
        
        var stringLength = [(bytes[0] << 7) | (bytes[1])]
    
        let result = NSString(bytes: bytes, length: Int(stringLength[0]), encoding: String.Encoding.utf8.rawValue)
        
        return String(describing: result)
    }
}
