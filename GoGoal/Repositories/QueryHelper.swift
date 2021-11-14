//
//  QueryHelper.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/18/21.
//

import FirebaseFirestore

enum QueryOperator {
  case lessThan
  case lessThanOrEqual
  case moreThan
  case moreThanOrEqual
  case equal
  case notEqual
  case isIn
  case isNotIn
  case arrayContain
}

struct QueryCondition {
  let field: String
  let predicate: QueryOperator
  let value: Any
}

struct OrderCondition {
  let field: String
  let descending: Bool
}

extension Query {
  
  func applyQuery(_ condition: QueryCondition) -> Query {
    switch condition.predicate {
      case .lessThan:
        return self.whereField(condition.field, isLessThan: condition.value)
      case .lessThanOrEqual:
        return self.whereField(condition.field, isLessThanOrEqualTo: condition.value)
      case .moreThan:
        return self.whereField(condition.field, isGreaterThan: condition.value)
      case .moreThanOrEqual:
        return self.whereField(condition.field, isGreaterThanOrEqualTo: condition.value)
      case .equal:
        return self.whereField(condition.field, isEqualTo: condition.value)
      case .notEqual:
        return self.whereField(condition.field, isNotEqualTo: condition.value)
      case .isIn:
        return self.whereField(condition.field, in: condition.value as! [Any])
      case .isNotIn:
        return self.whereField(condition.field, notIn: condition.value as! [Any])
      case .arrayContain:
        return self.whereField(condition.field, arrayContains: condition.value)
    }
  }
  
  func applyOrder(_ condition: OrderCondition) -> Query {
    return self.order(by: condition.field, descending: condition.descending)
  }
  
  func applyLimit(_ limit: Int) -> Query {
    return self.limit(to: limit)
  }
  
}
