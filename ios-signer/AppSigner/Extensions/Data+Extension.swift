//
//  Data+Extension.swift
//  iOS App Signer
//
//  Created by dd on 9/3/2023.
//  Copyright © 2023 Daniel Radtke. All rights reserved.
//

import Foundation
// MARK: - Methods
public extension Data {
    /// 转 string
    func toString(encoding: String.Encoding) -> String? {
        return String(data: self, encoding: encoding)
    }
    
    func toBytes()->[UInt8]{
        return [UInt8](self)
    }
    
    func toDict()->Dictionary<String, Any>? {
        do{
            return try JSONSerialization.jsonObject(with: self, options: .allowFragments) as? [String: Any]
        }catch{
            print(error.localizedDescription)
            return nil
        }
    }
    /// 从给定的JSON数据返回一个基础对象。
    func toObject(options: JSONSerialization.ReadingOptions = []) throws -> Any {
        return try JSONSerialization.jsonObject(with: self, options: options)
    }
    /// 指定Model类型
    func toModel<T>(_ type:T.Type) -> T? where T:Decodable {
        do {
            return try JSONDecoder().decode(type, from: self)

        } catch  let error as NSError {
            print(error)
            print("data to model error \(error.localizedDescription)")
            Log.write(error.localizedDescription)
            return nil
            
        }
    }
}

