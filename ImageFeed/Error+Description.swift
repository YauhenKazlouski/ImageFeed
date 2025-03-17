//
//  Error+Description.swift
//  ImageFeed
//
//  Created by PandaPo on 17.03.25.
//

import Foundation

extension Error {
    func errorDescription() -> String {
        if let authError = self as? AuthServiceError {
            switch authError {
            case .invalidRequest:
                return "InvalidRequest - неверный запрос"
            case .networkError(let underlyingError):
                return "NetworkError - \(underlyingError.localizedDescription)"
            case .httpError(let statusCode):
                return "HTTPError - код ошибки \(statusCode)"
            case .noData:
                return "NoData - отсутствуют данные"
            case .decodingError(let decodingError):
                return "DecodingError - ошибка декодирования: \(decodingError.localizedDescription)"
            case .missingToken:
                return "MissingToken - отсутствует токен"
            }
        } else if let urlError = self as? URLError {
            return "URLError - код ошибки \(urlError.errorCode): \(urlError.localizedDescription)"
        } else {
            return "UnknownError - \(localizedDescription)"
        }
    }
}
