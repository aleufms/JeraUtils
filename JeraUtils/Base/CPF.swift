//
//  CPF.swift
//  Glambox
//
//  Created by Alessandro Nakamuta on 2/22/16.
//  Copyright © 2016 Glambox. All rights reserved.
//

import UIKit

public class CPF {

    public class func gerarCPFValido() -> String {

        var cpf = [0, 0,0, 0,0, 0,0, 0,0, 0,0]
        var temp1 = 0, temp2 = 0

        for i in 0...8 {
            cpf[i] = (Int)(arc4random_uniform(9))
            temp1 += cpf[i] * (10 - i)
            temp2 += cpf[i] * (11 - i)
        }

        temp1 %= 11
        cpf[9] = temp1 < 2 ? 0 : 11-temp1

        temp2 += cpf[9] * 2
        temp2 %= 11
        cpf[10] = temp2 < 2 ? 0 : 11-temp2

        return "\(cpf[0])\(cpf[1])\(cpf[2]).\(cpf[3])\(cpf[4])\(cpf[5]).\(cpf[6])\(cpf[7])\(cpf[8])-\(cpf[9])\(cpf[10])"

    }

    public class func validate(cpf: String) -> Bool {

        if cpf.characters.count == 11 {

            let d1 = Int(cpf.substringWithRange(cpf.startIndex.advancedBy(9)..<cpf.startIndex.advancedBy(10)))!
            let d2 = Int(cpf.substringWithRange(cpf.startIndex.advancedBy(10)..<cpf.startIndex.advancedBy(11)))!

            var temp1 = 0, temp2 = 0

            for i in 0...8 {

                let char = Int(cpf.substringWithRange(cpf.startIndex.advancedBy(i)..<cpf.startIndex.advancedBy(i+1)))!

                temp1 += char * (10 - i)
                temp2 += char * (11 - i)
            }

            temp1 %= 11
            temp1 = temp1 < 2 ? 0 : 11-temp1

            temp2 += temp1 * 2
            temp2 %= 11
            temp2 = temp2 < 2 ? 0 : 11-temp2

            if temp1 == d1 && temp2 == d2 {
                return true
            }

        }

        return false
    }

}
