command :release do |c|
  c.syntax = 'release [options]'
  c.summary = 'Builds and packs your app into zip archive'
  c.description = ''

  c.option '--workspace WORKSPACE_FILE',
           'Workspace (.xcworkspace) file to use to build app ' \
           '(automatically detected in current directory)'

  c.option '-p', '--project PROJECT_FILE',
           'Project (.xcodeproj) file to use to build app ' \
           '(automatically detected in current directory, ' \
           'overridden by --workspace option, if passed)'

  c.option '--configuration CONFIGURATION',
           'Configuration used to build'

  c.option '--scheme SCHEME',
           'Scheme used to build app'

  # upload options

  c.option '-a', '--access-key-id ACCESS_KEY_ID',
           'AWS Access Key ID'

  c.option '-s', '--secret-access-key SECRET_ACCESS_KEY',
           'AWS Secret Access Key'

  c.option '-b', '--bucket BUCKET',
           'S3 Bucket user to store appcast and releases'

  c.option '-c', '--appcast APPCAST',
           'Appcast file name, appcast.xml is used by default'

  c.option '-d', '--dsa-private-key DSA_PRIVATE_KEY',
           'DSA private key file used to sign app archive, ' \
           'if not specified dsa signature will not be included into appcast.'

  c.option '--app-version VERSION',
           'Application version to be used in appcast item'

  c.action do |_, options|
    Dir.mktmpdir('ognivo') do |destination|
      opts = {
        destination_dir: destination,
        workspace: options.workspace,
        build_configuration: options.configuration,
        scheme: options.scheme,
        verbose: options.verbose,
        append_version: false
      }

      build = Ognivo::Build.new(opts)
      build.build

      opts = {
        access_key_id: ENV['AWS_ACCESS_KEY_ID'] || options.access_key_id,
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'] || options.secret_access_key,
        bucket_name: options.bucket,
        appcast_name: options.appcast || 'appcast.xml',
        app_filename: File.join(destination, build.zip_file),
        dsa_filename: options.dsa_private_key,
        version: options.app_version || build.build_version
      }

      Ognivo::Upload.new(opts).upload
    end
  end
end
