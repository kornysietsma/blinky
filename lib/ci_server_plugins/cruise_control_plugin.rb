require "nokogiri"
require "open-uri"

module Blinky
  class CruiseControlPlugin

    attr_reader :cc_xml_url

    def initialize
      @cc_xml_url = ENV["CC_XML_URL"]
    end

    def watch_server
      open(@cc_xml_url)
    end
  end
end