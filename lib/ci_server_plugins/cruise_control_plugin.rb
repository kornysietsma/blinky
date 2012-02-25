require "nokogiri"
require "open-uri"

module Blinky
  class CruiseControlPlugin

    attr_reader :cc_xml_url

    def initialize
      @cc_xml_url = ENV["CC_XML_URL"]
    end

    def watch_server
      doc = Nokogiri::XML::Document.parse(open(@cc_xml_url))
      project_element = doc.xpath("//Projects/Project")
      activity = project_element.attr("activity")
    end
  end
end