//
//  YYError.swift
//  YikyYaky_01
//
//  Created by iljoo Chae on 7/2/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

enum YYError: LocalizedError {
  case ckError(Error)
        case couldNotUnwrap
        case unableToDeleteRecord
        case noUserLoggedIn
        
        var errorDescription: String? {
            switch self {
            case .ckError(let error):
                return error.localizedDescription
            case .couldNotUnwrap:
                return "Unable to get this Hype.. That is not very Hype"
            case .unableToDeleteRecord:
                return "Unable to delete Hype record from the cloud."
            case .noUserLoggedIn:
                return "There is no user currently logged in"
            }
        }
    }

