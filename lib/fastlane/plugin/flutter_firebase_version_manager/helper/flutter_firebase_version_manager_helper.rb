require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?(:UI)

  module Helper
    class FlutterFirebaseVersionManagerHelper
      # class methods that you define here become available in your action
      # as `Helper::FlutterFirebaseVersionManagerHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the flutter_firebase_version_manager plugin helper!")
      end
    end
  end
end
