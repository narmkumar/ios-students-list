//
//  StudentController.swift
//  Students
//
//  Created by Ben Gohlke on 6/17/19.
//  Copyright © 2019 Lambda Inc. All rights reserved.
//

import Foundation

enum TrackType: Int {
    case none
    case iOS
    case Web
    case UX
}

enum SortOptions: Int {
    case firstName
    case lastName
}

class StudentController {
    
    private var students: [Student] = []
    
    private var persistentFileURL: URL? {
        guard let filePath = Bundle.main.path(forResource: "students", ofType: "json") else { return nil }
        return URL(fileURLWithPath: filePath)
    }
    
    func loadFromPersistentStore(completetion: @escaping ([Student]?, Error?) -> Void) {
        let bgQue = DispatchQueue(label: "studentQue", attributes: .concurrent)
        
        bgQue.async {
        let fm = FileManager.default
        guard let url = self.persistentFileURL,
            fm.fileExists(atPath: url.path) else { return }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let students = try decoder.decode([Student].self, from: data)
            self.students = students
            completetion(students, nil)
        } catch {
            print("Error loading student data: \(error)")
            completetion(nil, error)
            }
        }
    }
    
    func filter(with trackType: TrackType, sortedBy sorter: SortOptions, completion: @escaping ([Student]) -> Void) {
        var updatedStudents: [Student]
            
            switch trackType {
            case .iOS:
                updatedStudents = students.filter { $0.course == "iOS" }
            case .Web:
                updatedStudents = students.filter { $0.course == "Web" }
            case .UX:
                updatedStudents = students.filter { $0.course == "UX" }
            default:
                updatedStudents = students
            }
        if sorter == .firstName {
            updatedStudents = updatedStudents.sorted { $0.firstName < $1.firstName }
        } else {
            updatedStudents = updatedStudents.sorted { $0.lastName < $1.lastName }
        }
        
        completion(updatedStudents)
        }
}


