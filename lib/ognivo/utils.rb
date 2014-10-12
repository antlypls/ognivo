module Ognivo
  module Utils
    def self.update_item_for_file(file, item, dsa_file)
      item.pub_date = File.ctime(file)
      item.length = File.size(file)
      item.dsa_signature = signature(file, dsa_file) if dsa_file
    end

    def self.signature(file, dsa_file)
      sha_cmd = "openssl dgst -sha1 -binary < #{file}"
      sign_cmd = "openssl dgst -dss1 -sign #{dsa_file}"
      base64_cmd = 'openssl enc -base64'
      output = `#{sha_cmd} | #{sign_cmd} | #{base64_cmd}`
      output.strip
    end
  end
end
