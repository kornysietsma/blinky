require File.join(File.dirname(__FILE__), "..", "/spec_helper")
require "ci_server_plugins/cruise_control_plugin"

module Blinky
  describe "CruiseControlPlugin" do
    let(:plugin) { CruiseControlPlugin.new }
    let(:cc_project) { "foo" }
    let(:cc_url) { "http://jenkins.org/cc.xml" }
    let(:cc_xml) { "<Projects><Project name='foo' activity='Sleeping' lastBuildStatus='Success'></Project></Projects>" }

    before :each do
      ENV.stub(:[]).with("BLINKY_CC_URL").and_return(cc_url)
      ENV.stub(:[]).with("BLINKY_CC_PROJECT").and_return(cc_project)

      plugin.stub(:open).and_return(cc_xml)
    end

    it "will take URL to cc.xml from environment" do
      CruiseControlPlugin.new.cc_url.should == cc_url
    end

    it "will open the URL specified" do
      plugin.should_receive(:open).with(cc_url)
      plugin.watch_server
    end

    describe "parsing cc.xml" do
      let(:doc) { mock(Nokogiri::XML::Document).as_null_object }
      let(:project_element) { mock(Nokogiri::XML::Element).as_null_object }

      before :each do
        Nokogiri::XML::Document.stub(:parse).and_return(doc)
        doc.stub(:xpath).and_return(project_element)
      end

      it "will take the project name from environment" do
        ENV.stub(:[]).with("BLINKY_CC_PROJECT").and_return("foo")
        CruiseControlPlugin.new.project_name.should == "foo"
      end

      it "will create an XML document with the response from the HTTP call" do
        Nokogiri::XML::Document.should_receive(:parse).with(cc_xml).and_return(doc)
        plugin.watch_server
      end

      it "will look for the project element in the cc.xml response" do
        doc.should_receive(:xpath).with("//Projects/Project[@name='#{cc_project}']").and_return(project_element)
        plugin.watch_server
      end

      it "will get the current activity for the project" do
        project_element.should_receive(:attr).with("activity")
        plugin.watch_server
      end

      it "will get the last build status for the project" do
        project_element.should_receive(:attr).with("lastBuildStatus")
        plugin.watch_server
      end
    end
  end
end