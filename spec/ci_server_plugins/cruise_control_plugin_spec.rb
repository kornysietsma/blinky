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

    describe "parsing cc.xml" do
      let(:cc_xml) { "<Projects><Project activity='Sleeping' lastBuildStatus='Success'></Project></Projects>" }

      before :each do
        cc_plugin.stub(:open).and_return(cc_xml)
      end

      it "will create an XML document with the response from the HTTP call" do
        doc = mock(Nokogiri::XML::Document).as_null_object
        Nokogiri::XML::Document.should_receive(:parse).with(cc_xml).and_return(doc)
        
        cc_plugin.watch_server
      end

      it "will look for the project element in the cc.xml response" do
        doc = mock(Nokogiri::XML::Document)
        doc.should_receive(:xpath).with("//Projects/Project")
        Nokogiri::XML::Document.stub(:parse).and_return(doc)

        cc_plugin.watch_server
      end
    end
  end
end