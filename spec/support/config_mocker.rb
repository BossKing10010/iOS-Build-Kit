require 'yaml'

class Hash

	def enable_increment_version!
		self[:tasks][:increment_version][:run] = true
		self
  end

  def enable_decorate_icon!
		self[:tasks][:decorate_icon][:run] = true
		self
  end

  def enable_xcode_build!
		self[:tasks][:xcode_build][:run] = true
		self
  end

  def enable_run_tests!
		self[:tasks][:run_tests][:run] = true
		self
  end

  def enable_create_ipa!
		self[:tasks][:create_ipa][:run] = true
		self
  end

  def enable_distribute!
    self[:tasks][:distribute][:run] = true
    self
  end

  def modify_config! key, value
    self[:configuration][key] = value
    self
  end

  def remove_config! key
  	self[:configuration][key] = nil
  	self
  end

  def missing_file! key
  	self[:configuration][key] = '/path/to/nowhere/missing.file'
  	self
  end

  def invalid_location! key
  	self[:configuration][key] = '/path/to/nowhere/'
  	self
  end

  def modify_task_option! task, key, value
    self[:tasks][task][:options][key] = value
    self
  end

  def modify_preference! key, value
    self[:preferences][key] = value
    self
  end

end

def mock_runner config_file_data
	mock_conf_file = create_mock_config_file config_file_data
	runner = BuildKit::Runner::TaskRunner.new({ config_file: mock_conf_file })
	runner
end

def vc
	valid_config_file_data
end

def valid_config_file_data

	{
		tasks: {

			increment_version: {
				run: false,
				options: nil
			},

			decorate_icon: {
				run: false,
				options: nil
			},

			xcode_build: {
				run: false,
				options: { log: false }
			},

			run_tests: {
				run: false,
				options: { log: false }
			},

			create_ipa: {
				run: false,
				options: { log: false }
			},

      distribute: {
        run: false,
        options: {
          platform: 'hockeyapp',
          token: 'ab1234567891a123a1234567abcde12'
        }
      }

		},

		configuration: {
			app_name: 'BuildKit',
		  workspace: 'example/Objective-C/BuildKit.xcworkspace',
		  info_plist: 'example/Objective-C/BuildKit/BuildKit-Info.plist',
		  build_configuration: 'Release',
		  scheme: 'BuildKit',
		  sdk: 'iphoneos',
		  provisioning_profile: 'example/Objective-C/Provisioning/buildkitdist.mobileprovision',
		  code_sign: 'PNRPD9DG72',
		  icon_dir: 'example/Objective-C/BuildKit/Icon/',
		  build_dir: 'spec/temp/',
		},

		preferences: {
		  reports: 'spec/temp/',
		}

	}

end

def create_mock_config_file hash
	path = 'spec/temp/mock_config_file.yml'
	File.open('spec/temp/mock_config_file.yml', 'w') { |f| f.write hash.to_yaml }
	path
end