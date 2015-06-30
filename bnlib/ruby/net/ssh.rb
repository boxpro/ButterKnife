require 'net/ssh'

module Butterknife
  module Network
    class SSH

      def self.connect &block
        puts "Please input your Team Number...".green
        team = gets.chop!
        puts "Attempting to connect to <green>roborio-#{team}.local<cyan>".format
        begin
          Net::SSH.start("roborio-#{team}.local", "lvuser", &block)
        rescue
          begin
            split_str = team.rjust(4, "0").scan /.{2}/
            ip_addr = "10.#{split_str[0]}.#{split_str[1]}.2".format
            puts "Could not connect, trying: <green>#{ip_addr}<cyan>".format
            Net::SSH.start(ip_addr, "lvuser", &block)
          rescue
            puts "Still could not find RoboRIO, please input the IP Address of the RoboRIO...".cyan
            ip = gets.chop!
            Net::SSH.start(ip, "lvuser", &block)
          end
        end
      end

    end
  end
end
