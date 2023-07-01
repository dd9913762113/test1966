//
//  DBJCrypto.swift
//  DBJKit
//
//  Created by funny on 04/06/2022.
//

import CommonCrypto
import Foundation

extension String {
    var MD5: String {
        let utf8 = cString(using: .utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))

        CC_MD5(utf8, CC_LONG(utf8!.count - 1), &digest)
        return digest.reduce("") { $0 + String(format: "%02x", $1) }
    }
}

// MARK: - DBJCrytp

final class DBJCrytp {
    public typealias CCCryptorStatus = Int32
    public enum CCError: CCCryptorStatus, Error {
        case paramError = -4300
        case bufferTooSmall = -4301
        case memoryFailure = -4302
        case alignmentError = -4303
        case decodeError = -4304
        case unimplemented = -4305
        case overflow = -4306
        case rngFailure = -4307
        case unspecifiedError = -4308
        case callSequenceError = -4309
        case keySizeError = -4310
        case invalidKey = -4311

        public static var debugLevel = 1

        init(
            _ status: CCCryptorStatus,
            function: String = #function,
            file: String = #file,
            line: Int = #line)
        {
            self = CCError(rawValue: status)!
            if CCError.debugLevel > 0 {
                print("\(file):\(line): [\(function)] \(self._domain): \(self) (\(self.rawValue))")
            }
        }

        init(_ type: CCError, function: String = #function, file: String = #file, line: Int = #line) {
            self = type
            if CCError.debugLevel > 0 {
                print("\(file):\(line): [\(function)] \(self._domain): \(self) (\(self.rawValue))")
            }
        }
    }

    public typealias CCOperation = UInt32
    public enum OpMode: CCOperation {
        case encrypt = 0, decrypt
    }

    public typealias CCMode = UInt32
    public enum BlockMode: CCMode {
        case ecb = 1, cbc, cfb, ctr, f8, lrw, ofb, xts, rc4, cfb8
        var needIV: Bool {
            switch self {
            case .cbc, .cfb, .ctr, .ofb, .cfb8: return true
            default: return false
            }
        }
    }

    public typealias CCAlgorithm = UInt32
    public enum Algorithm: CCAlgorithm {
        case aes = 0, des, threeDES, cast, rc4, rc2, blowfish

        var blockSize: Int? {
            switch self {
            case .aes: return 16
            case .des: return 8
            case .threeDES: return 8
            case .cast: return 8
            case .rc2: return 8
            case .blowfish: return 8
            default: return nil
            }
        }
    }

    public typealias CCPadding = UInt32
    public enum Padding: CCPadding {
        case noPadding = 0, pkcs7Padding
    }

    public static func crypt(
        _ opMode: OpMode,
        blockMode: BlockMode,
        algorithm: Algorithm,
        padding: Padding,
        data: Data,
        key: Data,
        iv: Data) throws -> Data
    {
        if blockMode.needIV {
            guard iv.count == algorithm.blockSize else { throw CCError(.paramError) }
        }

        var cryptor: CCCryptorRef?
        
        var status = withUnsafePointers(iv, key) { ivBytes, keyBytes in
             CCCryptorCreateWithMode(
                opMode.rawValue, blockMode.rawValue,
                algorithm.rawValue, padding.rawValue,
                ivBytes, keyBytes, key.count,
                nil, 0, 0,
                CCModeOptions(kCCModeOptionCTR_BE), &cryptor)
        }

        guard status == noErr else { throw CCError(status) }

        defer { _ = CCCryptorRelease(cryptor!) }

        let needed = CCCryptorGetOutputLength(cryptor!, data.count, true)
        var result = Data(count: needed)
        let rescount = result.count
        var updateLen: size_t = 0
        status = withUnsafePointers(data, &result) { dataBytes, resultBytes in
            CCCryptorUpdate(
                cryptor!,
                dataBytes, data.count,
                resultBytes, rescount,
                &updateLen)
        }
        guard status == noErr else { throw CCError(status) }

        var finalLen: size_t = 0
        status = result.withUnsafeMutableBytes { resultBytes in
            CCCryptorFinal(
                cryptor!,
                resultBytes + updateLen,
                rescount - updateLen,
                &finalLen)
        }
        guard status == noErr else { throw CCError(status) }
        
        result.count = updateLen + finalLen
        return result
    }
}

private func withUnsafePointers<A0, A1, Result>(
    _ arg0: Data,
    _ arg1: Data,
    _ body: (
        UnsafePointer<A0>, UnsafePointer<A1>) throws -> Result) rethrows -> Result
{
    return try arg0.withUnsafeBytes { p0 in
        try arg1.withUnsafeBytes { p1 in
            try body(p0, p1)
        }
    }
}

private func withUnsafePointers<A0, A1, Result>(
    _ arg0: Data,
    _ arg1: inout Data,
    _ body: (
        UnsafePointer<A0>,
        UnsafeMutablePointer<A1>) throws -> Result) rethrows -> Result
{
    return try arg0.withUnsafeBytes { p0 in
        try arg1.withUnsafeMutableBytes { p1 in
            try body(p0, p1)
        }
    }
}
