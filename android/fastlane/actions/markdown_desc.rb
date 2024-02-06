module Fastlane
  module Actions
    module SharedValues
      MARKDOWN_DESC_CUSTOM_VALUE = :MARKDOWN_DESC_CUSTOM_VALUE
    end

    class MarkdownDescAction < Action
      def self.run(params)
        # fastlane will take care of reading in the parameter and fetching the environment variable:
        # UI.message "Parameter API Token: #{params[:api_token]}"
        # sh "shellcommand ./path
        # Actions.lane_context[SharedValues::MARKDOWN_DESC_CUSTOM_VALUE] = "my_val"
        dic = other_action.git_last_log_dic
        #获取参数
        keys = params[:keys]
        isChinese = params[:isChinese]

        hash = {};
        dic.each{ |key, value|
          # puts "55--#{key}--"
          if keys.include?(key)
            hash[key] = value
          end
        }
        # puts "36--#{hash}--"

        desc = hash.to_s
        # puts "s--#{desc}--"

        desc = desc.gsub("=>",":  ")
        desc = desc.gsub("{","")
        desc = desc.gsub("}","")
        desc = desc.gsub("\"","")
        desc = desc.gsub(",","    \n    ")#markdown换行符需要前后2个空格

        desc = desc.gsub(":git",">- git")#markdown换行符需要前后2个空格
        desc = desc.gsub(":last",">- last")#markdown换行符需要前后2个空格

        desc = desc.gsub("git_branch", isChinese == false ? "Branch" : "分支")
        desc = desc.gsub("git_author", isChinese == false ? "Author" : "作者")
        desc = desc.gsub("git_email", isChinese == false ? "Email" : "邮箱")

        desc = desc.gsub("last_git_commit_note", isChinese == false ? "Note" : "注释")
        desc = desc.gsub("last_git_commit_hash", isChinese == false ? "Hash" : "哈希")
        desc = desc.gsub("last_git_commit_time", isChinese == false ? "Time" : "时间")

        # puts "25--#{desc}--"
        UI.message "返回描述信息：《《《#{desc}_》》》"
        return desc

      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "获取最后一次log值得markdown描述"
      end

      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        "You can use this action to do cool things..."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :keys,
                                       env_name: "MARKDOWN_TITLES", # The name of the environment variable
                                       description: "Markdown内容标题列表，标题是git_last_log_dic键值时为有效键值", # a short description of this parameter
                                       is_string: false,
                                       verify_block: proc do |value|
                                          UI.user_error!("No API token for MarkdownDescAction given, pass using `keys: [key]`") unless (value and not value.empty?)
                                          # UI.user_error!("Couldn't find file at path '#{value}'") unless File.exist?(value)
                                       end),
          FastlaneCore::ConfigItem.new(key: :isChinese,
                                       env_name: "LANGUAGE",
                                       description: "中文还是英语，默认中文",
                                       is_string: false, # true: verifies the input is a string, false: every kind of value
                                       default_value: true) # the default value if the user didn't provide one
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['MARKDOWN_DESC_CUSTOM_VALUE', 'A description of what this value contains']
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
        #  true
        #  platform == :ios
        #  [:ios, :mac].include?(platform)

        platform == :ios
      end
    end
  end
end
