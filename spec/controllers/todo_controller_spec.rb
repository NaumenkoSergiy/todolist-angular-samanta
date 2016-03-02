require 'rails_helper'

RSpec.describe TodoController, type: :controller do
  describe 'GET #index' do
    context 'when user is logged in' do
      sign_in_user

      before { get :index }

      it 'should have a current_user' do
        expect(subject.current_user).to_not be_nil
      end

      it { should respond_with :ok }
      it { should render_with_layout :application }
      it { should render_template :index }
    end

    context 'when user is logged out' do
      before { get :index }

      it 'should not have a current_user' do
        expect(subject.current_user).to be_nil
      end

      it { is_expected.to redirect_to new_user_session_path }
    end
  end
end
