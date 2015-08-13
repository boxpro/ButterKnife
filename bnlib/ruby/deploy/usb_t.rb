module Butterknife
  module Deploy
    class Tether
      require 'net/scp'

      puts "USB Tether Deployment is done by connecting the RoboRIO to your Computer using the included USB Cable.".green
      puts "Please ensure your RoboRIO is connected to the computer via USB (hit <brown>ENTER<cyan> when ready)<brown>".format
      gets

      IP_ADDR = "172.22.11.2"
      begin
        Net::SCP.upload!(IP_ADDR, "admin", "bnlib/bin/root/.", "/", :recursive => true, :ssh => { :password => "" })
      rescue => e
        puts "Something went wrong during deployment... Are you sure your RoboRIO is plugged in?".red
        puts e
        gets
        exit
      end
      puts "Deployment Successful!".green
      gets
    end
  end
end
