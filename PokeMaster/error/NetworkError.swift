//
//  NetworkError.swift
//  PokeMaster
//
//  Created by 宋睿 on 1/3/2022.
//

import Foundation

enum NetworkError: Error {
  
  // Request Error cases
  
  case invalidRequest
  case unexpectedBody
  
  // Response Error cases
  
  case httpError
  case unexpectedResponse
  case jsonParsingError
  case stringParsingError
  case unauthorized
  case forbidden
  case timeout
  
  // Others
  
  case badNetwork
  case serverResponse(HTTPStatus, Data?)
  case other(Error)
}

extension NetworkError: LocalizedError {
  var errorDescription: String? {
#if DEBUG
    return self.description
#else
    return self.debugDescription
#endif
  }
  
  var description: String {
    switch self {
    case .invalidRequest:
      return NSLocalizedString("The request could not be made. Please change and try again.", comment: "Invalid Request")
    case .unexpectedBody:
      return NSLocalizedString("There was a problem with the input. Please change and try again.", comment: "Unexpected Body")
    case .httpError:
      return NSLocalizedString("The web service returned an error.", comment: "HTTP Error")
    case .unexpectedResponse:
      return NSLocalizedString("The data returned was an unexpected response.", comment: "Unexpected Response")
    case .jsonParsingError:
      return NSLocalizedString("The json could not be parsed.", comment: "JSON Parsing Error")
    case .stringParsingError:
      return NSLocalizedString("The string could not be parsed.", comment: "String Parsing Error")
    case .unauthorized:
      return NSLocalizedString("Unauthorized, please sign in again.", comment: "Unauthorized")
    case .forbidden:
      return NSLocalizedString("You have not granted this app permission to access this data.", comment: "Forbidden")
    case .timeout:
      return NSLocalizedString("The request timed out.", comment: "Timeout")
    case .badNetwork:
      return NSLocalizedString("A network connection could not be established.", comment: "No Network")
    case .serverResponse(let status, _):
      return NSLocalizedString("The web service returned status code \(status.rawValue)", comment: "Server Response Error")
    case .other(let error):
      return NSLocalizedString("An error occured: \(error.localizedDescription)", comment: "Other Error")
    }
  }
  var debugDescription: String {
    switch self {
    case .invalidRequest:
      return NSLocalizedString("DEBUG (invalidRequest): The request could not be made. Please change and try again.", comment: "DEBUG Invalid Request")
    case .unexpectedBody:
      return NSLocalizedString("DEBUG (unexpectedBody): There was a problem with the input. Please change and try again.", comment: "DEBUG Unexpected Body")
    case .httpError:
      return NSLocalizedString("DEBUG (httpError): The web service returned an error.", comment: "DEBUG HTTP Error")
    case .unexpectedResponse:
      return NSLocalizedString("DEBUG (unexpectedResponse): The data returned was an unexpected response.", comment: "DEBUG Unexpected Response")
    case .jsonParsingError:
      return NSLocalizedString("DEBUG (jsonParsingError): The json could not be parsed.", comment: "DEBUG JSON Parsing Error")
    case .stringParsingError:
      return NSLocalizedString("DEBUG (stringParsingError): The string could not be parsed.", comment: "DEBUG String Parsing Error")
    case .unauthorized:
      return NSLocalizedString("DEBUG (unauthorized): Unauthorized, please sign in again.", comment: "DEBUG Unauthorized")
    case .forbidden:
      return NSLocalizedString("DEBUG (forbidden): You have not granted this app permission to access this data.", comment: "DEBUG Forbidden")
    case .timeout:
      return NSLocalizedString("DEBUG (timeout): The request timed out.", comment: "DEBUG Timeout")
    case .badNetwork:
      return NSLocalizedString("DEBUG (noNetwork): A network connection could not be established.", comment: "DEBUG No Network")
    case .serverResponse(let status, _):
      return NSLocalizedString("DEBUG (serverResponse): The web service returned status code \(status.rawValue)", comment: "DEBUG Server Response Error")
    case .other(let error):
      return NSLocalizedString("DEBUG (other): An error occured: \(error.localizedDescription)", comment: "DEBUG Other Error")
    }
  }
  
  var code: Int {
    switch self {
    case .unauthorized:
      return 401
    case .forbidden:
      return 403
    case .httpError:
      return 599
    case .timeout:
      return -1001
    case .badNetwork:
      return -1009
    case .serverResponse(let status, _):
      return status.rawValue
    case .other(let error as NSError):
      return error.code
    default:
      return 499
    }
  }
}

enum HTTPStatus: Int {
  case continueCode = 100
  case switchingProtocols = 101
  case processing = 102
  
  case ok = 200
  case created = 201
  case accepted = 202
  case nonAuthoritativeInformation = 203
  case noContent = 204
  case resetContent = 205
  case partialContent = 206
  case multiStatus = 207
  case alreadyReported = 208
  case imUsed = 226
  
  case multipleChoices = 300
  case movedPermanently = 301
  case found = 302
  case seeOther = 303
  case notModified = 304
  case useProxy = 305
  case switchProxy = 306
  case temporaryRedirect = 307
  case permanentRedirect = 308
  
  case badRequest = 400
  case unauthorized = 401
  case paymentRequired = 402
  case forbidden = 403
  case notFound = 404
  case methodNotAllowed = 405
  case notAcceptable = 406
  case proxyAuthenticationRequired = 407
  case requestTimeOut = 408
  case conflict = 409
  case gone = 410
  case lengthRequired = 411
  case preconditionFailed = 412
  case payloadTooLarge = 413
  case uriTooLong = 414
  case unsupportedMediaType = 415
  case rangeNotSatisfiable = 416
  case expectationFailed = 417
  case teapod = 418
  case misdirectedRequest = 421
  case unprocessableEntity = 422
  case locked = 423
  case failedDependency = 424
  case upgradeRequired = 426
  case preconditionRequired = 428
  case tooManyRequests = 429
  case requestHeaderFieldsTooLarge = 431
  case unavailableForLegalReasons = 451
  
  case internalServerError = 500
  case notImplemented = 501
  case badGateway = 502
  case serviceUnavailable = 503
  case gatewayTimeOut = 504
  case httpVersionNotSupported = 505
  case variantAlsoNegotiates = 506
  case insufficientStorage = 507
  case loopDetected = 508
  case notExtended = 510
  case networkAuthenticationRequired = 511
  
  case unknown = 999
  
  enum Category {
    case informational
    case success
    case redirection
    case clientError
    case serverError
    case unknown
  }
}

extension HTTPStatus {
  
  init(code: Int) {
    if let validStatus = HTTPStatus(rawValue: code) {
      self = validStatus
    } else {
      self = .unknown
    }
  }
  var category: Category {
    let code = self.rawValue
    if code >= 100 && code < 200 {
      return .informational
    } else if code >= 200 && code < 300 {
      return .success
    } else if code >= 300 && code < 400 {
      return .redirection
    } else if code >= 400 && code < 500 {
      return .clientError
    } else if code >= 500 && code < 600 {
      return .serverError
    } else {
      return .unknown
    }
  }
}
