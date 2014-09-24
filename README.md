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


### Watching

```ruby
require 'sunxi_gpio/pin'

SunxiGPIO::Pin.open

pin = SunxiGPIO::Pin.new(pin: :PB2, direction: :out)

pin.watch do
  puts "Pin changed from #{last_value} to #{value}"
end

SunxiGPIO::Pin.close
```


## Contributors

* [phortx](https://github.com/phortx)
* [happychriss](https://github.com/happychriss)
