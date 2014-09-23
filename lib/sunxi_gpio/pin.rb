require 'sunxi-gpio/gpio_lib'
require 'sunxi-gpio/pin_values'

module SunxiGPIO
  class Pin
    attr_reader :pin, :last_value, :direction, :invert

    include SunxiGPIO::PinValues

    
    # Cleanup GPIO interface to make it available for other programs
    
    def self.close
      ::Gpio_lib.sunxi_gpio_cleanup
    end

    
    def self.open
      ::Gpio_lib.sunxi_gpio_init
    end


    def initialize(options)
      options = {
        direction: :in,
        invert: false,
        pull: :off
      }.merge(options)

      @pin = symbol_to_pin(options[:pin])
      @direction = options[:direction]
      @invert = options[:invert]
      @pull = options[:pull]
      
      raise "Invalid pull mode. Options are :up, :down or :float (default)" unless [:up, :down, :float, :off].include? @pull
      raise "Unable to use pull-ups : pin direction must be ':in' for this" if @direction != :in && [:up, :down].include?(@pull)
      raise "Invalid direction. Options are :in or :out" unless [:in, :out].include? @direction

      if @direction == :out
        ::Gpio_lib.sunxi_gpio_set_cfgpin(@pin, GPIO_DIRECTION_OUTPUT)
      else
        ::Gpio_lib.sunxi_gpio_set_cfgpin(@pin, GPIO_DIRECTION_INPUT)
      end
      
      pull!(@pull)
      read
    end

    
    # If the pin has been initialized for output this method will set the logic level high.
    
    def on
      ::Gpio_lib.sunxi_gpio_output(@pin, GPIO_HIGH) if direction == :out
    end

    # If the pin has been initialized for output this method will set the logic level low
    
    def off
      ::Gpio_lib.sunxi_gpio_output(@pin, GPIO_LOW) if direction == :out
    end

    
    def read
      @last_value = @value
      val = ::Gpio_lib.sunxi_gpio_input(@pin)
      @value = invert ? (val ^ 1) : val
    end

    
    def pull!(state)
      return nil if @direction != :in
      
      @pull = case state
                when :up then
                  GPIO_PUD_UP
                when :down then
                  GPIO_PUD_DOWN
                # :float and :off are just aliases
                when :float, :off then
                  GPIO_PUD_OFF
                else
                  nil
              end
      
      #### Not working yet
      # ::Gpio_lib.sunxi_gpio_set_pull(@pin, @pull) if @pull
      @pull
    end


    # If the pin direction is input, it will return the current state of pull-up/pull-down resistor,
    # either :up, :down or :off.
    
    def pull?
      case @pull
        when GPIO_PUD_UP then
          :up
        when GPIO_PUD_DOWN then
          :down
        else
          :off
      end
    end

    
    # Tests if the logic level has changed since the pin was last read.
    
    def changed?
      last_value != value
    end
        
    
    # Watch the pin to change to the watch_value (ON or OFF) - it only triggered
    # when switching from invert value to new value
    
    def watch(watch_value, &block)
      new_thread = Thread.new do
        prev_value = (self.read == GPIO_HIGH ? GPIO_LOW : GPIO_HIGH)

        loop do
          current_value = self.read
          flip = (prev_value != current_value)

          if current_value == watch_value && flip
            self.instance_exec &block
          end

          prev_value = current_value

          sleep WATCH_POLLING_SEC
        end
      end

      new_thread.abort_on_exception = true
      new_thread
    end
    
    
    private
    
    def symbol_to_pin(symbol)
      PINS[symbol]
    end
  end
end
