require 'rails_helper'

RSpec.describe "Article Comments" do
  describe 'GET articles comments' do
    let(:expected_comment_body) { 'Comment Body' }
    let(:comment) { create(:comment, body: expected_comment_body) }

    it 'shows the article comment' do
      get article_path(comment.article)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include expected_comment_body
    end
  end


end
