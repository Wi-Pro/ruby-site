class CheckoutsController < ApplicationController
  def index
    @list = Membership.where(userid: current_user.id)
    @checkout = Checkout.new
    @checkouts = Checkout.where('updated_at > ?', 30.minutes.ago)
    $globaluserid = @current_user.id
  end

  def create
    @checkout = Checkout.new(checkout_params)
    @checkout.userid = current_user.id
    if @checkout.save
      flags_file = File.open("/home/rails/public/uploads/hex/#{Wiproid.find(@checkout.wiproid).wiproid}/flagfile.txt", "w+")
      flags_file.write("0 1")
      flags_file.close
      flash[:success] = "Checked out!"
      redirect_to "/"
    else
      render 'index'
    end
  end

  private

  def checkout_params
    params.require(:checkout).permit(:userid, :wiproid)
  end
end
