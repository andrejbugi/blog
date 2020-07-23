require 'rails_helper'

RSpec.describe "Users" do
  it "creates a User and redirects to the User's page" do
    get '/signup'

    expect(response).to render_template(:new)

    post_params = {
      params: {
        user: {
          name: 'Andrej',
          email: 'andrej@and.com',
          password: '123123',
          password_confirmation: '123123'
        }
      }
    }

    post "/users", post_params

    expect(session[:user_id]).not_to be_nil
    expect(response).to redirect_to(assigns(:user))

    follow_redirect!
    expect(response).to render_template(:show)
    expect(response.body).to include('Andrej')
    expect(response.body).to include('andrej@and.com')
  end

  it "renders New when User params are empty" do
    get '/signup'

    expect(response).to render_template(:new)

    post_params = {
      params: {
        user: {
          name: '',
          email: '',
          password: '',
          password_confirmation: '',
        }
      }
    }

    post "/users", post_params

    expect(session[:user_id]).to be_nil
    expect(response).to render_template(:new)
  end

  describe 'Editing an article' do
    context 'when the article User is the same as the logged in User' do
      let(:user) { create(:user) }
      let(:article) { create(:article, user: user) }

      it 'can edit the article' do
        get '/login'

        expect(response).to have_http_status(:ok)

        post_params = {
          params: {
            session: {
              email: user.email,
              password: user.password
            }
          }
        }

        post '/login', post_params

        follow_redirect!
        expect(flash[:success]).to eq 'Succesfully logged in'

        get "/articles/#{article.id}"
        expect(response).to have_http_status(:ok)

        get "/articles/#{article.id}/edit"
        expect(response).to have_http_status(:ok)

        patch_params = {
          params: {
            article: {
              title: article.title,
              body: "New Body"
            }
          }
        }

        patch "/articles/#{article.id}", patch_params

        expect(response).to have_http_status(:found)

        expect(response).to redirect_to(assigns(:article))
        follow_redirect!

        expect(response.body).to include(article.title)
      end
    end

    context 'when the article User is different than the logged in User' do
      let(:user) { create(:user) }
      let(:article) { create(:article, user: user) }

      let(:login_user) { create(:user) }


      it 'redirect back to root path' do
        get '/login'

        post_params = {
          params: {
            session: {
              email: login_user.email,
              password: login_user.password
            }
          }
        }

        post '/login', post_params

        get "/articles/#{article.id}/edit"

        expect(flash[:danger]).to eq 'Wrong User'
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when no user is logged in' do
      let(:article) { create(:article) }

      it 'redirects back to root path' do
        get "/articles/#{article.id}/edit"

        expect(flash[:danger]).to eq 'You must be logged in!'
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'Deleting an article' do
    context 'when the article User is the same as the logged in User' do
      let(:user) { create(:user) }
      let(:article) { create(:article, user: user) }

      it 'can delete the article' do
        get '/login'

        post_params = {
          params: {
            session: {
              email: user.email,
              password: user.password
            }
          }
        }

        post '/login', post_params

        follow_redirect!

        delete "/articles/#{article.id}"

        expect(response).to redirect_to(articles_path)
      end
    end

    context 'when the article User is different than the logged in User' do
      let(:user) { create(:user) }
      let(:article) { create(:article, user: user) }

      let(:login_user) { create(:user) }

      it 'redirects back to root_path' do

        get '/login'

        post_params = {
          params: {
            session: {
              email: login_user.email,
              password: login_user.password
            }
          }
        }

        post '/login', post_params

        follow_redirect!

        delete "/articles/#{article.id}"

        expect(flash[:danger]).to eq 'Wrong User'
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when no user is logged in' do
      let(:article) { create(:article) }

      it 'redirect back to root path' do
        delete "/articles/#{article.id}"

        expect(flash[:danger]).to eq 'You must be logged in!'
        expect(response).to redirect_to(root_path)
      end
    end
  end
end