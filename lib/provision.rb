require 'aws-sdk'
require 'parallel'
require 'yaml'

module Provision 
  class Deploy

    cred = YAML.load_file('/home/vagrant/demo_deploy/config/aws_credential.yml')

    Aws.config.update({
      region: 'us-west-2',
      credentials: Aws::Credentials.new(cred['credential']['aws_access_key_id'], cred['credential']['aws_secret_access_key'])
    })


    def run_server
      @ec2 = Aws::EC2::Client.new()

      @resp = @ec2.run_instances({
        dry_run: false,
        image_id: "ami-f0091d91", # required
        min_count: 1, # required
        max_count: 1, # required
        key_name: "chef-analytic",
        security_groups: ["Chef Server -FREE 5 Nodes--12-2-0-1-AutogenByAWSMP-"],
        instance_type: "t2.micro"
      })
      @inst_id = @resp.instances[0].instance_id 
      show_details
    end

    def ssh_run
      #later use 
    end 

    def show_details
      sleep 20 
      @desc = @ec2.describe_instances({
      dry_run: false,
      instance_ids: [ @inst_id ]
      })
      @ans = Hash.new
      @ans[:instance_id] = @resp.instances[0].instance_id
      #@ans[:public_dns_name] = @desc.reservations[0].instances[0].public_dns_name
      @ans[:public_ip] = @desc.reservations[0].instances[0].public_ip_address
      @ans[:private_ip] = @resp.instances[0].private_ip_address
      #@ans[:private_dns_name] = @resp.instances[0].private_dns_name
      @ans
=begin
      @ans.push(@resp.instances[0].instance_id)
      @ans.push(@desc.reservations[0].instances[0].public_dns_name)
      @ans.push(@desc.reservations[0].instances[0].public_ip_address)
      @ans.push(@resp.instances[0].private_dns_name)
      @ans.push(@resp.instances[0].private_ip_address)
=end
    end
  end
end

module Enumerable
def in_parallel_n(n)
  todo = Queue.new # Create queue
  ts = (1..n).map{ # Start threads
      Thread.new{
        # Do stuff in threads
        puts "starting"
        Provision::Deploy.new.run_server
        puts "Finished"
      }
    }
    .each{|x| todo << x} # Push things into queue 
    ts.each{|t| t.join} # Wait until threads finish 
end
end
#@a.join
#
class Test
  include Enumerable
end

m = Test.new
m.in_parallel_n(4)
