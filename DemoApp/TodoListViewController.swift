//
//  TodoListViewController.swift
//  DemoApp
//
//  Created by Kenichi Yonekawa on 8/1/15.
//  Copyright (c) 2015 mog2dev. All rights reserved.
//

import UIKit
import SwiftFlux

class TodoListViewController: UITableViewController {
    let todoStore = TodoStore()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.todoStore.subscribe { () in
            self.tableView.reloadData()
        }
        ActionCreator.invoke(TodoAction.Fetch())
    }

    @IBAction func createTodo() {
        ActionCreator.invoke(TodoAction.Create(title: "New ToDo"))
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoStore.todos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell")
        cell!.textLabel!.text = self.todoStore.todos[indexPath.row].title
        return cell!
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        ActionCreator.invoke(TodoAction.Delete(index: indexPath.row))
    }
}

