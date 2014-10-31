program :version, Ognivo::VERSION
program :description, 'Build and publish OS X apps updates with sparkle and S3'

program :help, 'Author', 'Anatoliy Plastinin <hello@antlypls.com>'
program :help, 'Website', 'http://github.com/antlypls/ognivo'
program :help_formatter, :compact

default_command :help

require 'ognivo/commands/build'
require 'ognivo/commands/upload'
require 'ognivo/commands/init'
require 'ognivo/commands/release'
