require_relative 'pretty.rb'
require_relative 'util'
require 'rubygems'

trap("INT") {exit}

module Butterknife
  DEPLOYMENT_METHODS = {
    "USB Drive Deployment": "usb.rb",
    "USB Tether Deployment": "usb_t.rb",
    "Network Deployment": "network.rb"
  }

  class CLI
    def self.echo_options
      puts "\nPlease select your preferred method of deployment:<brown>".format
      DEPLOYMENT_METHODS.each_with_index do |name, i|
        puts "\t[#{i}]<magenta> #{name[0]}<cyan>".format
      end
      user_selection = gets.chop!.to_i
      if user_selection >= DEPLOYMENT_METHODS.length
        puts "Invalid Option".red
        echo_options
      else
        option = DEPLOYMENT_METHODS[DEPLOYMENT_METHODS.keys[user_selection]]
        puts "Selected: <green>#{DEPLOYMENT_METHODS.keys[user_selection]}<cyan>".format
        require_relative "deploy/#{option}"
      end
    end

    puts File.read("#{LIBHOME}/ruby/splash.txt").format
    puts "\t\tToast ButterKnife CLI\n".green
    require_relative "fetch/toast"
    Butterknife::Fetch::Toast.download_latest

    echo_options

  end
end
