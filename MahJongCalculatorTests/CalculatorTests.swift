//
//  CalculatorTests.swift
//  MahJongCalculatorTests
//
//  Created by Fuke Masaki on 2020/02/23.
//  Copyright © 2020 Fuke Masaki. All rights reserved.
//

import XCTest
@testable import MahJongCalculator

class CalculatorTests: XCTestCase {
    
    typealias ResultSet = (han: Int, fu: Int, tsumo: PaymentCalculator.Payment, ron: PaymentCalculator.Payment)
    
    private let parentResults: [ResultSet] = [
        (1, 30, .all(500), .direct(1500)),
        (1, 40, .all(700), .direct(2000)),
        (1, 50, .all(800), .direct(2400)),
        (1, 60, .all(1000), .direct(2900)),
        (1, 70, .all(1200), .direct(3400)),
        (1, 80, .all(1300), .direct(3900)),
        (1, 90, .all(1500), .direct(4400)),
        (1, 100, .all(1600), .direct(4800)),
        (1, 110, .all(1800), .direct(5300)),
        (2, 20, .all(700), .direct(2000)),
        (2, 25, .all(800), .direct(2400)),
        (2, 30, .all(1000), .direct(2900)),
        (2, 40, .all(1300), .direct(3900)),
        (2, 50, .all(1600), .direct(4800)),
        (2, 60, .all(2000), .direct(5800)),
        (2, 70, .all(2300), .direct(6800)),
        (2, 80, .all(2600), .direct(7700)),
        (2, 90, .all(2900), .direct(8700)),
        (2, 100, .all(3200), .direct(9600)),
        (2, 110, .all(3600), .direct(10600)),
        (3, 20, .all(1300), .direct(3900)),
        (3, 25, .all(1600), .direct(4800)),
        (3, 30, .all(2000), .direct(5800)),
        (3, 40, .all(2600), .direct(7700)),
        (3, 50, .all(3200), .direct(9600)),
        (3, 60, .all(3900), .direct(11600)),
        (3, 70, .all(4000), .direct(12000)),
        (3, 80, .all(4000), .direct(12000)),
        (4, 20, .all(2600), .direct(7700)),
        (4, 25, .all(3200), .direct(9600)),
        (4, 30, .all(3900), .direct(11600)),
        (4, 40, .all(4000), .direct(12000)),
        (4, 50, .all(4000), .direct(12000)),
        (5, 30, .all(4000), .direct(12000)),
        (6, 30, .all(6000), .direct(18000)),
        (7, 30, .all(6000), .direct(18000)),
        (8, 30, .all(8000), .direct(24000)),
        (9, 30, .all(8000), .direct(24000)),
        (10, 30, .all(8000), .direct(24000)),
        (11, 30, .all(12000), .direct(36000)),
        (12, 30, .all(12000), .direct(36000)),
        (13, 30, .all(16000), .direct(48000)),
    ]
    
    private var childResults: [ResultSet] = [
        (1, 30, .normal(parent: 500, child: 300), .direct(1000)),
        (1, 40, .normal(parent: 700, child: 400), .direct(1300)),
        (1, 50, .normal(parent: 800, child: 400), .direct(1600)),
        (1, 60, .normal(parent: 1000, child: 500), .direct(2000)),
        (1, 70, .normal(parent: 1200, child: 600), .direct(2300)),
        (1, 80, .normal(parent: 1300, child: 700), .direct(2600)),
        (1, 90, .normal(parent: 1500, child: 800), .direct(2900)),
        (1, 100, .normal(parent: 1600, child: 800), .direct(3200)),
        (1, 110, .normal(parent: 1800, child: 900), .direct(3600)),
        (2, 20, .normal(parent: 700, child: 400), .direct(1300)),
        (2, 25, .normal(parent: 800, child: 400), .direct(1600)),
        (2, 30, .normal(parent: 1000, child: 500), .direct(2000)),
        (2, 40, .normal(parent: 1300, child: 700), .direct(2600)),
        (2, 50, .normal(parent: 1600, child: 800), .direct(3200)),
        (2, 60, .normal(parent: 2000, child: 1000), .direct(3900)),
        (2, 70, .normal(parent: 2300, child: 1200), .direct(4500)),
        (2, 80, .normal(parent: 2600, child: 1300), .direct(5200)),
        (2, 90, .normal(parent: 2900, child: 1500), .direct(5800)),
        (2, 100, .normal(parent: 3200, child: 1600), .direct(6400)),
        (2, 110, .normal(parent: 3600, child: 1800), .direct(7100)),
        (3, 20, .normal(parent: 1300, child: 700), .direct(2600)),
        (3, 25, .normal(parent: 1600, child: 800), .direct(3200)),
        (3, 30, .normal(parent: 2000, child: 1000), .direct(3900)),
        (3, 40, .normal(parent: 2600, child: 1300), .direct(5200)),
        (3, 50, .normal(parent: 3200, child: 1600), .direct(6400)),
        (3, 60, .normal(parent: 3900, child: 2000), .direct(7700)),
        (3, 70, .normal(parent: 4000, child: 2000), .direct(8000)),
        (3, 80, .normal(parent: 4000, child: 2000), .direct(8000)),
        (4, 20, .normal(parent: 2600, child: 1300), .direct(5200)),
        (4, 25, .normal(parent: 3200, child: 1600), .direct(6400)),
        (4, 30, .normal(parent: 3900, child: 2000), .direct(7700)),
        (4, 40, .normal(parent: 4000, child: 2000), .direct(8000)),
        (4, 50, .normal(parent: 4000, child: 2000), .direct(8000)),
        (5, 30, .normal(parent: 4000, child: 2000), .direct(8000)),
        (6, 30, .normal(parent: 6000, child: 3000), .direct(12000)),
        (7, 30, .normal(parent: 6000, child: 3000), .direct(12000)),
        (8, 30, .normal(parent: 8000, child: 4000), .direct(16000)),
        (9, 30, .normal(parent: 8000, child: 4000), .direct(16000)),
        (10, 30, .normal(parent: 8000, child: 4000), .direct(16000)),
        (11, 30, .normal(parent: 12000, child: 6000), .direct(24000)),
        (12, 30, .normal(parent: 12000, child: 6000), .direct(24000)),
        (13, 30, .normal(parent: 16000, child: 8000), .direct(32000)),
    ]
    
    func testParentResult() {
        var calc = PaymentCalculator(han: 1, fu: 30, role: .parent, counters: 0)
        parentResults.forEach {
            (calc.han, calc.fu) = ($0.han, $0.fu)
            XCTAssertEqual(calc.paymentForTsumo, $0.tsumo, "\($0.fu)符\($0.han)飜")
            XCTAssertEqual(calc.paymentForRon, $0.ron, "\($0.fu)符\($0.han)飜")
        }
    }
    
    func testChildResult() {
        var calc = PaymentCalculator(han: 1, fu: 30, role: .child, counters: 0)
        childResults.forEach {
            (calc.han, calc.fu) = ($0.han, $0.fu)
            XCTAssertEqual(calc.paymentForTsumo, $0.tsumo, "\($0.fu)符\($0.han)飜")
            XCTAssertEqual(calc.paymentForRon, $0.ron, "\($0.fu)符\($0.han)飜")
        }
    }
    
}
