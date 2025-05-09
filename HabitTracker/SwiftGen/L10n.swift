// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// What would you like to track?
  internal static let baseScreenPrompt = L10n.tr("Localizable", "baseScreenPrompt", fallback: "What would you like to track?")
  /// Cancel
  internal static let cancelButton = L10n.tr("Localizable", "cancelButton", fallback: "Cancel")
  /// Add category
  internal static let categoryAddButton = L10n.tr("Localizable", "categoryAddButton", fallback: "Add category")
  /// Create
  internal static let categoryCreateButton = L10n.tr("Localizable", "categoryCreateButton", fallback: "Create")
  /// Enter category name
  internal static let categoryCreatePlaceholder = L10n.tr("Localizable", "categoryCreatePlaceholder", fallback: "Enter category name")
  /// New category
  internal static let categoryCreateTitle = L10n.tr("Localizable", "categoryCreateTitle", fallback: "New category")
  /// Category
  internal static let categoryLabel = L10n.tr("Localizable", "categoryLabel", fallback: "Category")
  /// Habits and events can
  /// be grouped by meaning
  internal static let categoryListDescription = L10n.tr("Localizable", "categoryListDescription", fallback: "Habits and events can\nbe grouped by meaning")
  /// No category
  internal static let categoryTitleMissing = L10n.tr("Localizable", "categoryTitleMissing", fallback: "No category")
  /// Color
  internal static let color = L10n.tr("Localizable", "color", fallback: "Color")
  /// Create tracker
  internal static let createTrackerTitle = L10n.tr("Localizable", "createTrackerTitle", fallback: "Create tracker")
  /// Done
  internal static let doneButton = L10n.tr("Localizable", "doneButton", fallback: "Done")
  /// Irregular event
  internal static let event = L10n.tr("Localizable", "event", fallback: "Irregular event")
  /// Every day
  internal static let everyDay = L10n.tr("Localizable", "everyDay", fallback: "Every day")
  /// Friday
  internal static let fridayFull = L10n.tr("Localizable", "fridayFull", fallback: "Friday")
  /// Fri
  internal static let fridayShort = L10n.tr("Localizable", "fridayShort", fallback: "Fri")
  /// Habit
  internal static let habit = L10n.tr("Localizable", "habit", fallback: "Habit")
  /// Localizable.strings (English)
  ///   HabitTracker
  /// 
  ///   Created by Василий Ханин on 08.05.2025.
  internal static let mondayFull = L10n.tr("Localizable", "mondayFull", fallback: "Monday")
  /// Mon
  internal static let mondayShort = L10n.tr("Localizable", "mondayShort", fallback: "Mon")
  /// New irregular event
  internal static let newEventButton = L10n.tr("Localizable", "newEventButton", fallback: "New irregular event")
  /// New habit
  internal static let newHabitButton = L10n.tr("Localizable", "newHabitButton", fallback: "New habit")
  /// Now that’s technology!
  internal static let onboardingButton = L10n.tr("Localizable", "onboardingButton", fallback: "Now that’s technology!")
  /// Track only what you want
  internal static let onboardingTitleBlue = L10n.tr("Localizable", "onboardingTitleBlue", fallback: "Track only what you want")
  /// Even if it’s not yoga or liters of water
  internal static let onboardingTitleRed = L10n.tr("Localizable", "onboardingTitleRed", fallback: "Even if it’s not yoga or liters of water")
  /// Saturday
  internal static let saturdayFull = L10n.tr("Localizable", "saturdayFull", fallback: "Saturday")
  /// Sat
  internal static let saturdayShort = L10n.tr("Localizable", "saturdayShort", fallback: "Sat")
  /// Schedule
  internal static let schedule = L10n.tr("Localizable", "schedule", fallback: "Schedule")
  /// Search
  internal static let search = L10n.tr("Localizable", "search", fallback: "Search")
  /// Statistics
  internal static let statistic = L10n.tr("Localizable", "statistic", fallback: "Statistics")
  /// Sunday
  internal static let sundayFull = L10n.tr("Localizable", "sundayFull", fallback: "Sunday")
  /// Sun
  internal static let sundayShort = L10n.tr("Localizable", "sundayShort", fallback: "Sun")
  /// Thursday
  internal static let thursdayFull = L10n.tr("Localizable", "thursdayFull", fallback: "Thursday")
  /// Thu
  internal static let thursdayShort = L10n.tr("Localizable", "thursdayShort", fallback: "Thu")
  /// Untitled
  internal static let trackerNameMissing = L10n.tr("Localizable", "trackerNameMissing", fallback: "Untitled")
  /// Enter tracker name
  internal static let trackerNamePlaceholder = L10n.tr("Localizable", "trackerNamePlaceholder", fallback: "Enter tracker name")
  /// Trackers
  internal static let trackers = L10n.tr("Localizable", "trackers", fallback: "Trackers")
  /// Tuesday
  internal static let tuesdayFull = L10n.tr("Localizable", "tuesdayFull", fallback: "Tuesday")
  /// Tue
  internal static let tuesdayShort = L10n.tr("Localizable", "tuesdayShort", fallback: "Tue")
  /// Wednesday
  internal static let wednesdayFull = L10n.tr("Localizable", "wednesdayFull", fallback: "Wednesday")
  /// Wed
  internal static let wednesdayShort = L10n.tr("Localizable", "wednesdayShort", fallback: "Wed")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
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
