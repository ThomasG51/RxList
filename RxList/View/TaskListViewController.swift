//
//  TaskListViewController.swift
//  RxList
//
//  Created by Thomas George on 18/01/2023.
//

import RxCocoa
import RxSwift
import UIKit

class TaskListViewController: UIViewController {
    // MARK: - Property
    
    let cellIdentifier = "taskCellIdentifier"
    let disposeBag = DisposeBag()
    
    private var tasks = BehaviorRelay(value: [Task]())
    private var filteredTasks = [Task]()
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
    }
    
    // MARK: - IBAction

    @IBAction func prioritySelected(_ sender: UISegmentedControl) {
        let priority = Priority(rawValue: self.prioritySegmentedControl.selectedSegmentIndex - 1)
        
        filterTasks(by: priority)
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let navigationController = segue.destination as? UINavigationController,
            let addTaskViewController = navigationController.viewControllers.first as? AddTaskViewController
        else {
            fatalError("Error: Controller not found during prepare for segue")
        }
        
        addTaskViewController.taskObservable
            .subscribe { [weak self] task in
                guard let self else { return }
                
                let priority = Priority(rawValue: self.prioritySegmentedControl.selectedSegmentIndex - 1)
                
                var existingTasks = self.tasks.value
                existingTasks.append(task)
                
                self.tasks.accept(existingTasks)
                self.filterTasks(by: priority)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }.disposed(by: disposeBag)
    }
    
    // MARK: - Function
    
    // MARK: - Private Function
    
    private func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func filterTasks(by priority: Priority?) {
        if priority == nil {
            filteredTasks = tasks.value
        } else {
            tasks.map { tasks in
                tasks.filter { task in
                    task.priority == priority
                }
            }
            .subscribe { [weak self] tasks in
                self?.filteredTasks = tasks
            }
            .disposed(by: disposeBag)
        }
    }
    
    // MARK: - Objc Function
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = filteredTasks[indexPath.row].title
        return cell
    }
}
