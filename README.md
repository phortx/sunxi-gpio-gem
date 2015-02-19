sunxi_gpio gem
===============

Native Ruby Extension to work with Sunxi GPIO. This gem is currently **beta**. It supports writing, reading, watching.  



## Installtion

```
gem install sunxi_gpio
```


## Usage

### Simple writing

```ruby
require 'sunxi_gpio/pin'

SunxiGPIO::Pin.open

pin = SunxiGPIO::Pin.new(pin: :PB2, direction: :out)
pin.on
sleep 1
pin.off

SunxiGPIO::Pin.close
```

### Simple reading

```ruby
require 'sunxi_gpio/pin'

SunxiGPIO::Pin.open

pin = SunxiGPIO::Pin.new(pin: :PB2, direction: :in)

10.times do
  value = pin.read
  puts "result: #{value}"
  sleep 1
end

SunxiGPIO::Pin.close
```

### Watch
Watches the pin going to status in parameter and executes the block. 
Block will only be triggered with a status change is seen.

```ruby
require 'sunxi_gpio/pin'

SunxiGPIO::Pin.open

pin = SunxiGPIO::Pin.new(pin: :PB2, direction: :out)

pin.watch(SunxiGPIO::PinValues::GPIO_LOW) do
  puts "I am in the loop with value #{pin.read}"
end

SunxiGPIO::Pin.close

```
### Enable pull for a pin
When using pins as input, you can use internal resistors to pull the pin up or pull down. This is important if you use open-collector sensors
which have floating output in some states. Pull can be used as :up or :down -depending of the type of layout.

```ruby
SunxiGPIO::Pin.open

pin = SunxiGPIO::Pin.new(pin: :PI15, direction: :in, pull: :up)
value=pin.read

SunxiGPIO::Pin.close
```

## Running a GPIO Server to restrict root access
When accessing GPIO privileged access is needed. To avoid this, sunxi_server can be started with privileged access.
A client can run with with normal user rights and access the GPIO functionality.
Communication between Client and Server is done using Ruby DRB (dRuby is a distributed object system for Ruby, it is part
of the core Ruby)

### Start the Server with root access:

```ruby
 # The object that handles requests on the server
 require 'sunxi_server/drb_pin'
 
 URI="druby://localhost:8780"
 
 FRONT_OBJECT=SunxiServer::DRB_PinFactory.new
 
 $SAFE = 1 # disable eval() and friends
 
 puts "***** Start Service ****"
 DRb.start_service(URI, FRONT_OBJECT)
 
 # Wait for the drb server thread to finish before exiting.
 DRb.thread.join
```

### Start the Client without any privileges:
```ruby
require 'drb/drb'
require 'sunxi_gpio/pin'

SERVER_URI="druby://localhost:8780"

puts "Starting Service"
DRb.start_service

puts "Connecting to: #{SERVER_URI}"
gpio_pins = DRbObject.new_with_uri(SERVER_URI)


puts "Output Test"
pin_output=gpio_pins.new_pin(pin: :PI14, direction: :out)
pin_output.on
pin_output.off

puts "Input Test"
pin_input = gpio_pins.new_pin(pin: :PI15, direction: :in, pull: :up)
10.times do
  a=pin_input.read
  puts "result: #{a}"
  sleep(0.05)
end

puts "Watch for click test"

new_thread = Thread.new do
  pin_input.client_watch(0) do
    puts "blick:#{SERVER_URI}";
    pin_output.on
    sleep(1)
    pin_output.off
  end
end

new_thread.abort_on_exception = true
new_thread

puts "the end"
sleep(20)
```


## Contributors

* [phortx](https://github.com/phortx)
* [happychriss](https://github.com/happychriss)
