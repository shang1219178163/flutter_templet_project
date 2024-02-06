module Fastlane
  module Actions
    module SharedValues
      DINGDINGTALK_ROBOT_CUSTOM_VALUE = :DINGDINGTALK_ROBOT_CUSTOM_VALUE
    end

    class DingdingtalkRobotAction < Action
      def self.run(params)
        # fastlane will take care of reading in the parameter and fetching the environment variable:
        # UI.message "Parameter API Token: #{params[:api_token]}"
        # sh "shellcommand ./path"
        # Actions.lane_context[SharedValues::DINGDINGTALK_ROBOT_CUSTOM_VALUE] = "my_val"
        appPath = params[:appPath]
        appIcon = params[:appIcon]
        dingUrl = params[:dingUrl]
        downloadUrl = params[:downloadUrl]
        slogan = params[:slogan]
        markdownText = params[:markdownText]

        appName    = other_action.get_ipa_info_plist_value(ipa: appPath, key: "CFBundleDisplayName")
        bundleName = other_action.get_ipa_info_plist_value(ipa: appPath, key: "CFBundleBundleName")
        appVersion = other_action.get_ipa_info_plist_value(ipa: appPath, key: "CFBundleShortVersionString")
        appBuild   = other_action.get_ipa_info_plist_value(ipa: appPath, key: "CFBundleVersion")
        ipaName    = other_action.get_ipa_info_plist_value(ipa: appPath, key: "CFBundleName")#备用

        appName = appName.empty? == false ? appName : bundleName

        platformInfo = "已更新至 #{downloadUrl.split(".")[1].capitalize} 啦！"
        title = "iOS #{appName} v#{appVersion} #{platformInfo}"
        time = Time.new.strftime("%Y-%m-%d %H:%M:%S")

        # markdown ={
        #   msgtype: "link",
        #   link: {
        #       title: title,
        #       text: "版  本：#{appBuild}\n地  址：#{downloadUrl}\n时  间：#{time}",
        #       picUrl: "#{appIcon}",
        #       messageUrl: "#{downloadUrl}"
        #   }
        # }

        # if markdownText
        #   markdownText = "#{markdownText}   \n  - [Download](#{downloadUrl})"
        #   markdown ={
        #        "msgtype": "markdown",
        #        "markdown": {"title": "#{title}",
        #                     "text": "### #{title}\n#{markdownText}",
        #        }
        #    }
        # end
        
        markdownText = "#{markdownText}\n
版  本：#{appBuild}\n
地  址：#{downloadUrl}\n
时  间：#{time}\n
![](#{appIcon})"

        markdown ={
          "msgtype": "markdown",
          "markdown": {"title": "#{title}",
                       "text": "### #{title}\n#{markdownText}",
          }
        }

        ##请求
        uri = URI.parse(dingUrl)
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true

        request = Net::HTTP::Post.new(uri.request_uri)
        request.add_field('Content-Type', 'application/json')
        request.body = markdown.to_json

        response = https.request(request)
        puts "-----------#{uri.request_uri}-------------------"
        puts "Response #{response.code} #{response.message}: #{response.body}"
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
             FastlaneCore::ConfigItem.new(key: :dingUrl,
                                  description: "钉钉机器人网络接口",
                                     optional: false,
                                         type: String),
             FastlaneCore::ConfigItem.new(key: :markdownText,
                                  description: "钉钉机器人 msgtype: markdown时的text",
                                     optional: true,
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
          ['DINGDINGTALK_ROBOT_CUSTOM_VALUE', 'A description of what this value contains']
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
