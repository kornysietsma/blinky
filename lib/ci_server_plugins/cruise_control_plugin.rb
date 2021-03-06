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
      build_info = parse(doc)
      switch_light(build_info)
    end

    private

    def parse(doc)
      project_element = parse_project_element(doc)
      return {:activity => parse_activity(project_element), :last_build_status => parse_last_build_status(project_element)}
    end

    def parse_project_element(doc)
      return doc.xpath("//Projects/Project[@name='#{@project_name}']")
    end

    def parse_activity(project_element)
      return project_element.attr("activity")
    end

    def parse_last_build_status(project_element)
      return project_element.attr("lastBuildStatus")
    end

    def switch_light(build_info)
      if build_info[:last_build_status] == "Success"
        if build_info[:activity] == "Building"
          building!
        else
          success!
        end
      elsif build_info[:last_build_status] == "Failure"
        failure!
      elsif build_info[:last_build_status] == "Exception"
        warning!
      end
    end
  end
end