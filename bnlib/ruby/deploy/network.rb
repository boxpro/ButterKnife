module Butterknife
  module Deploy
    class Network
      require 'net/scp'
      require_relative '../net/ssh'

      puts "Network Deployment is done by connecting to the same network as your RoboRIO.".green
      puts "Please ensure your computer is on the same network as your RoboRIO (hit <brown>ENTER<cyan> when ready)<brown>".format
      gets

      begin
        Butterknife::Network::SSH.connect do |ssh|
          ssh.scp.upload!("bnlib/bin/root/.", "/", :recursive => true)
        end
      rescue => e
        puts "Something went wrong during deployment... Are you sure you're on the RoboRIO network?".red
        puts e
        gets
        exit
      end

      puts "Deployment Successful!".green
      gets
    end
  end
end
