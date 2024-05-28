require 'tempfile'
require 'fileutils'

module Fastlane
  module Actions
    class IncrementFlutterVersionAction < Action
      def self.run(params)
        version_code = "0"
        new_value ||= params[:value]
        constant_name ||= params[:ext_constant_name]
        pubspec_file_path ||= params[:pubspec_file_path]
        version_component ||= params[:version_component]
        version_list=nil

        if pubspec_file_path != nil
            UI.message("The increment_version_code plugin will use pubspec file at (#{pubspec_file_path})!")
            version_list = incrementVersion(pubspec_file_path, new_value, constant_name,version_component)
        else
           UI.user_error!("The pubspec file path given. Pass the `pubspec_file_path` to the action")
        end

        if version_list.length==2
          # Store the version name in the shared hash
          Actions.lane_context["VERSION_CODE"]=new_value
          UI.message("Previous Version : #{version_list[0]}")
          UI.success("☝️ Version has been changed to #{version_list[1]}")  
        else
          UI.user_error!("Impossible to find the version code with the specified properties 😭")
        end

        return new_value
      end

      def self.incrementVersion(path, new_value, constant_name,version_comp='version_code')
          if !File.file?(path)
              UI.message(" -> No file exist at path: (#{path})!")
              return -1
          end
          begin
              foundVersionCode = "false"
              new_version=nil
              old_verison=nil
              temp_file = Tempfile.new('fastlaneIncrementVersionCode')
              File.open(path, 'r') do |file|
                  file.each_line do |line|
                      if line.include? constant_name and foundVersionCode=="false"

                          UI.message(" -> line: (#{line})!")
                          old_version_name = get_version_name(line)
                          old_version_code = get_version_code(line)
                          new_version_code = old_version_code
                          new_version_name = old_version_name
                          
                        if(version_comp=='version_code')
                          new_version_code = increment_version_code(old_version_code,new_value)

                        elsif(['patch', 'major', 'minor'].include? version_comp)
                          new_version_name = increment_version_name(old_version_name,version_comp,new_value)
                        else
                          UI.message("Invalid version component.\nVersion Component must be any one of these -> version_code,  patch, minor,major")
                        end
                        new_version = "#{new_version_name}+#{new_version_code}"
                        old_verison = "#{old_version_name}+#{old_version_code}"

                        if !!(new_version_code =~ /\A[-+]?[0-9]+\z/)
                            line.replace line.sub(old_verison, new_version)
                            foundVersionCode = "true"
                        end
                        temp_file.puts line
                      else
                      temp_file.puts line
                   end
              end
              file.close
            end
            temp_file.rewind
            temp_file.close
            FileUtils.mv(temp_file.path, path)
            temp_file.unlink
          end
          if foundVersionCode == "true"
            return [old_verison,new_version]
          end
          return -1
      end

      def self.get_version_code(line)
        versionComponents = line.strip.split('+')
        return versionComponents[versionComponents.length-1].tr("\"","")
      end

      def self.increment_version_code(version,new_version_code=-1)

        if new_version_code <= 0
            new_version_code = version.to_i + 1
        end
        return new_version_code.to_s
      end


      def self.get_version_name(line)
        versionComponents_ver_string__build_no_list = line.strip.split('+')
        versionComponents_ver_key__maj_min_pat = versionComponents_ver_string__build_no_list[0].split(":")
        version_name  =  versionComponents_ver_key__maj_min_pat[versionComponents_ver_key__maj_min_pat.length-1].strip
        return version_name
      end

      def self.increment_version_name(version_name,versionComponent='patch',new_value)
        if(new_value<0)
          new_value=nil
        end
        major,minor,patch  = version_name.split(".")
        if(versionComponent=='major')
            major=new_value || major.to_i+1
        elsif(versionComponent=='minor')
            minor= new_value ||minor.to_i+1
        elsif(versionComponent="patch")
            patch=new_value || patch.to_i+1
        end
        return "#{major}.#{minor}.#{patch}"
      end

      def self.description
        "Increment the version code of your flutter project."
      end

      def self.authors
        ["Abhijith K"]
      end

      def self.available_options
          [
              FastlaneCore::ConfigItem.new(key: :version_component,
                                      env_name: "INCREMENTFLUTTERVERSION_VERSION_COMPONENT",
                                   description: "The component of the version to be updated, version format :  major.minor.patch+version_code. (default : version_code)",
                                      optional: true,
                                          type: String,
                                 default_value:"version_code"),
             FastlaneCore::ConfigItem.new(key: :pubspec_file_path,
                                     env_name: "INCREMENTFLUTTERVERSION_PUBSPEC_FILE_PATH",
                                  description: "The relative path to the pubspec file containing the version parameter (default:app/build.gradle)",
                                     optional: true,
                                         type: String,
                                default_value: nil),
              FastlaneCore::ConfigItem.new(key: :value,
                                      env_name: "INCREMENTFLUTTERVERSION_VALUE",
                                   description: "Change to a specific version (optional)",
                                      optional: true,
                                          type: Integer,
                                 default_value: -1),
              FastlaneCore::ConfigItem.new(key: :ext_constant_name,
                                      env_name: "INCREMENTVERSIONCODE_EXT_CONSTANT_NAME",
                                   description: "If the version code is set in an ext constant, specify the constant name (optional)",
                                      optional: true,
                                          type: String,
                                 default_value: "version")
          ]
      end

      def self.output
        [
          ['VERSION_CODE', 'The new version code of the project']
        ]
      end

      def self.is_supported?(platform)
        [:android].include?(platform)
      end
    end
  end
end