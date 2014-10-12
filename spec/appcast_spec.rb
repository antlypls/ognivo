require 'spec_helper'

describe Ognivo::Appcast do
  subject(:cast) do
    described_class.new(
      'Sparkle Test App Changelog',
      'http://sparkle-project.org/files/sparkletestcast.xml',
      'Most recent changes with links to updates.',
      'en'
    )
  end

  describe '#generate' do
    it 'generates cast xml' do
      out = cast.generate

      expect(out).to eq(<<-XML.gsub(/^ {8}/, ''))
        <?xml version="1.0" encoding="utf-8"?>
        <rss xmlns:sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle" xmlns:dc="http://purl.org/dc/elements/1.1/" version="2.0">
          <channel>
            <title>Sparkle Test App Changelog</title>
            <link>http://sparkle-project.org/files/sparkletestcast.xml</link>
            <description>Most recent changes with links to updates.</description>
            <language>en</language>
          </channel>
        </rss>
      XML
    end
  end

  describe '.add_item' do
    subject(:cast) { described_class }
    it 'creates a new item in xml if there is no' do
      original_xml =  <<-XML.gsub(/^ {8}/, '')
        <?xml version="1.0" encoding="utf-8"?>
        <rss xmlns:sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle" xmlns:dc="http://purl.org/dc/elements/1.1/" version="2.0">
          <channel>
            <title>Sparkle Test App Changelog</title>
            <link>http://sparkle-project.org/files/sparkletestcast.xml</link>
            <description>Most recent changes with links to updates.</description>
            <language>en</language>
          </channel>
        </rss>
      XML

      item = Ognivo::Appcast::Item.new

      item.title = 'Version 2.0'
      item.description = 'HTML'
      item.pub_date = DateTime.new(2014, 07, 26, 15, 20, 11)
      item.url = 'http://sparkle-project.org/files/Sparkle%20Test%20App.zip'
      item.sparkle_version = '2.0'
      item.length = 107758
      item.type = 'application/octet-stream'
      item.dsa_signature = 'MCwCFCdoW13VBGJWIfIklKxQVyetgxE7AhQTVuY9uQT0KOV1UEk21epBsGZMPg=='

      result = cast.add_item(original_xml, item)

      expect(result).to eq(<<-XML.gsub(/^ {8}/, ''))
        <?xml version="1.0" encoding="utf-8"?>
        <rss xmlns:sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle" xmlns:dc="http://purl.org/dc/elements/1.1/" version="2.0">
          <channel>
            <title>Sparkle Test App Changelog</title>
            <link>http://sparkle-project.org/files/sparkletestcast.xml</link>
            <description>Most recent changes with links to updates.</description>
            <language>en</language>
            <item>
              <title>Version 2.0</title>
              <description><![CDATA[HTML]]></description>
              <pubDate>Sat, 26 Jul 2014 15:20:11 +0000</pubDate>
              <enclosure url="http://sparkle-project.org/files/Sparkle%20Test%20App.zip" length="107758" type="application/octet-stream" sparkle:version="2.0" sparkle:dsaSignature="MCwCFCdoW13VBGJWIfIklKxQVyetgxE7AhQTVuY9uQT0KOV1UEk21epBsGZMPg=="/>
            </item>
          </channel>
        </rss>
      XML
    end

    it 'appends a new item into xml' do
      original_xml =  <<-XML.gsub(/^ {8}/, '')
        <?xml version="1.0" encoding="utf-8"?>
        <rss xmlns:sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle" xmlns:dc="http://purl.org/dc/elements/1.1/" version="2.0">
          <channel>
            <title>Sparkle Test App Changelog</title>
            <link>http://sparkle-project.org/files/sparkletestcast.xml</link>
            <description>Most recent changes with links to updates.</description>
            <language>en</language>
            <item>
              <title>Version 2.0</title>
              <description><![CDATA[HTML]]></description>
              <pubDate>Sat, 26 Jul 2014 15:20:11 +0000</pubDate>
              <enclosure url="http://sparkle-project.org/files/Sparkle%20Test%20App.zip" length="107758" type="application/octet-stream" sparkle:version="2.0" sparkle:dsaSignature="MCwCFCdoW13VBGJWIfIklKxQVyetgxE7AhQTVuY9uQT0KOV1UEk21epBsGZMPg=="/>
            </item>
          </channel>
        </rss>
      XML

      item = Ognivo::Appcast::Item.new

      item.title = 'Version 3.0'
      item.description = 'HTML 2'
      item.pub_date = DateTime.new(2014, 07, 26, 15, 20, 11)
      item.url = 'http://sparkle-project.org/files/Sparkle%20Test%20App.zip'
      item.sparkle_version = '2.0'
      item.length = 107758
      item.type = 'application/octet-stream'
      item.dsa_signature = 'MCwCFCdoW13VBGJWIfIklKxQVyetgxE7AhQTVuY9uQT0KOV1UEk21epBsGZMPg=='

      result = cast.add_item(original_xml, item)

      expect(result).to eq(<<-XML.gsub(/^ {8}/, ''))
        <?xml version="1.0" encoding="utf-8"?>
        <rss xmlns:sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle" xmlns:dc="http://purl.org/dc/elements/1.1/" version="2.0">
          <channel>
            <title>Sparkle Test App Changelog</title>
            <link>http://sparkle-project.org/files/sparkletestcast.xml</link>
            <description>Most recent changes with links to updates.</description>
            <language>en</language>
            <item>
              <title>Version 2.0</title>
              <description><![CDATA[HTML]]></description>
              <pubDate>Sat, 26 Jul 2014 15:20:11 +0000</pubDate>
              <enclosure url="http://sparkle-project.org/files/Sparkle%20Test%20App.zip" length="107758" type="application/octet-stream" sparkle:version="2.0" sparkle:dsaSignature="MCwCFCdoW13VBGJWIfIklKxQVyetgxE7AhQTVuY9uQT0KOV1UEk21epBsGZMPg=="/>
            </item>
            <item>
              <title>Version 3.0</title>
              <description><![CDATA[HTML 2]]></description>
              <pubDate>Sat, 26 Jul 2014 15:20:11 +0000</pubDate>
              <enclosure url="http://sparkle-project.org/files/Sparkle%20Test%20App.zip" length="107758" type="application/octet-stream" sparkle:version="2.0" sparkle:dsaSignature="MCwCFCdoW13VBGJWIfIklKxQVyetgxE7AhQTVuY9uQT0KOV1UEk21epBsGZMPg=="/>
            </item>
          </channel>
        </rss>
      XML
    end
  end
