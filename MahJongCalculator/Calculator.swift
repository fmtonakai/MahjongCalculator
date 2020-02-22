//
//  Calculator.swift
//  MahJongCalculator
//
//  Created by Fuke Masaki on 2020/02/13.
//  Copyright © 2020 Fuke Masaki. All rights reserved.
//

import Foundation

struct PaymentCalculator {
    enum Role: Int, CustomStringConvertible {
        case parent = 3, child = 2
        
        fileprivate var multipleScore: Int {
            rawValue
        }

        var description: String {
            switch self {
            case .parent: return "親"
            case .child: return "子"
            }
        }
    }

    enum Payment: CustomStringConvertible {
        case all(Int)
        case normal(parent: Int, child: Int)
        case direct(Int)

        var description: String {
            switch self {
            case let .all(score): return "\(score)点 オール"
            case let .normal(parent: parent, child: child): return "親: \(parent)点, 子: \(child)点"
            case let .direct(score): return "\(score)の支払い"
            }
        }
    }
    var han: Int
    var fu: Int
    var role: Role
    var counters: Int

    private var basePoint: Int {
        switch han {
        case 13... : return 16000 * role.multipleScore
        case 11..<13: return 12000 * role.multipleScore
        case 8..<11: return 8000 * role.multipleScore
        case 6..<8: return 6000 * role.multipleScore
        case 5: return 4000 * role.multipleScore
        default: return lowerPoint
        }
    }

    private var lowerPoint: Int {
        let score = fu * (2 << (han + 2)) * role.multipleScore
        return min(4000 * role.multipleScore, integral(score: score))
    }

    private func integral(score: Int) -> Int {
        Int(ceil(Double(score) / 100) * 100)
    }

    var paymentForRon: Payment {
        return .direct(integral(score: basePoint) + 300 * counters)
    }

    var paymentForTsumo: Payment {
        switch role {
        case .parent: return .all(integral(score: basePoint / 3) + 100 * counters)
        case .child: return .normal(parent: integral(score: basePoint / 2) + 100 * counters,
                                    child: integral(score: basePoint / 4) + 100 * counters)
        }
    }
}

struct FuCalculator {
    static let `default` = FuCalculator(exceptionType: .none,
                                        winningType: .tsumo,
                                        headType: .numbers,
                                        waitingType: .ryanmenOrShabo,
                                        sets: [.init(type: .shuntsu, isSecret: true, isEdgeOrCharactors: false),
                                               .init(type: .shuntsu, isSecret: true, isEdgeOrCharactors: false),
                                               .init(type: .shuntsu, isSecret: true, isEdgeOrCharactors: false),
                                               .init(type: .shuntsu, isSecret: true, isEdgeOrCharactors: false)])
    
    var exceptionType: ExceptionType
    var winningType: WinningType
    var headType: HeadType
    var waitingType: WaitingType
    var sets: [JongSet]
    
    private var isPinfuTsumo: Bool {
        winningType == .tsumo && headType == .numbers && waitingType.score == 0 && sets.reduce(0, {$0 + $1.score}) == 0
    }
    
    var score: Int {
        guard sets.count == 4 else { return 0 }
        switch exceptionType {
        case .pinfuTsumo: return 20
        case .chitoitsu: return 25
        default:
            let baseScore = winningType.score + headType.score + waitingType.score + sets.reduce(0, {$0 + $1.score}) + 20
            return max(30, min(110, Int( ceil(Double(baseScore) / 10) * 10)))
        }
    }
    
    enum ExceptionType: CaseIterable {
        case none, pinfuTsumo, chitoitsu
    }

    enum WinningType: Int, CaseIterable {
        case tsumo = 2, ron = 0, menzenRon = 10
        var score: Int { rawValue }
    }
    
    enum HeadType: Int, CaseIterable {
        case charactors = 2, numbers = 0
        var score: Int { rawValue }
    }

    struct JongSet {
        enum SetType: Int, CaseIterable {
            case shuntsu = 0, kotsu = 2, kantsu = 8
            var score: Int { rawValue }
        }
        
        var type: SetType
        var isSecret: Bool
        var isEdgeOrCharactors: Bool

        var score: Int {
            type.score * (isSecret ? 2 : 1) * (isEdgeOrCharactors ? 2 : 1)
        }
    }

    enum WaitingType: Int, CaseIterable {
        case ryanmenOrShabo = 0, others = 2
        var score: Int { rawValue }
    }
}
