//
//  ViewController.swift
//  MahJongCalculator
//
//  Created by Fuke Masaki on 2020/02/13.
//  Copyright © 2020 Fuke Masaki. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    var fuCalcurator: FuCalculator = .default {
        didSet { calc.fu = fuCalcurator.score }
    }
    
    var calc = PaymentCalculator(han: 1, fu: FuCalculator.default.score, role: .parent, counters: 0) {
        didSet { updateScore() }
    }
    
    @IBOutlet weak var countersLabel: UILabel!
    @IBOutlet weak var countersStepper: UIStepper!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var segmentedControls: [UISegmentedControl]!
    @IBOutlet var switchControls: [UISwitch]!
    @IBOutlet weak var hanStepper: UIStepper!
    @IBOutlet weak var hanLabel: UILabel!
    
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
        fuCalcurator = .default
        segmentedControls.forEach({ $0.selectedSegmentIndex = 0 })
        switchControls.forEach({ $0.isOn = false })
    }
    
    @IBAction private func countersChanged(_ sender: UIStepper) {
        calc.counters = Int(sender.value)
    }
    
    @IBAction private func roleChanged(_ sender: UISegmentedControl) {
        calc.role = sender.selectedSegmentIndex == 0 ? .parent : .child
    }
    
    @IBAction private func winningTypeChanged(_ sender: UISegmentedControl) {
        fuCalcurator.winningType = FuCalculator.WinningType.allCases[sender.selectedSegmentIndex]
    }
    
    @IBAction private func hanChanged(_ sender: UIStepper) {
        calc.han = Int(sender.value)
    }
    
    @IBAction private func headTypeChanged(_ sender: UISegmentedControl) {
        fuCalcurator.headType = sender.selectedSegmentIndex == 0 ? .numbers : .charactors
    }
    
    @IBAction private func waitingChanged(_ sender: UISegmentedControl) {
        fuCalcurator.waitingType = FuCalculator.WaitingType.allCases[sender.selectedSegmentIndex]
    }
    
    @IBAction private func isChiToitsuChanged(_ sender: UISwitch) {
        fuCalcurator.isChiToitsu = sender.isOn
    }
    
    @IBAction private func setsTypeChaged(_ sender: UISegmentedControl) {
        let index = sender.tag
        fuCalcurator.sets[index].type = FuCalculator.JongSet.SetType.allCases[sender.selectedSegmentIndex]
    }

    @IBAction private func secretChanged(_ sender: UISwitch) {
        let index = sender.tag
        fuCalcurator.sets[index].isSecret = !sender.isOn
    }

    @IBAction private func edgeOrCharactorsChanged(_ sender: UISwitch) {
        let index = sender.tag
        fuCalcurator.sets[index].isEdgeOrCharactors = sender.isOn
    }
    
    private func updateScore() {
        let payment = fuCalcurator.winningType == .tsumo ? calc.paymentForTsumo : calc.paymentForRon
        scoreLabel.text = "\(calc.han)翻\(fuCalcurator.score)符 \(payment)"
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
