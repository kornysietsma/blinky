module Blinky
  class CruiseControlPlugin

    attr_reader :cc_xml_url

    def initialize
      @cc_xml_url = ENV["CC_XML_URL"]
    end

  end
end