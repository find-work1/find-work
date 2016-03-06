require 'faye'
require 'permessage_deflate'

bayeux = Faye::RackAdapter.new(:mount => '/faye', :timeout => 25)
bayeux.add_websocket_extension(PermessageDeflate)

run bayeux

