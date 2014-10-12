command :upload do |c|
  c.syntax = 'upload [options] app_archive'
  c.summary = 'Uploads app archive and updates appcast'
  c.description = ''

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
           'if not specified dsa signature will not be included into appcast'

  c.option '--app-version VERSION',
           'Application version to be used in appcast item'

  c.action do |args, options|
    app_archive = args.first

    opts = {
      access_key_id: ENV['AWS_ACCESS_KEY_ID'] || options.access_key_id,
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'] || options.secret_access_key,
      bucket_name: options.bucket,
      appcast_name: options.appcast || 'appcast.xml',
      app_filename: app_archive,
      dsa_filename: options.dsa_private_key,
      version: options.app_version
    }

    Ognivo::Upload.new(opts).upload
  end
end
