//
//  StringExtension.swift
//  FriendFace
//
//  Created by Ian McDonald on 10/02/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import Foundation

extension String {
    func newLineCharacters(of string: String) -> String {
        let numOfOccurences = self.components(separatedBy: string)
        var returnString = ""
        if numOfOccurences.count == 0 { return returnString }
        for _ in 0 ..< numOfOccurences.count - 1 {
            returnString += "\n"
        }
        return returnString
    }
}
