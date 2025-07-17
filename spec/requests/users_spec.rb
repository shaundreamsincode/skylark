require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { create(:user) }
  let(:valid_user_params) do
    {
      user: {
        first_name: 'John',
        last_name: 'Doe',
        email: 'john.doe@example.com',
        password: 'password123',
        password_confirmation: 'password123',
        bio: 'A software developer passionate about building great products.'
      }
    }
  end

  describe 'GET /users/:id' do
    context 'when user is logged in' do
      before do
        login_as(user)
      end

      it 'returns http success' do
        get user_path(user)
        expect(response).to have_http_status(:success)
      end

      it 'assigns the requested user' do
        get user_path(user)
        expect(assigns(:user)).to eq(user)
      end

      it 'renders the show template' do
        get user_path(user)
        expect(response).to render_template(:show)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to login page' do
        get user_path(user)
        expect(response).to redirect_to(login_path)
      end
    end

    context 'when user does not exist' do
      before do
        login_as(user)
      end

      it 'raises ActiveRecord::RecordNotFound' do
        expect {
          get user_path(999999)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'GET /signup' do
    context 'when user is not logged in' do
      it 'returns http success' do
        get signup_path
        expect(response).to have_http_status(:success)
      end

      it 'assigns a new user' do
        get signup_path
        expect(assigns(:user)).to be_a_new(User)
      end

      it 'renders the new template' do
        get signup_path
        expect(response).to render_template(:new)
      end
    end

    context 'when user is already logged in' do
      before do
        login_as(user)
      end

      it 'redirects to dashboard' do
        get signup_path
        expect(response).to redirect_to(dashboard_path)
      end
    end
  end

  describe 'POST /users' do
    context 'with valid parameters' do
      it 'creates a new user' do
        expect {
          post users_path, params: valid_user_params
        }.to change(User, :count).by(1)
      end

      it 'logs in the user' do
        post users_path, params: valid_user_params
        expect(session[:user_id]).to eq(User.last.id)
      end

      it 'redirects to dashboard with success message' do
        post users_path, params: valid_user_params
        expect(response).to redirect_to(dashboard_path)
        expect(flash[:notice]).to eq('Welcome to Skylark! Your account has been created successfully.')
      end

      it 'creates user with correct attributes' do
        post users_path, params: valid_user_params
        user = User.last
        expect(user.first_name).to eq('John')
        expect(user.last_name).to eq('Doe')
        expect(user.email).to eq('john.doe@example.com')
        expect(user.bio).to eq('A software developer passionate about building great products.')
      end
    end

    context 'with invalid parameters' do
      context 'when email is missing' do
        let(:invalid_params) do
          {
            user: {
              first_name: 'John',
              last_name: 'Doe',
              email: '',
              password: 'password123',
              password_confirmation: 'password123',
              bio: 'A software developer.'
            }
          }
        end

        it 'does not create a new user' do
          expect {
            post users_path, params: invalid_params
          }.not_to change(User, :count)
        end

        it 'renders the new template' do
          post users_path, params: invalid_params
          expect(response).to render_template(:new)
        end

        it 'returns unprocessable entity status' do
          post users_path, params: invalid_params
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'assigns user with errors' do
          post users_path, params: invalid_params
          expect(assigns(:user).errors).to be_present
        end
      end

      context 'when email is already taken' do
        before do
          create(:user, email: 'john.doe@example.com')
        end

        it 'does not create a new user' do
          expect {
            post users_path, params: valid_user_params
          }.not_to change(User, :count)
        end

        it 'renders the new template' do
          post users_path, params: valid_user_params
          expect(response).to render_template(:new)
        end

        it 'returns unprocessable entity status' do
          post users_path, params: valid_user_params
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'when password is too short' do
        let(:short_password_params) do
          {
            user: {
              first_name: 'John',
              last_name: 'Doe',
              email: 'john.doe@example.com',
              password: '123',
              password_confirmation: '123',
              bio: 'A software developer.'
            }
          }
        end

        it 'does not create a new user' do
          expect {
            post users_path, params: short_password_params
          }.not_to change(User, :count)
        end

        it 'renders the new template' do
          post users_path, params: short_password_params
          expect(response).to render_template(:new)
        end

        it 'returns unprocessable entity status' do
          post users_path, params: short_password_params
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'when password confirmation does not match' do
        let(:mismatched_password_params) do
          {
            user: {
              first_name: 'John',
              last_name: 'Doe',
              email: 'john.doe@example.com',
              password: 'password123',
              password_confirmation: 'differentpassword',
              bio: 'A software developer.'
            }
          }
        end

        it 'does not create a new user' do
          expect {
            post users_path, params: mismatched_password_params
          }.not_to change(User, :count)
        end

        it 'renders the new template' do
          post users_path, params: mismatched_password_params
          expect(response).to render_template(:new)
        end

        it 'returns unprocessable entity status' do
          post users_path, params: mismatched_password_params
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'when first name is missing' do
        let(:missing_first_name_params) do
          {
            user: {
              first_name: '',
              last_name: 'Doe',
              email: 'john.doe@example.com',
              password: 'password123',
              password_confirmation: 'password123',
              bio: 'A software developer.'
            }
          }
        end

        it 'does not create a new user' do
          expect {
            post users_path, params: missing_first_name_params
          }.not_to change(User, :count)
        end

        it 'renders the new template' do
          post users_path, params: missing_first_name_params
          expect(response).to render_template(:new)
        end

        it 'returns unprocessable entity status' do
          post users_path, params: missing_first_name_params
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'when last name is missing' do
        let(:missing_last_name_params) do
          {
            user: {
              first_name: 'John',
              last_name: '',
              email: 'john.doe@example.com',
              password: 'password123',
              password_confirmation: 'password123',
              bio: 'A software developer.'
            }
          }
        end

        it 'does not create a new user' do
          expect {
            post users_path, params: missing_last_name_params
          }.not_to change(User, :count)
        end

        it 'renders the new template' do
          post users_path, params: missing_last_name_params
          expect(response).to render_template(:new)
        end

        it 'returns unprocessable entity status' do
          post users_path, params: missing_last_name_params
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'when user is already logged in' do
      before do
        login_as(user)
      end

      it 'does not create a new user' do
        expect {
          post users_path, params: valid_user_params
        }.not_to change(User, :count)
      end

      it 'redirects to dashboard' do
        post users_path, params: valid_user_params
        expect(response).to redirect_to(dashboard_path)
      end
    end
  end

  describe 'parameter filtering' do
    it 'only permits allowed parameters' do
      malicious_params = {
        user: {
          first_name: 'John',
          last_name: 'Doe',
          email: 'john.doe@example.com',
          password: 'password123',
          password_confirmation: 'password123',
          bio: 'A software developer.',
          super_admin: true, # This should be filtered out
          created_at: 1.day.ago # This should be filtered out
        }
      }

      post users_path, params: malicious_params
      user = User.last
      
      expect(user.super_admin).to be false
      expect(user.created_at).not_to eq(1.day.ago)
    end
  end
end