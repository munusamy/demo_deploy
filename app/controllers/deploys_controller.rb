class DeploysController < ApplicationController
  def new
    @server = Deploy.new    
  end

  def details
  end

  def create
    @data = @server.show_details
    @create_server = Deploy.new(params[:id])
    if @server.save
      puts "#{@server} details saved"   
    else
      render 'new'
    end
  end
  
  def show
    @server = Deploy.all
  end
 
  
end
