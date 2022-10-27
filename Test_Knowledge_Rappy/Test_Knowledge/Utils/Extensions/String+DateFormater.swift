//
//  String+DateFormater.swift
//  Test_Knowledge
//
//  Created by Nelson Geovanny Pena Agudelo on 24/10/22.
//

import Foundation

extension String {
     func getDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }
    
     func toDate() -> Date{
         guard let date = getDateFormatter().date(from: self) else { return Date() }
        return date
    }
}
