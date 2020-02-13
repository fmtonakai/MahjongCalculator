//
//  Calculator.swift
//  MahJongCalculator
//
//  Created by Fuke Masaki on 2020/02/13.
//  Copyright © 2020 Fuke Masaki. All rights reserved.
//

import Foundation

/// https://en.wikipedia.org/wiki/Japanese_Mahjong_scoring_rules

struct MahjongPaymentCalculator {
    enum Role: CustomStringConvertible {
        case parent, child
        fileprivate var multipleScore: Double {
            switch self {
            case .parent: return 1.5
            default: return 1.0
            }
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
            case let .all(score):
                return "\(score)点 オール"
            case let .normal(parent: parent, child: child):
                return "親: \(parent)点, 子: \(child)点"
            case let .direct(score):
                return "\(score)の支払い"
            }
        }
    }
    var han: Int
    var fu: Int
    var role: Role
    var counters: Int

    private var basePoint: Int {
        switch han {
        case 13... : return Int(32000 * role.multipleScore)
        case 11..<13: return Int(24000 * role.multipleScore)
        case 8..<11: return Int(16000 * role.multipleScore)
        case 6..<8: return Int(12000 * role.multipleScore)
        case 5: return Int(8000 * role.multipleScore)
        default: return lowerPoint
        }
    }

    private var lowerPoint: Int {
        min(Int(8000 * role.multipleScore), Int(ceil(Double(fu) * 4 * role.multipleScore * pow(2.0, Double(han + 2)) / 100) * 100))
    }

    private func integral(score: Double) -> Int {
        Int(ceil(score / 100) * 100)
    }

    var paymentForRon: Payment {
        return .direct(integral(score: (Double(basePoint))) + 300 * counters)
    }

    var paymentForTsumo: Payment {
        let point = Double(basePoint)
        switch role {
        case .parent: return .all(integral(score: point / 3) + 100 * counters)
        case .child: return .normal(parent: integral(score: point / 2) + 100 * counters,
                                    child: integral(score: point / 4) + 100 * counters)
        }
    }
}

protocol FuCalculatable {
    var score: Int { get }
}

struct FuCalculator {
    static let `default` = FuCalculator(winningType: .tsumo,
                                        headType: .numbers,
                                        waitingType: .ryanmen,
                                        sets: [.init(type: .shuntsu, isSecret: true, isEdgeOrCharactors: true),
                                               .init(type: .shuntsu, isSecret: true, isEdgeOrCharactors: false),
                                               .init(type: .shuntsu, isSecret: true, isEdgeOrCharactors: false),
                                               .init(type: .shuntsu, isSecret: true, isEdgeOrCharactors: false)])
    
    var isChiToitsu: Bool = false
    var winningType: WinningType
    var headType: HeadType
    var waitingType: WaitingType
    var sets: [JongSet]
    
    private var isPinfuTsumo: Bool {
        winningType == .tsumo && headType == .numbers && waitingType.score == 0 && sets.reduce(0, {$0 + $1.score}) == 0
    }
    
    private var winningScore: Int {
        if winningType == .tsumo { return 2 }
        let isMenzen = sets.reduce(true, { $0 && $1.isSecret})
        return isMenzen ? 10 : 0
    }

    var score: Int {
        guard !isChiToitsu else { return 25 }
        guard sets.count == 4 else { return 0 }
        guard !isPinfuTsumo else { return 20 }
        let baseScore = winningScore + headType.score + waitingType.score + sets.reduce(0, {$0 + $1.score}) + 20
        return min(110, Int( ceil(Double(baseScore) / 10) * 10))
    }

    enum WinningType {
        case tsumo, ron
    }
    
    enum HeadType: FuCalculatable {
        case charactors, numbers
        var score: Int {
            switch self {
            case .charactors: return 2
            case .numbers: return 0
            }
        }
    }

    struct JongSet: FuCalculatable {
        enum SetType {
            case shuntsu, kotsu, kantsu
            var score: Int {
                switch self {
                case .shuntsu: return 0
                case .kotsu: return 2
                case .kantsu: return 8
                }
            }
        }
        var type: SetType
        var isSecret: Bool
        var isEdgeOrCharactors: Bool

        var score: Int {
            var score = type.score
            if isSecret {
                score *= 2
            }
            if isEdgeOrCharactors {
                score *= 2
            }
            return score
        }
    }

    enum WaitingType: FuCalculatable {
        case ryanmen, shabo, penchan, kanchan, single, nobetan
        var score: Int {
            switch self {
            case .ryanmen, .shabo: return 0
            default: return 2
            }
        }
    }
}

extension FuCalculator {
    init(isChiToitsu: Bool) {
        self.init(isChiToitsu: true, winningType: .ron, headType: .numbers, waitingType: .ryanmen, sets: [])
    }
}