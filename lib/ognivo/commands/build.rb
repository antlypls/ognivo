command :build do |c|
  c.syntax = 'build [options]'
  c.summary = 'Builds and packs your app into zip archive'
  c.description = ''

  c.option '-w', '--workspace WORKSPACE_FILE',
           'Workspace (.xcworkspace) file to use to build app ' \
           '(automatically detected in current directory)'

  c.option '-p', '--project PROJECT_FILE',
           'Project (.xcodeproj) file to use to build app ' \
           '(automatically detected in current directory, ' \
           'overridden by --workspace option, if passed)'

  c.option '-c', '--configuration CONFIGURATION',
           'Configuration used to build'

  c.option '-s', '--scheme SCHEME',
           'Scheme used to build app'

  c.option '-d', '--destination DESTINATION',
           'Destination. Defaults to current directory'

  c.option '--verbose', 'Show build output'

  c.action do |_, options|
    opts = {
      destination_dir: options.destination,
      workspace: options.workspace,
      build_configuration: options.configuration,
      scheme: options.scheme,
      verbose: options.verbose,
      append_version: true
    }

    Ognivo::Build.new(opts).build
  end
end