end

describe Ognivo::Appcast::Item do
  subject(:item) { described_class.new }

  describe '#to_node' do
    it 'creates item node' do
      item.title = 'Version 2.0'
      item.description = 'HTML'
      item.pub_date = DateTime.new(2014, 07, 26, 15, 20, 11)
      item.url = 'http://sparkle-project.org/files/Sparkle%20Test%20App.zip'
      item.sparkle_version = '2.0'
      item.length = 107758
      item.type = 'application/octet-stream'
      item.dsa_signature = 'MCwCFCdoW13VBGJWIfIklKxQVyetgxE7AhQTVuY9uQT0KOV1UEk21epBsGZMPg=='

      builder = Nokogiri::XML::Builder.new(encoding: 'utf-8') do |xml|
        item.to_node(xml)
      end

      xml = builder.to_xml

      expect(xml).to eq(<<-XML.gsub(/^ {8}/, ''))
        <?xml version="1.0" encoding="utf-8"?>
        <item>
          <title>Version 2.0</title>
          <description><![CDATA[HTML]]></description>
          <pubDate>Sat, 26 Jul 2014 15:20:11 +0000</pubDate>
          <enclosure url="http://sparkle-project.org/files/Sparkle%20Test%20App.zip" length="107758" type="application/octet-stream" sparkle:version="2.0" sparkle:dsaSignature="MCwCFCdoW13VBGJWIfIklKxQVyetgxE7AhQTVuY9uQT0KOV1UEk21epBsGZMPg=="/>
        </item>
      XML
    end
  end
end
