require File.join(File.dirname(__FILE__), "..", "/spec_helper")
require "ci_server_plugins/cruise_control_plugin"

module Blinky
  describe "CruiseControlPlugin" do
    it "will take URL to cc.xml from environment" do
      ENV.stub(:[]).with("CC_XML_URL").and_return("foo")
      CruiseControlPlugin.new.cc_xml_url.should == "foo"
    end
  end
end