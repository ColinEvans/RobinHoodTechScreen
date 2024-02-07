//
//  ViewController.swift
//  RobinhoodTechScreen
//
//  Created by Colin Evans on 2024-02-06.
//

import UIKit
import Combine

class ViewController: UIViewController {
  var tableView = UITableView()
  
  var viewModel: ViewModel
  private var cancellables = Set<AnyCancellable>()
  
  init(viewModel: ViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTable()
    viewModel.timerPublisher
      .autoconnect()
      .sink(receiveValue: { [weak self] _ in
        self?.viewModel.updateTime(for: self?.tableView.indexPathsForVisibleRows ?? [])
        self?.tableView.reloadData()
      }
      ).store(in: &cancellables)
  }
  
  private func configureTable() {
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.dataSource = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "timerCell")
    view.addSubview(tableView)
    
    NSLayoutConstraint.activate(
      [
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor),
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
        tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
      ]
    )
  }
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.cells.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let timerRow = viewModel.cells[indexPath.row]
    
    let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "timerCell", for: indexPath)
    tableViewCell.textLabel?.text = timerRow.currentTimeDisplayed
    
    return tableViewCell
  }
}

