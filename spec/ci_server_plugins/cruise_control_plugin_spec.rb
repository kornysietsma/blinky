require File.join(File.dirname(__FILE__), "..", "/spec_helper")
require "ci_server_plugins/cruise_control_plugin"

module Blinky
  describe "CruiseControlPlugin" do
    let(:cc_plugin) { CruiseControlPlugin.new }
    let(:cc_xml_url) { "http://jenkins.org/cc.xml" }

    before :each do
      ENV.stub(:[]).with("CC_XML_URL").and_return(cc_xml_url)
    end

    it "will take URL to cc.xml from environment" do
      CruiseControlPlugin.new.cc_xml_url.should == cc_xml_url
    end

    it "will connect to URL specified" do
      cc_plugin.should_receive(:open).with(cc_xml_url)
      cc_plugin.watch_server
    end

    it "will create an XML document with the response from the HTTP call" do
      cc_xml = "<foo></foo>"
      cc_plugin.stub(:open).and_return(cc_xml)
      Nokogiri::XML.should_receive(:parse).with(cc_xml)
      cc_plugin.watch_server
    end
  end
end