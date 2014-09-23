sunxi-gpio-gem
==============

Native Ruby Extension to work with Sunxi GPIO. This gem is currently **beta**. It supports writing, reading, watching.  



## Installtion

```
gem install sunxi-gpio
```


## Usage

### Simple writing

```ruby
require 'sunxi_gpio/pin'

pin = SunxiGPIO::Pin.new(pin: :PB2, direction: :out)
pin.on
sleep 1
pin.off
```


### Watching

```ruby
  pin_input.watch(0) do
  puts "***** I am in the block.... YEAH************"
end
```


## Contributors

* [phortx](https://github.com/phortx)
* [happychriss](https://github.com/happychriss)
