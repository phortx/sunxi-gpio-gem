sunxi-gpio-gem
==============

Native Ruby Extension to work with Sunxi GPIO. This gem is currently under development and it only support wirting.



## Installtion

```
gem install sunxi-gpio
```


## Usage

```ruby
require 'sunxi-gpio/gpio'

pin = Sunxi::GPIO.new(Sunxi::GPIO::PINS[:PB2], Sunxi::GPIO::OUTPUT)
pin.write 1
sleep 1
pin.write 0
```
