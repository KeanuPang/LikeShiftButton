//
//  ViewController.swift
//  LikeShiftButton
//
//  Created by 龐誠恩 on 2020/9/14.
//  Copyright © 2020 Keanu. All rights reserved.
//

import UIKit
import Willow

struct Constants {
    static var isShifted: Bool = false
}

class ViewController: UIViewController {
    private let log = Logger(logLevels: [.all], writers: [ConsoleWriter()])

    private var longPressGesture: UILongPressGestureRecognizer?

    private lazy var shiftButton: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 2
        label.text = "Hold to\nselect items"
        label.textAlignment = .center
        label.textColor = UIColor.darkGray
        label.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.gray.cgColor

        self.view.addSubview(label)
        return label
    }()

    private lazy var targetContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.3)
        view.frame = CGRect(x: 0, y: 0, width: 800, height: 800)

        self.view.addSubview(view)
        return view
    }()

    private lazy var labelTarget1: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.text = "Target 1"
        label.textAlignment = .center
        label.textColor = UIColor.darkGray
        label.frame = CGRect(x: 0, y: 0, width: 120, height: 80)
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.systemTeal.cgColor

        self.targetContainer.addSubview(label)
        return label
    }()

    private lazy var labelTarget2: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.text = "Target 2"
        label.textAlignment = .center
        label.textColor = UIColor.darkGray
        label.frame = CGRect(x: 0, y: 0, width: 120, height: 80)
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.systemTeal.cgColor

        self.targetContainer.addSubview(label)
        return label
    }()

    private lazy var labelTarget3: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.text = "Target 3"
        label.textAlignment = .center
        label.textColor = UIColor.darkGray
        label.frame = CGRect(x: 0, y: 0, width: 120, height: 80)
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.systemTeal.cgColor

        self.targetContainer.addSubview(label)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let margin = CGFloat(40)

        let screenFrame = view.frame
        let frame = self.shiftButton.frame
        self.shiftButton.frame = CGRect(origin: CGPoint(x: 0 + margin, y: screenFrame.origin.y + screenFrame.height - margin - frame.height), size: frame.size)

        self.layoutTargets()
        self.setupGestures()
    }

    private func layoutTargets() {
        self.targetContainer.center = view.center
        let containerCenter = self.view.convert(view.center, to: self.targetContainer)

        self.labelTarget2.center = containerCenter
        self.labelTarget1.center = CGPoint(x: containerCenter.x - 200, y: containerCenter.y)
        self.labelTarget3.center = CGPoint(x: containerCenter.x + 200, y: containerCenter.y)
    }

    private func setupGestures() {
        // for shift button
        self.shiftButton.isUserInteractionEnabled = true
        self.shiftButton.gestureRecognizers?.removeAll()

        let shiftLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleShift(_:)))
        shiftLongPressGesture.minimumPressDuration = 0.1
        self.shiftButton.addGestureRecognizer(shiftLongPressGesture)

        // for targets
        self.view.gestureRecognizers?.removeAll()
        self.longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleTargets(_:)))
        self.longPressGesture?.minimumPressDuration = 0.1
        if let longPress = self.longPressGesture {
            self.targetContainer.addGestureRecognizer(longPress)
        }
    }

    @objc private func handleShift(_ recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began || recognizer.state == .changed {
            Constants.isShifted = true
        } else {
            Constants.isShifted = false
        }

        self.log.infoMessage("=== shift: \(Constants.isShifted)")
    }

    @objc private func handleTargets(_ recognizer: UILongPressGestureRecognizer) {
        guard recognizer.state == .began else { return }

        let location = recognizer.location(in: self.targetContainer)

        var hitTarget = ""
        if self.labelTarget1.frame.contains(location) {
            hitTarget = "target1"
        } else if self.labelTarget2.frame.contains(location) {
            hitTarget = "target2"
        } else if self.labelTarget3.frame.contains(location) {
            hitTarget = "target3"
        } else {
            hitTarget = "none"
        }
        self.log.infoMessage("=== target hit: \(hitTarget) \(Constants.isShifted ? ", shifted" : "")")
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
