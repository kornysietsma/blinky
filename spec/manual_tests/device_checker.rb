require "blinky"

class DeviceChecker
  def initialize
    @blinky = Blinky.new
  end

  def check
    @blinky.light.watch_test_server
  end
end