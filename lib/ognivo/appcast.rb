require 'nokogiri'

module Ognivo
  class Appcast
    class Item < Struct.new(:title, :description, :sparkle_version, :pub_date, :url,
                            :length, :type, :dsa_signature)
      def to_node(xml)
        xml.item do
          xml.title title
          xml.description do
            xml.cdata description
          end
          xml.pubDate pub_date.rfc2822
          xml.enclosure enclosure
        end
      end

      private

      def enclosure
        {
          'url' => url,
          'sparkle:version' => sparkle_version,
          'length' => length,
          'type' => type,
          'sparkle:dsaSignature' => dsa_signature
        }.reject { |_, v| v.nil? }
      end
    end

    attr_accessor :title
    attr_accessor :link
    attr_accessor :description
    attr_accessor :language

    RSS_ATTRIBUTES = {
      'version' => '2.0',
      'xmlns:sparkle' => 'http://www.andymatuschak.org/xml-namespaces/sparkle',
      'xmlns:dc' => 'http://purl.org/dc/elements/1.1/'
    }

    def initialize(title, link, description, language)
      @title = title
      @link = link
      @description = description
      @language = language
    end

    def generate
      Nokogiri::XML::Builder.new(encoding: 'utf-8') do |xml|
        xml.rss(RSS_ATTRIBUTES) do
          xml.channel do
            xml.title title
            xml.link link
            xml.description description
            xml.language language
          end
        end
      end.to_xml
    end

    def self.add_item(xml_text, item)
      doc = Nokogiri::XML(xml_text) { |cfg| cfg.noblanks }
      Nokogiri::XML::Builder.with(doc.at('channel')) do |xml|
        item.to_node(xml)
      end

      doc.to_xml
    end
  end
end
