require File.join(File.dirname(__FILE__), '/spec_helper')

module Blinky 
  
  module TestEngineering
    module TestModel           
      def success! 
        @handle.indicate_success
      end         
    end
  end
  
  module MockCiPlugin            
    def watch_mock_ci_server 
      notify_build_status
    end      
  end  
  
  module AnotherMockCiPlugin            
    def watch_another_mock_ci_server 
      notify_a_different_build_status
    end      
  end
  
  
  describe "Light" do
    
    describe "that has been constructed with a device, a device recipe, and some CI plugins" do

       before(:each) do
         @supported_device = OpenStruct.new(:idVendor => 0x2000, :idProduct => 0x2222)       
         @light = Light.new(@supported_device, TestEngineering::TestModel, [MockCiPlugin, AnotherMockCiPlugin ] )
       end

       it "can call recipe methods on the device" do
         @supported_device.should_receive(:indicate_success)
         @light.success!                  
       end
       
       it "can receive call back methods defined in a plugins" do
          @light.should_receive(:notify_build_status)
          @light.watch_mock_ci_server 
       end
       
       it "can receive call backs from a server via another plugin" do
          @light.should_receive(:notify_a_different_build_status)
          @light.watch_another_mock_ci_server                  
        end
          
     end     
  end
end
