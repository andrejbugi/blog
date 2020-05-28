class CommentsController < ApplicationController

  def create
    @comment = Article.find
  end



  def article_params
    params.require(:article).permit(:title, :body)
  end
end
