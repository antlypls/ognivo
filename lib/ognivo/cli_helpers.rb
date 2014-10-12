module Ognivo
  module CLIHelpers
    def error_and_abort(error_text)
      say_error(error_text)
      abort
    end
  end
end
