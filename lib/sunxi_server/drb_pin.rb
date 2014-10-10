require 'drb/drb'
require 'sunxi_gpio/pin'

module SunxiServer

# Implement the Pin Class in DRB by forwarding all calls to the PinObject stored in the Factory

  class DRB_Pin

    #DRB_Pin is runned as a proxy object :http://codeidol.com/community/ruby/proxying-objects-that-cant-be-distributed/24291/
    include DRb::DRbUndumped

    def initialize(options)
      @pin=SunxiGPIO::Pin.new(options)
    end

    # Forward all methods to the instance of @pin=SunxiGPIO::Pin
    def method_missing(method, *args, &block)
      @pin.send(method, *args, &block)
    rescue NoMethodError # you can also add this
      puts "#{method} is undefined in both inner and outer classes"
    end

    # To be called from client thread
    def client_watch(watch_value, &block)

      prev_value = (self.read == SunxiGPIO::PinValues::GPIO_HIGH ? SunxiGPIO::PinValues::GPIO_LOW : SunxiGPIO::PinValues::GPIO_HIGH)

      loop do

        current_value = @pin.read
        flip = (prev_value != current_value)
        yield if current_value == watch_value && flip
        prev_value = current_value

        sleep 0.1
      end
    end

  end

  # Generate new Pins and keep context

  class DRB_PinFactory

    def initialize
      @pins ={}
      SunxiGPIO::Pin.open
    end

    # Create a new pin, options are the same as for Pin.new
    def new_pin(options)
      pin_name = options[:pin].untaint
      if !@pins.has_key? pin_name then
        @pins[pin_name]=DRB_Pin.new(options)
      end
      return @pins[pin_name]
    end


  end
end

