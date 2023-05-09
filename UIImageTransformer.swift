//
//  UIImageTransformer.swift
//  LeafLog
//
//  Created by Jonathan Tipton on 5/9/23.
//

import Foundation
import UIKit

class UIImageTransformer: ValueTransformer {
    
    override func transformedValue(_ value: Any?) -> Any? {
        
        guard let images = value as? [UIImage] else { return nil }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: images, requiringSecureCoding: true)
            
            return data
        } catch {
            print("error")
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        var arr = [UIImage]()
        guard let data = value as? Data else { return arr }
        
        do {
            let images = try NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClasses: [UIImage.self], from: data) as? [UIImage]
            images?.forEach {
                arr.append($0)
            }
            return arr
        } catch {
            print("oof: \(error)")
            return arr
        }
    }
}
