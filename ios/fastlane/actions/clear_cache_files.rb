module Fastlane
  module Actions
    module SharedValues
      CLEAR_CACHE_FILES_CUSTOM_VALUE = :CLEAR_CACHE_FILES_CUSTOM_VALUE
    end

    class ClearCacheFilesAction < Action
      def self.run(params)
        # fastlane will take care of reading in the parameter and fetching the environment variable:
        # UI.message "Parameter API Token: #{params[:api_token]}"

        # sh "shellcommand ./path"
        # tokenfiles = "/Users/shang/Library/Caches/com.apple.amp.itmstransporter/UploadTokens/*.token"
        account = "#{`whoami`}".delete "\n"
        tokenfiles = "/Users/#{account}/Library/Caches/com.apple.amp.itmstransporter/UploadTokens/*.token"
        if FileTest.exist?(tokenfiles) {
          output = sh ("rm #{tokenfiles}")
          UI.message "UploadTokens clear: #{output}"
        }

        UI.message "Token: #{tokenfiles}"

        end

        # Actions.lane_context[SharedValues::CLEAR_CACHE_FILES_CUSTOM_VALUE] = "my_val"
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "clear 'UploadTokens/*.token'"
      end

      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        "fix problem: 'Cannot proceed with delivery: an existing transporter instance is currently uploading this package'"
      end

      def self.available_options
        # Define all options your action supports. 
        
        # Below a few examples
        [
          # FastlaneCore::ConfigItem.new(key: :api_token,
          #                              env_name: "FL_CLEAR_CACHE_FILES_API_TOKEN", # The name of the environment variable
          #                              description: "API Token for ClearCacheFilesAction", # a short description of this parameter
          #                              verify_block: proc do |value|
          #                                 UI.user_error!("No API token for ClearCacheFilesAction given, pass using `api_token: 'token'`") unless (value and not value.empty?)
          #                                 # UI.user_error!("Couldn't find file at path '#{value}'") unless File.exist?(value)
          #                              end),
          # FastlaneCore::ConfigItem.new(key: :development,
          #                              env_name: "FL_CLEAR_CACHE_FILES_DEVELOPMENT",
          #                              description: "Create a development certificate instead of a distribution one",
          #                              is_string: false, # true: verifies the input is a string, false: every kind of value
          #                              default_value: false) # the default value if the user didn't provide one
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['CLEAR_CACHE_FILES_CUSTOM_VALUE', 'A description of what this value contains']
        ]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["Your GitHub/Twitter Name"]
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
