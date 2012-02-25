require File.join(File.dirname(__FILE__), "..", "/spec_helper")
require "ci_server_plugins/cruise_control_plugin"

module Blinky
  describe "CruiseControlPlugin" do
    let(:cc_xml_url) { "http://jenkins.org/cc.xml" }

    before :each do
      ENV.stub(:[]).with("CC_XML_URL").and_return(cc_xml_url)
    end

    it "will take URL to cc.xml from environment" do
      CruiseControlPlugin.new.cc_xml_url.should == cc_xml_url
    end

    it "will connect to URL specified" do
      cc_plugin = CruiseControlPlugin.new
      cc_plugin.should_receive(:open).with(cc_xml_url)
      cc_plugin.watch_server
    end
  end
end