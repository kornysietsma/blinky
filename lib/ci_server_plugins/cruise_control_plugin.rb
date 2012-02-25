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
      build_info = poll_cc

      if build_info[:last_build_status] == "Success"
        success!
      end
    end

    private

    def poll_cc
      doc = Nokogiri::XML::Document.parse(open(@cc_url))
      project_element = doc.xpath("//Projects/Project[@name='#{@project_name}']")

      activity = project_element.attr("activity")
      last_build_status = project_element.attr("lastBuildStatus")

      return {:activity => activity, :last_build_status => last_build_status}
    end
  end
end