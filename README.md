# Ognivo

[![Code Climate](http://img.shields.io/codeclimate/github/antlypls/ognivo.svg?style=flat)](https://codeclimate.com/github/antlypls/ognivo)
[![Build Status](http://img.shields.io/travis/antlypls/ognivo.svg?style=flat)](https://travis-ci.org/antlypls/ognivo)

Create MacOS app builds and destribute updates with [Sparkle](https://github.com/sparkle-project/Sparkle) over [Amazon S3](http://aws.amazon.com/s3/).

> **NOTE** about gem's name:
> *ognivo* is a russian word that means *fire striker*,
> so it is a device for making sparkles.

## Installation

Execute:

    $ gem install ognivo

## Usage

Gem adds `spark` command-line app. The app provides following commands:

      build                Builds and packs your app into zip archive
      init                 Creates an appcast
      upload               Uploads app archive and updates appcast
      release              Builds and packs your app into zip archive

### Building and Archiving

    $ cd /path/to/XCodeProject
    $ spark build

Ognivo will find workspace/project file and build default configuration,
after that it will pack it into zip archive and save it in a current directory.

Default behavior can be overriden using these options:

    -w, --workspace WORKSPACE_FILE Workspace (.xcworkspace) file to use to build app (automatically detected in current directory)
    -c, --configuration CONFIGURATION Configuration used to build
    -s, --scheme SCHEME Scheme used to build app
    -d, --destination DESTINATION Destination. Defaults to current directory

### Preparing an appcast

First, you have to create an S3 bucket that will be used to store an appcast and
update files. Then run:

    $ spark init -a aws_access_key -s aws_secret_key -b bucket_name

Tool will ask a few questions to prepare an empty appcast, and then app will
upload new `appcast.xml` file into provided bucket.

You can change default appcast file name using `-c, --appcast` option.

### Distributing an update

    $ spark upload -a aws_access_key -s aws_secret_key -b bucket_name MyApp.zip

The tool will ask you for update's title, version and release notes, and then it
uploads specified file and updates appcast with new version.

If you don't sign your app with your Developer Certificate,
you can specify DSA private key to calculate code signature for Sparkle using
`-d, --dsa-private-key` option.
Read more about code signing
[here](https://github.com/sparkle-project/Sparkle/wiki#3-segue-for-security-concerns).

### Releasing an update

Most of the time you will use `release` command, that builds a new version and
then uploads archive.

    $ spark release -a aws_access_key -s aws_secret_key -b bucket_name

The `release` command supports options for both `build` and `upload` commands.
It will try to get application version from Xcode project settings.

## Contributing

Contributions are welcome.

## Thanks

Ognivo is inspired by [shenzhen gem](https://github.com/nomad/shenzhen).
Many thanks to [@mattt](https://github.com/mattt) for his work on such awesome tool.

## Credits

Ognivo is by [Anatoliy Plastinin](http://antlypls.com).

## License

MIT.
