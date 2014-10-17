require 'xctools'

module Ognivo
  class Build
    include CLIHelpers

    OPTIONS = [:destination_dir, :workspace, :project, :scheme, :verbose,
               :build_configuration, :append_version]

    def initialize(opts = {})
      OPTIONS.each { |v| instance_variable_set("@#{v}", opts[v]) }
      @project = nil if @workspace
    end

    def build
      collect_settings
      error_and_abort('Build failed') unless system(xcodebuild_cmd)
      package_app
      say_ok 'App has been successfully built'
    end

    def build_version
      @build_version ||= XcTools::Agvtool.marketing_version.to_s
    end

    attr_reader :zip_file

    private

    def validate_settings(build_settings)
      return if build_settings
      error_and_abort('App settings could not be found.')
    end

    def collect_settings
      build_info = XcTools::XcodeBuild.info(workspace: @workspace, project: @project)

      ensure_workspace_project

      @scheme = select_option('scheme', build_info.schemes) unless @scheme

      build_settings = XcTools::XcodeBuild.settings(*build_flags).find_app
      validate_settings(build_settings)

      @build_configuration ||= build_settings['CONFIGURATION']

      @app_path = File.join(build_settings['BUILT_PRODUCTS_DIR'],
                            build_settings['WRAPPER_NAME'])

      @destination_dir ||= Dir.pwd
    end

    def xcodebuild_cmd
      cmd = ['xcodebuild', *build_flags, *build_actions]
      cmd << '1> /dev/null' unless @verbose
      cmd.join(' ')
    end

    def version_suffix
      return unless @append_version
      build_version.empty? ? '' : "-#{build_version}"
    end

    def execute_in_tmpdir(*cmds)
      Dir.mktmpdir('ognivo') do |dir|
        cmd = ["cd #{dir}", *cmds].join(' && ')
        `#{cmd}`
      end
    end

    def package_app
      app_dir = File.basename(@app_path)
      app_name = File.basename(app_dir, '.app')
      @zip_file = "#{app_name}#{version_suffix}.zip"

      execute_in_tmpdir(
        "cp -R #{@app_path} ./",
        "zip -9 -y -r #{@zip_file} #{app_dir}",
        "mv #{@zip_file} #{@destination_dir}"
      )
    end

    def build_flags
      flags = []
      flags << %(-workspace "#{@workspace}") if @workspace
      flags << %(-project "#{@project}") if @project
      flags << %(-scheme "#{@scheme}") if @scheme
      flags << %(-configuration "#{@build_configuration}") if @build_configuration

      flags
    end

    def build_actions
      [:clean, :build, :archive]
    end

    def ensure_workspace_project
      return if @workspace || @project
      @workspace = find_workspace
      @project = find_project unless @workspace

      verify_workspace_project
    end

    def verify_workspace_project
      return if @workspace || @project
      error_and_abort('No Xcode projects or workspaces found in current directory')
    end

    def find_workspace
      find_xcfile('workspace', '*.xcworkspace')
    end

    def find_project
      find_xcfile('project', '*.xcodeproj')
    end

    def find_xcfile(name, pattern)
      files = Dir[pattern]
      select_option("a #{name}", files)
    end

    def select_option(name, collection)
      return unless collection && !collection.empty?
      return collection.first if collection.count == 1
      choose "Select #{name}:\n", *collection
    end
  end
end
