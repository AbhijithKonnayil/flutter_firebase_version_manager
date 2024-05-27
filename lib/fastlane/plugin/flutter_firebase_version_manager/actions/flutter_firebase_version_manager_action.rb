require 'fastlane/action'
require_relative '../helper/flutter_firebase_version_manager_helper'

module Fastlane
  module Actions
    class FlutterFirebaseVersionManagerAction < Action
      def self.run(params)
        puts params[:firebase_cli_token]
        puts params[:app_id]
        UI.message("The flutter_firebase_version_manager plugin is working!")
        app_id=params[:app_id]
        firebase_cli_token=params[:firebase_cli_token]
        #latest_release=self.get_latest_release(firebase_cli_token,app_id)
        #puts latest_release
        #self.get_property_from_release(latest_release,:buildVersion)
        puts  "sdafasdfdfdsfasd"
        other_action.increment_flutter_version_code(pubspec_file_path:"pubspec.yaml")
      end

      def self.description
        "Flutter Firebase Version Manager will manager the build number and versions in sync with firebase app distribution"
      end

      def self.authors
        ["Abhijith K"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "later"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :app_id,
          env_name: "FIREBASEAPPDISTRO_APP",
          description: "Your app's Firebase App ID. You can find the App ID in the Firebase console, on the General Settings page",
          optional: false,
          type: String),
          FastlaneCore::ConfigItem.new(key: :firebase_cli_token,
          description: "Auth token generated using Firebase CLI's login:ci command",
          optional: true,
          type: String),
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end

      def self.get_latest_release(firebase_cli_token,app_id)
        latest_release = other_action.firebase_app_distribution_get_latest_release(
        app: app_id,
        firebase_cli_token:firebase_cli_token
        )
        latest_release
      end

      def self.get_property_from_release(release,property)
        puts release[property]
      end

    end
  end
end
