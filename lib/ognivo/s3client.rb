require 'aws-sdk'

module Ognivo
  class S3Client
    def initialize(access_key_id, secret_access_key, bucket)
      @s3 = AWS::S3.new(
        access_key_id: access_key_id,
        secret_access_key: secret_access_key
      )

      @bucket = @s3.buckets[bucket]
    end

    def upload_file(file_path, key)
      File.open(file_path) do |file|
        upload(file, key)
      end
    end

    def upload(io, key)
      @bucket.objects[key].write(io, acl: 'public_read')
    end

    def public_url(name)
      @bucket.objects[name].public_url
    end

    def key_exists?(name)
      @bucket.objects[name].exists?
    end

    def read(name)
      @bucket.objects[name].read
    end

    def bucket_exists?
      @bucket.exists?
    end
  end
end
