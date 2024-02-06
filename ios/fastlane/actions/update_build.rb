module Fastlane
  module Actions
    module SharedValues
      UPDATE_BUILD_CUSTOM_VALUE = :UPDATE_BUILD_CUSTOM_VALUE
    end

    class UpdateBuildAction < Action
      def self.run(params)
        # fastlane will take care of reading in the parameter and fetching the environment variable:
#        UI.message "Parameter API Token: #{params[:api_token]}"
        # sh "shellcommand ./path"
        # Actions.lane_context[SharedValues::UPDATE_BUILD_CUSTOM_VALUE] = "my_val"
        # require "Time"

        #获取短hash值
        command = ['git log --pretty=format:"%h" -1']
        shortHash = Actions.sh(command.compact.join(' '), log: false)
        build = params[:showHash] ? shortHash : ""

        # params[:version] = params[:version] ? params[:version] : Time.now.strftime("%Y%m%d%H%M") + build
        params[:version] = params[:version] ? params[:version] : Time.now.strftime("%Y.%m%d.%H%M") + build
        UI.message "version:_#{params[:version]}_".green

        command = []
        command << "/usr/libexec/PlistBuddy"
        command << "-c"
        command << "\"Set :CFBundleVersion #{params[:version]}\""
        command << params[:plist]

        result = Actions.sh(command.join(' '))
        UI.message "Update Build Number Successfully ⬆️ ".green

        UI.message "--#{result} ".green
        return result

      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "更新build版本，默认值为当前‘年月日时分’数值"
      end

      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        "You can use this action to do cool things..."
      end

      def self.output
      [
        ['BUILD_NUMBER', 'The new build number']
      ]
      end

      def self.available_options
        [
        FastlaneCore::ConfigItem.new(key: :version,
                                     description: "Build version",
                                     optional: true,
                                     is_string: true),
        FastlaneCore::ConfigItem.new(key: :plist,
                                     description: "Plist file",
                                     optional: false,
                                     is_string: true),
         FastlaneCore::ConfigItem.new(key: :showHash,
                                      description: "follow short Hash？",
                                      optional: true,
                                      is_string: false)
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['UPDATE_BUILD_CUSTOM_VALUE', "build版本新值"],
          ['PATH_OF_PLIST_FILE ', 'plist文件路径']
        ]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["shang1219178163"]
      end

      def self.is_supported?(platform)
        # you can do things like
        #
        #  true
        #
        #  platform == :ios
        #
        #  [:ios, :mac].include?(platform)
        #

        platform == :ios
      end
    end
  end
end
