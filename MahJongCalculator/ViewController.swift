//
//  ViewController.swift
//  MahJongCalculator
//
//  Created by Fuke Masaki on 2020/02/13.
//  Copyright © 2020 Fuke Masaki. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    var han = 1 {
        didSet {
            updateScore()
            hanLabel.text = "\(han)翻:"
        }
    }
    var counters = 0 {
        didSet {
            updateScore()
            countersLabel.text = "\(counters)本場"
        }
    }
    var role: MahjongPaymentCalculator.Role = .parent {
        didSet { updateScore() }
    }
    var fuCalcurator: FuCalculator = .default {
        didSet { updateScore() }
    }
    
    @IBOutlet weak var countersLabel: UILabel!
    @IBOutlet weak var countersStepper: UIStepper!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var segmentedControls: [UISegmentedControl]!
    @IBOutlet var switchControls: [UISwitch]!
    @IBOutlet weak var hanStepper: UIStepper!
    @IBOutlet weak var hanLabel: UILabel!
    
    private var calc: MahjongPaymentCalculator {
        MahjongPaymentCalculator(han: han, fu: fuCalcurator.score, role: role, counters: counters)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateScore()
    }

    @IBAction func reset(_ sender: Any) {
        counters = 0
        countersStepper.value = 0
        han = 1
        hanStepper.value = 1
        role = .parent
        fuCalcurator = .default
        segmentedControls.forEach({ $0.selectedSegmentIndex = 0 })
        switchControls.forEach({ $0.isOn = false })
    }
    
    @IBAction func countersChanged(_ sender: UIStepper) {
        counters = Int(sender.value)
    }
    
    @IBAction func roleChanged(_ sender: UISegmentedControl) {
        role = sender.selectedSegmentIndex == 0 ? .parent : .child
    }
    @IBAction func winningTypeChanged(_ sender: UISegmentedControl) {
        fuCalcurator.winningType = sender.selectedSegmentIndex == 0 ? .tsumo : .ron
    }
    @IBAction func hanChanged(_ sender: UIStepper) {
        han = Int(sender.value)
    }
    @IBAction func headTypeChanged(_ sender: UISegmentedControl) {
        fuCalcurator.headType = sender.selectedSegmentIndex == 0 ? .numbers : .charactors
    }
    @IBAction func waitingChanged(_ sender: UISegmentedControl) {
        let result = [FuCalculator.WaitingType]([.ryanmen, .shabo, .penchan, .kanchan, .single, .nobetan])
        fuCalcurator.waitingType = result[sender.selectedSegmentIndex]
    }
    @IBAction func isChiToitsuChanged(_ sender: UISwitch) {
        fuCalcurator.isChiToitsu = sender.isOn
    }
    @IBAction func setsTypeChaged(_ sender: UISegmentedControl) {
        let index = sender.tag
        let result: [FuCalculator.JongSet.SetType] = [.shuntsu, .kotsu, .kantsu]
        fuCalcurator.sets[index].type = result[sender.selectedSegmentIndex]
    }
    @IBAction func secretChanged(_ sender: UISwitch) {
        let index = sender.tag
        fuCalcurator.sets[index].isSecret = !sender.isOn
    }
    @IBAction func edgeOrCharactorsChanged(_ sender: UISwitch) {
        let index = sender.tag
        fuCalcurator.sets[index].isEdgeOrCharactors = sender.isOn
    }
    
    private func updateScore() {
        let payment = fuCalcurator.winningType == .tsumo ? calc.paymentForTsumo : calc.paymentForRon
        scoreLabel.text = "\(han)翻\(fuCalcurator.score)符 \(payment)"
    }
}
