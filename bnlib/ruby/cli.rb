require_relative 'pretty.rb'
require_relative 'util'
require 'rubygems'

trap("INT") {exit}

module Butterknife
  DEPLOYMENT_METHODS = {
    "USB Tether Deployment": "usb_t.rb",
    "USB Drive Deployment": "usb.rb",
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
    begin
      Butterknife::Fetch::Toast.download_latest
    rescue
      puts "Couldn't check for Toast Updates. You might not be connected to the internet :(".red
      if ENV["TOAST_LOCAL"] == "NONE"
        puts "No local Toast Files found... Installer cannot continue.".red
        exit
      end
    end
    echo_options

  end
end
