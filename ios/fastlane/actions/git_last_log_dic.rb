module Fastlane
  module Actions
    module SharedValues
      GIT_LAST_LOG_DIC_CUSTOM_VALUE = :GIT_LAST_LOG_DIC_CUSTOM_VALUE
    end

    class GitLastLogDicAction < Action
      def self.run(params)
        # fastlane will take care of reading in the parameter and fetching the environment variable:
        # UI.message "Parameter API Token: #{params[:api_token]}"

        # sh "shellcommand ./path"

        # Actions.lane_context[SharedValues::GIT_LAST_LOG_DIC_CUSTOM_VALUE] = "my_val"

        command = ['git log -1']
        obj = Actions.sh(command.compact.join(' '), log: false)

        list = obj.split("\n")#markdown换行符需要前后2个空格

        time = Time.parse(list[2].split("Date:").last)
        dic = {
              last_git_commit_hash: list.first.split(" ").last[0,8],
              git_author: list[1].split(" ").first,
              git_email: list[1].split(" ").last,
              last_git_commit_time:  time.strftime("%Y-%m-%d %H:%M:%S"),
              last_git_commit_note:  list[4]
            }

       # UI.message "Parameter API Token: #{obj}"
      # UI.message "--#{list}--"
       # UI.message "--#{dic}--"

       return dic
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "A short description with <= 80 characters of what this action does"
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
          # FastlaneCore::ConfigItem.new(key: :api_token,
          #                              env_name: "FL_GIT_LAST_LOG_DIC_API_TOKEN", # The name of the environment variable
          #                              description: "API Token for GitLastLogDicAction", # a short description of this parameter
          #                              verify_block: proc do |value|
          #                                 UI.user_error!("No API token for GitLastLogDicAction given, pass using `api_token: 'token'`") unless (value and not value.empty?)
          #                                 # UI.user_error!("Couldn't find file at path '#{value}'") unless File.exist?(value)
          #                              end),
          # FastlaneCore::ConfigItem.new(key: :development,
          #                              env_name: "FL_GIT_LAST_LOG_DIC_DEVELOPMENT",
          #                              description: "Create a development certificate instead of a distribution one",
          #                              is_string: false, # true: verifies the input is a string, false: every kind of value
          #                              default_value: false) # the default value if the user didn't provide one
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['GIT_LAST_LOG_DIC_CUSTOM_VALUE', 'A description of what this value contains']
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
