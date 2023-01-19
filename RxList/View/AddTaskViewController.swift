//
//  AddTaskViewController.swift
//  RxList
//
//  Created by Thomas George on 18/01/2023.
//

import RxSwift
import UIKit

class AddTaskViewController: UIViewController {
    // MARK: - Property
    
    private let taskSubject = PublishSubject<Task>()
    var taskObservable: Observable<Task> {
        return taskSubject.asObservable()
    }
    
    // MARK: - IBOutlet

    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet weak var taskTextField: UITextField!

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBAction
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard
            let priority = Priority(rawValue: prioritySegmentedControl.selectedSegmentIndex),
            let title = taskTextField.text
        else { return }
        
        let task = Task(title: title, priority: priority)
        
        taskSubject.onNext(task)
        
        dismiss(animated: true)
    }
    
    // MARK: - Navigation
    
    // MARK: - Function
    
    // MARK: - Private Function
    
    // MARK: - Objc Function
}
