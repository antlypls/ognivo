module Ognivo
  module Agvtool
    def self.marketing_version
      output = `agvtool what-marketing-version -terse`
      output.scan(/\=(.+)$/).flatten.first
    end
  end
end
