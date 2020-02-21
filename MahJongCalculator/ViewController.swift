//
//  ViewController.swift
//  MahJongCalculator
//
//  Created by Fuke Masaki on 2020/02/13.
//  Copyright © 2020 Fuke Masaki. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    private var fuCalculator: FuCalculator = .default {
        didSet { calc.fu = fuCalculator.score }
    }
    
    private var calc = PaymentCalculator(han: 1, fu: FuCalculator.default.score, role: .parent, counters: 0) {
        didSet { updateScore() }
    }
    
    @IBOutlet weak var countersLabel: UILabel!
    @IBOutlet weak var countersStepper: UIStepper!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var winningTypeControl: UISegmentedControl!
    @IBOutlet var segmentedControls: [UISegmentedControl]!
    @IBOutlet var switchControls: [UISwitch]!
    @IBOutlet weak var hanStepper: UIStepper!
    @IBOutlet weak var hanLabel: UILabel!
    @IBOutlet weak var mentsuStackView: UIStackView!
    
    private var isMentsuEditable: Bool = true {
        didSet {
            mentsuStackView.isUserInteractionEnabled = isMentsuEditable
            mentsuStackView.alpha = isMentsuEditable ? 1 : 0.5
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateScore()
        applyDarkForNonDarkModeOS()
    }

    @IBAction private func reset(_ sender: Any) {
        calc.counters = 0
        countersStepper.value = 0
        calc.han = 1
        hanStepper.value = 1
        calc.role = .parent
        fuCalculator = .default
        segmentedControls.forEach({ $0.selectedSegmentIndex = 0 })
        switchControls.forEach({ $0.isOn = false })
        isMentsuEditable = true
    }
    
    @IBAction private func countersChanged(_ sender: UIStepper) {
        calc.counters = Int(sender.value)
    }
    
    @IBAction private func roleChanged(_ sender: UISegmentedControl) {
        calc.role = sender.selectedSegmentIndex == 0 ? .parent : .child
    }
    
    @IBAction func exceptionTypeChanged(_ sender: UISegmentedControl) {
        fuCalculator.exceptionType = FuCalculator.ExceptionType.allCases[sender.selectedSegmentIndex]
        if fuCalculator.exceptionType == .none {
            isMentsuEditable = true
            hanStepper.minimumValue = 1
        }
        else {
            calc.han = max(2, calc.han)
            hanStepper.minimumValue = 2
            hanStepper.value = Double(calc.han)
            isMentsuEditable = false
        }
        if fuCalculator.exceptionType == .pinfuTsumo {
            fuCalculator.winningType = .tsumo
            winningTypeControl.selectedSegmentIndex = 0
            (0..<winningTypeControl.numberOfSegments).forEach {
                winningTypeControl.setEnabled($0 == 0, forSegmentAt: $0)
            }
        }
        else {
            (0..<winningTypeControl.numberOfSegments).forEach {
                winningTypeControl.setEnabled(true, forSegmentAt: $0)
            }
        }
    }
    
    @IBAction private func winningTypeChanged(_ sender: UISegmentedControl) {
        fuCalculator.winningType = FuCalculator.WinningType.allCases[sender.selectedSegmentIndex]
    }
    
    @IBAction private func hanChanged(_ sender: UIStepper) {
        calc.han = Int(sender.value)
    }
    
    @IBAction private func headTypeChanged(_ sender: UISegmentedControl) {
        fuCalculator.headType = sender.selectedSegmentIndex == 0 ? .numbers : .charactors
    }
    
    @IBAction private func waitingChanged(_ sender: UISegmentedControl) {
        fuCalculator.waitingType = FuCalculator.WaitingType.allCases[sender.selectedSegmentIndex]
    }
    
    @IBAction private func setsTypeChaged(_ sender: UISegmentedControl) {
        let index = sender.tag
        fuCalculator.sets[index].type = FuCalculator.JongSet.SetType.allCases[sender.selectedSegmentIndex]
    }

    @IBAction private func secretChanged(_ sender: UISwitch) {
        let index = sender.tag
        fuCalculator.sets[index].isSecret = !sender.isOn
    }

    @IBAction private func edgeOrCharactorsChanged(_ sender: UISwitch) {
        let index = sender.tag
        fuCalculator.sets[index].isEdgeOrCharactors = sender.isOn
    }
    
    private func updateScore() {
        let payment = fuCalculator.winningType == .tsumo ? calc.paymentForTsumo : calc.paymentForRon
        scoreLabel.text = "\(calc.fu)符\(calc.han)翻 \(payment)"
        hanLabel.text = "\(calc.han)翻:"
        countersLabel.text = "\(calc.counters)本場"
    }
    
    private func applyDarkForNonDarkModeOS() {
        if #available(iOS 13, *) { return }
        navigationController?.navigationBar.barStyle = .black
        view.backgroundColor = .black
        view.tintColor = .white
        view.allViews(of: UILabel.self).forEach({ $0.textColor = .white })
    }
}

extension UIView {
    func allViews<T: UIView>(of type: T.Type) -> [T] {
        if let view = self as? T {
            return [view]
        }
        else {
            return subviews.flatMap({ $0.allViews(of: type) })
        }
        
    }
}
