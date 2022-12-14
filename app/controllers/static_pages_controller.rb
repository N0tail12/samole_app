class StaticPagesController < ApplicationController
  def home
    return unless logged_in?

    @micropost = current_user.micropost.build
    @pagy, @feed_items = pagy current_user.feed, page: params[:page],
                                                 item: Settings.paginate.limit
  end

  def help; end

  def about; end

  def contact; end
end
