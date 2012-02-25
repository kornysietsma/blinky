require "nokogiri"
require "open-uri"

module Blinky
  class CruiseControlPlugin

    attr_reader :cc_url, :project_name

    def initialize
      @cc_url = ENV["BLINKY_CC_URL"]
      @project_name = ENV["BLINKY_CC_PROJECT"]
    end

    def watch_server
      doc = Nokogiri::XML::Document.parse(open(@cc_url))
      project_element = doc.xpath("//Projects/Project")
      activity = project_element.attr("activity")
      last_build_status = project_element.attr("lastBuildStatus")
    end
  end
end