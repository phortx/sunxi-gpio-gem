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


## Contributors

* [phortx](https://github.com/phortx)
* [happychriss](https://github.com/happychriss)
