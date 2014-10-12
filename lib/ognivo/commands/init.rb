command :init do |c|
  c.syntax = 'init [options]'
  c.summary = 'Creates an appcast'
  c.description = ''

  c.option '-a', '--access-key-id ACCESS_KEY_ID',
           'AWS Access Key ID'

  c.option '-s', '--secret-access-key SECRET_ACCESS_KEY',
           'AWS Secret Access Key'

  c.option '-b', '--bucket BUCKET',
           'S3 Bucket user to store appcast'

  c.option '-c', '--appcast APPCAST',
           'Appcast file name, appcast.xml is used by default'

  c.action do |_, options|
    if options.bucket.nil? || options.bucket.empty?
      say_error 'Bucket name is missing'
      abort
    end

    opts = {
      access_key_id: ENV['AWS_ACCESS_KEY_ID'] || options.access_key_id,
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'] || options.secret_access_key,
      bucket_name: options.bucket,
      appcast_name: options.appcast || 'appcast.xml'
    }

    Ognivo::Upload.new(opts).init_appcast
  end
end
