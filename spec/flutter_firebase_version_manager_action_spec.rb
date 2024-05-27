describe Fastlane::Actions::FlutterFirebaseVersionManagerAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The flutter_firebase_version_manager plugin is working!")

      Fastlane::Actions::FlutterFirebaseVersionManagerAction.run(nil)
    end
  end
end
