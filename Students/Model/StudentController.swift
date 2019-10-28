//
//  StudentController.swift
//  Students
//
//  Created by Ben Gohlke on 6/17/19.
//  Copyright © 2019 Lambda Inc. All rights reserved.
//

import Foundation

class StudentController {
    
    private var persistentFileURL: URL? {
        guard let filePath = Bundle.main.path(forResource: "students", ofType: "json") else { return nil }
        return URL(fileURLWithPath: filePath)
    }
}


