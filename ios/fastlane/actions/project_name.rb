module Fastlane
  module Actions
    module SharedValues
      PROJECT_NAME_CUSTOM_VALUE = :PROJECT_NAME_CUSTOM_VALUE
    end

    class ProjectNameAction < Action
      def self.run(params)
        # fastlane will take care of reading in the parameter and fetching the environment variable:
        # UI.message "Parameter API Token: #{params[:api_token]}"
        # sh "shellcommand ./path"
        # Actions.lane_context[SharedValues::PROJECT_NAME_CUSTOM_VALUE] = "my_val"

        #获取当前目录的父目录
      parPath = Dir.pwd
      list = Dir.glob(["#{parPath}/*xcodeproj","#{parPath}/*xcworkspace"])
      if list.empty? == true
        UI.message "--#{parPath}  不包含xcodeproj/xcworkspace文件！！！--"
        return ""
      end

      projectNameAll = File.basename(list[0])
      projectName = projectNameAll.split(".")[0]

      # list = Dir.glob(["#{parPath}/.git/COMMIT_EDITMSG"])
      # puts "1--#{Dir.pwd}--"
      # puts "2--#{parPath}--"
      # puts "3--#{list}--"
      # puts "4--#{list[0]}--"
      # puts "5--#{projectNameAll}--"
      # puts "9--#{projectName}--"

      UI.message "项目名称：_#{projectName}_"
      return projectName

      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "获取项目工程名（后缀为xcodeproj/xcworkspace）"
      end

      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        "You can use this action to do cool things..."
      end

      def self.available_options
        # Define all options your action supports.

        # Below a few examples
        [
          FastlaneCore::ConfigItem.new(key: :api_token,
                                       env_name: "FL_PROJECT_NAME_API_TOKEN", # The name of the environment variable
                                       description: "API Token for ProjectNameAction", # a short description of this parameter
                                       verify_block: proc do |value|
                                          UI.user_error!("No API token for ProjectNameAction given, pass using `api_token: 'token'`") unless (value and not value.empty?)
                                          # UI.user_error!("Couldn't find file at path '#{value}'") unless File.exist?(value)
                                       end),
          FastlaneCore::ConfigItem.new(key: :development,
                                       env_name: "FL_PROJECT_NAME_DEVELOPMENT",
                                       description: "Create a development certificate instead of a distribution one",
                                       is_string: false, # true: verifies the input is a string, false: every kind of value
                                       default_value: false) # the default value if the user didn't provide one
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['PROJECT_NAME_CUSTOM_VALUE', 'A description of what this value contains']
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
