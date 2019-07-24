class TopUrlsController < ApplicationController
  def index
    posts = Post.order(created_at: :desc)
    render json: { status: 'SUCCESS', message: 'loaded posts', data: posts }
  end

  private

  def post_params
    params.require(:post).permit(:title)
  end
end
