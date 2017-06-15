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
    
    func setupConnection() {
        
        let client = TCPClient(address: "ec2-34-211-183-210.us-west-2.compute.amazonaws.com", port: 4444)
        
        switch client.connect(timeout: 10) {
        case .success:
            requestData(client: client)
        case .failure(let error):
            print(error)
        }
    }
    
    private func requestData(client: TCPClient) {
        let path = Bundle.main.path(forResource: "request", ofType: "txt")
        print("success")
        do {
            let request = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
            switch client.send(data: convertToJavaString(string: request)) {
            case .success:
                var allData:[Byte] = [];
                while (client.read(10000*10000) != nil) {
                    guard let data = client.read(10000*10000) else {
                        print("no data")
                        return
                    }
                    var dataBuf = data
                    dataBuf.removeFirst(2)
                    allData.append(contentsOf: dataBuf)
                }
                
                if let resultJSON = String(bytes: allData, encoding: .utf8) {
                    let feed: [News]? = Mapper<News>().mapArray(JSONString: resultJSON)
                    print(resultJSON)
                }
            case .failure(let error):
                print(error)
            }
        }
        catch {
            print("SAD")
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
        
        //stringLength = UInt8(CFSwapInt32HostToBig(UInt32(stringLength)))
        //        let result = String(bytesNoCopy: UnsafeMutableRawPointer(mutating: bytes), length: Int(stringLength[0]), encoding: String.Encoding.utf8, freeWhenDone: false)
        let result = NSString(bytes: bytes, length: Int(stringLength[0]), encoding: String.Encoding.utf8.rawValue)
        
        return String(describing: result)
    }
    
    //    - (NSString*) convertToNSStringFromJavaUTF8 : (NSData*) data {
    //    int length = [data length];
    //    const uint8_t *bytes = (const uint8_t *)[data bytes];
    //    if(length &lt; 2) {
    //    return nil;
    //    }
    //    // demarshall the string length
    //    uint16_t myStringLen = (bytes[0] &lt;&lt; 8) | (bytes[1]);
    //
    //    // convert from network to host endianness
    //    myStringLen = ntohs(myStringLen);
    //
    //    bytes += 2;
    //    length -= 2;
    //
    //    // make sure we actually have as much data as we say we have
    //    if(myStringLen &gt; length)
    //    myStringLen = (uint16_t)length;
    //
    //    // demarshall the string
    //    return [[[NSString alloc] initWithBytes:bytes length:myStringLen encoding:NSUTF8StringEncoding] autorelease];
    //    }
}
