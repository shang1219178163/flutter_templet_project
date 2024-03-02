module Fastlane
  module Actions
    module SharedValues
      PLIST_FROM_PATH_CUSTOM_VALUE = :PLIST_FROM_PATH_CUSTOM_VALUE
    end

    class YamlFromPathAction < Action
      def self.run(params)
        # fastlane will take care of reading in the parameter and fetching the environment variable:
        file_path = params[:path];
        UI.message "Parameter path: #{file_path}".blue
        hash = YAML.load(File.read(file_path))
        UI.message "pubspec.yaml: #{hash}---".green

        return hash
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
        "You can use this action to get the plist"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :path,
                                       env_name: "PATH", # The name of the environment variable
                                       description: "file path", # a short description of this parameter
                                       verify_block: proc do |value|
                                          UI.user_error!("No path given, pass using `path: `") unless (value and not value.empty?)
                                          # UI.user_error!("Couldn't find file at path '#{value}'") unless File.exist?(value)
                                       end),
          ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['PLIST_FROM_PATH_CUSTOM_VALUE',  'file path']
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
