module Fastlane
  module Actions
    module SharedValues
      DINGSLACK_ROBOT_CUSTOM_VALUE = :DINGSLACK_ROBOT_CUSTOM_VALUE
    end

    class DingslackRobotAction < Action
      def self.run(params)
        # fastlane will take care of reading in the parameter and fetching the environment variable:
        # UI.message "Parameter API Token: #{params[:api_token]}"

        # sh "shellcommand ./path"

        # Actions.lane_context[SharedValues::DINGSLACK_ROBOT_CUSTOM_VALUE] = "my_val"
        appPath = params[:appPath]
        downloadUrl = params[:downloadUrl]
        appIcon = params[:appIcon]
        slackUrl = params[:slackUrl]
        slogan = params[:slogan]

        appName    = other_action.get_ipa_info_plist_value(ipa: appPath, key: "CFBundleDisplayName")
        bundleName = other_action.get_ipa_info_plist_value(ipa: appPath, key: "CFBundleBundleName")
        appVersion = other_action.get_ipa_info_plist_value(ipa: appPath, key: "CFBundleShortVersionString")
        appBuild   = other_action.get_ipa_info_plist_value(ipa: appPath, key: "CFBundleVersion")
        ipaName    = other_action.get_ipa_info_plist_value(ipa: appPath, key: "CFBundleName")#备用

        appName = appName.empty? == false ? appName : bundleName

        platformInfo = "已更新至 #{downloadUrl.split(".")[1].capitalize} 啦！"
        message = "iOS #{appName} v#{appVersion} #{platformInfo}"

        author = `git log -1 --pretty=format:"%ae"`
        time = Time.new.strftime("%Y-%m-%d %H:%M:%S")

        other_action.slack(
          # message: "<项目名称> Successfully deployed new App Update.",
          message: message,
          slack_url: slackUrl,
          # default_payloads: [:lane, :git_branch, :git_author, :last_git_commit],
          default_payloads: [],
          attachment_properties: {
            thumb_url: appIcon,
            author_name: author,
            pretext: slogan,
            fields: [
            {
              # title: "DownloadUrl",
              value: "版本：#{appBuild}",
              short: true
            },
            {
              # title: "DownloadUrl",
              value: "下载：#{downloadUrl}",
              short: true
            },
            {
              # title: "时间日期",
              value: "时间：#{time}",
              short: false
            }]
          }
        )
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
        [
          FastlaneCore::ConfigItem.new(key: :appPath,
                                     env_name: "GET_IPA",
                                  description: "ipa文件所在的文件夹路径",
                                     optional: false,
                                         type: String),
             FastlaneCore::ConfigItem.new(key: :downloadUrl,
                                  description: "fir的ipa文件下载网址",
                                     optional: false,
                                         type: String),
             FastlaneCore::ConfigItem.new(key: :appIcon,
                                  description: "ipa图标网络地址",
                                     optional: true,
                                         type: String),
             FastlaneCore::ConfigItem.new(key: :slackUrl,
                                  description: "slack webhook Url",
                                     optional: false,
                                         type: String),
             FastlaneCore::ConfigItem.new(key: :slogan,
                                  description: "slogan",
                                     optional: true,
                                         type: String),
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['DINGSLACK_ROBOT_CUSTOM_VALUE', 'A description of what this value contains']
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
