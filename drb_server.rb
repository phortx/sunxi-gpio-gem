# The object that handles requests on the server
#require File.dirname(__FILE__) + '/sunxi_server/drb_pin'
require 'sunxi_server/drb_pin'
require 'drb'
require 'drb/acl'

list = %w[
          deny all
          allow localhost
          allow 10.237.48.*
]

acl = ACL.new(list, ACL::DENY_ALLOW)

DRb.install_acl(acl)

#URI='druby://localhost:8780'
URI='druby://10.237.48.91:8780'

FRONT_OBJECT=SunxiServer::DRB_PinFactory.new

$SAFE = 1 # disable eval() and friends

puts "***** Start Service at #{URI}****"
DRb.start_service(URI, FRONT_OBJECT)

# Wait for the drb server thread to finish before exiting.
DRb.thread.join

