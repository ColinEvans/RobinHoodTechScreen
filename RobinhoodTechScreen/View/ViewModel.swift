//
//  ViewModel.swift
//  RobinhoodTechScreen
//
//  Created by Colin Evans on 2024-02-06.
//

import Foundation
import UIKit
import Combine

class ViewModel {
  var cells = [LiveCellModel]()
  var timerPublisher: Timer.TimerPublisher
  
  init() {
    for _ in (0..<50) {
      cells.append(LiveCellModel())
    }
    timerPublisher = Timer.publish(every: 0.1, on: .main, in: .default)
  }
  
  func updateTime(for indexPaths: [IndexPath]) {
    guard !indexPaths.isEmpty else { return }
    let visibleCells = cells[indexPaths[0].row..<indexPaths[indexPaths.count - 1].row]
    for cell in visibleCells {
      if let cellIndex = cells.firstIndex(where: { $0.id == cell.id }) {
        cells[cellIndex].updateTime()
      }
    }
  }
}

struct LiveCellModel: Identifiable {
  private var timeElaspedSinceLast: Double = 0.0
  var id = UUID().uuidString
  var currentTimeDisplayed: String = "0"
  
  mutating func updateTime() {
    timeElaspedSinceLast += 0.1
    currentTimeDisplayed = String(format: "%.2f", timeElaspedSinceLast)
  }
}
