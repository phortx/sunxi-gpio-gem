require 'drb/drb'
require '//home/development/Projects/sunxi-gpio-gem/lib/sunxi_gpio/pin_values'

# The URI to connect to
SERVER_URI="druby://10.237.48.91:8780"

# Start a local DRbServer to handle callbacks.
#
# Not necessary for this small example, but will be required
# as soon as we pass a non-marshallable object as an argument
# to a dRuby call.

#Green light: PH07
#Orange light: PH20

puts "Starting Service"
DRb.start_service

puts "Connecting to: #{SERVER_URI}"
gpio_pins = DRbObject.new_with_uri(SERVER_URI)


puts "Output Test"
pin_output=gpio_pins.new_pin(pin: :PH20, direction: :out)
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







