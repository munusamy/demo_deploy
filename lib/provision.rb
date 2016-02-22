require 'aws-sdk'

module Provision 
  class Deploy

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
      
    end 

    def show_details
      sleep 40
      @desc = @ec2.describe_instances({
      dry_run: false,
      instance_ids: [ @inst_id ]
      })
      @ans = Hash.new
      #@ans[:instance_id] = @resp.instances[0].instance_id
      #@ans[:public_dns_name] = @desc.reservations[0].instances[0].public_dns_name
      @ans[:pubip] = @desc.reservations[0].instances[0].public_ip_address
      @ans[:pvtip] = @resp.instances[0].private_ip_address
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
