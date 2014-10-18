require 'redcarpet'

module Ognivo
  class Upload
    include CLIHelpers

    OPTIONS = [:access_key_id, :secret_access_key, :bucket_name, :appcast_name,
               :app_filename, :dsa_filename, :version]

    def initialize(opts = {})
      OPTIONS.each { |v| instance_variable_set("@#{v}", opts[v]) }
    end

    def upload
      ensure_appfile
      ensure_bucket
      ensure_appcast

      item = create_item

      upload_build
      say_ok 'Build has been uploaded to S3'

      add_item_to_app_cast(item)
      say_ok 'Appcast succesfully updated'
    end

    def init_appcast
      ensure_bucket
      create_cast
    end

    private

    def ensure_appfile
      return if @app_filename && File.exist?(@app_filename)
      error_and_abort "Bad filename: \nfilename is empty or file doesn't exist"
    end

    def ensure_appcast
      return if appcast_exists?

      unless agree('There is no appcast in a bucket. lets create one? [y/n]')
        error_and_abort "can't continue"
      end

      create_cast
    end

    def create_cast
      cast = Appcast.new(cast_title, cast_link, cast_description, cast_language)

      data = cast.generate

      s3_client.upload(data, @appcast_name)

      say_ok "Appcast has been created at #{cast_link}\n" \
             'Use this link as a value for SUFeedURL key in an Info.plist'
    end

    def ensure_bucket
      return if s3_client.bucket_exists?
      error_and_abort "Bucket \"#{@bucket_name}\" doesn't exist"
    end

    def s3_client
      @s3_client ||=
        S3Client.new(@access_key_id, @secret_access_key, @bucket_name)
    end

    def cast_title
      ask('Appcast Title: ')
    end

    def cast_link
      s3_client.public_url(@appcast_name)
    end

    def cast_description
      ask('Appcast Description: ')
    end

    def cast_language
      ask('Appcast Language (e.g. en): ') { |q| q.default = 'en' }
    end

    def appcast_exists?
      s3_client.key_exists?(@appcast_name)
    end

    def item_title
      ask('Update Title: ')
    end

    def item_description
      text = ask_editor "Write update description. What's new in this update, etc...\n"
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
      markdown.render(text)
    end

    def item_version
      @version ||= ask('Update Version: ')
    end

    def create_item
      say "Let's create an update entry"
      item = Appcast::Item.new(item_title, item_description, item_version)
      item.url = item_url
      item.type = 'application/octet-stream'

      Utils.update_item_for_file(@app_filename, item, @dsa_filename)

      item
    end

    def add_item_to_app_cast(item)
      xml = s3_client.read(@appcast_name)

      new_xml = Appcast.add_item(xml, item)

      s3_client.upload(new_xml, @appcast_name)
    end

    def s3_build_path
      file_name = File.basename(@app_filename, '.*')
      ext = File.extname(@app_filename)
      version = item_version

      "releases/#{file_name}-#{version}#{ext}"
    end

    def item_url
      s3_client.public_url(s3_build_path)
    end

    def upload_build
      s3_client.upload_file(@app_filename, s3_build_path)
    end
  end
end
