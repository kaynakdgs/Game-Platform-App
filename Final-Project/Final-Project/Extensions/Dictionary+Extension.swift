//
//  Dictionary+Extension.swift
//  Final-Project
//
//  Created by Doğuş  Kaynak on 4.06.2021.
//

import Foundation

extension Dictionary {
  subscript(i: Int) -> (key: Key, value: Value) {
    get {
      return self[index(startIndex, offsetBy: i)]
    }
  }
}
