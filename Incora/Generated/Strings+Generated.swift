// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum Strings {
    public enum Common {
        /// Processing
        public static let processing = Strings.tr("Localizable", "common.processing")
        /// Retry
        public static let retry = Strings.tr("Localizable", "common.retry")
    }

    public enum Login {
        /// Unlock Your Experience
        public static let title = Strings.tr("Localizable", "login.title")
        public enum AuthorizationFailed {
            /// Authorization didn't go through
            public static let message = Strings.tr("Localizable", "login.authorizationFailed.message")
            /// Hold on!
            public static let title = Strings.tr("Localizable", "login.authorizationFailed.title")
        }

        public enum Button {
            /// Login
            public static let login = Strings.tr("Localizable", "login.button.login")
        }

        public enum Placeholder {
            /// Password
            public static let password = Strings.tr("Localizable", "login.placeholder.password")
            /// Username
            public static let username = Strings.tr("Localizable", "login.placeholder.username")
        }
    }
}

// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Strings {
    private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
        let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
        return String(format: format, locale: Locale.current, arguments: args)
    }
}

// swiftlint:disable convenience_type
private final class BundleToken {
    static let bundle: Bundle = {
        #if SWIFT_PACKAGE
            return Bundle.module
        #else
            return Bundle(for: BundleToken.self)
        #endif
    }()
}

// swiftlint:enable convenience_type
