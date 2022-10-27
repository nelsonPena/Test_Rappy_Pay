//
//  Date+DateFormater.swift
//  Test_Knowledge
//
//  Created by Nelson Geovanny Pena Agudelo on 24/10/22.
//

import Foundation

extension Date {
    
    func getDateFormatter() -> DateFormatter {
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "yyyy-MM-dd"
       return dateFormatter
   }
    
    func toString() -> String {
        getDateFormatter().string(from: self)
    }
}
