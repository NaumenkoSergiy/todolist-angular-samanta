require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  sign_in_user

  before(:each) { json_accept_headers }

  it 'should have a current_user' do
    expect(subject.current_user).to_not be_nil
  end

  it 'rescues from CanCan::AccessDenied' do
    allow(controller).to receive(:authorize!).and_raise(CanCan::AccessDenied)
    post :create
    expect(response.body).to eq('You are not authorized to access this page.')
  end

  describe 'GET #index' do
    let!(:user) { create(:user) }
    let!(:project) { create(:project, user_id: user.id) }
    let!(:task) { create(:task, project_id: project.id) }
    let!(:comment) { create(:comment, task_id: task.id) }

    it 'returns curent users projects' do
      allow(controller).to receive(:current_user) { user }

      get :index

      expect(assigns(:projects)).to_not be_nil
      expect(json_response.first.keys).to be_include(:tasks)
      expect(json_response.first[:tasks].first.keys).to be_include(:comments)
      expect(json_response.first[:tasks].first[:comments].first.keys).to be_include(:attachments)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a project' do
        expect{
          post :create, project: attributes_for(:project)
        }.to change(Project, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a project' do
        expect{
          post :create, project: attributes_for(:invalid_project)
        }.to_not change(Project, :count)
      end

      it 'returns an error' do
        post :create, project: attributes_for(:invalid_project)
        expect(response.status).to eq 422
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      let!(:project) { create(:project, user_id: subject.current_user.id) }
      let(:attributes) { attributes_for(:project, name: 'New project name') }

      it 'does not change projects count' do
        expect{
          patch :update, id: project, project: attributes
        }.to_not change(Project, :count)
      end

      it 'changes a project name' do
        patch :update, id: project, project: attributes
        expect(project.reload.name).to eq attributes[:name]
      end
    end

    context 'with invalid attributes' do
      let!(:project) { create(:project, user_id: subject.current_user.id) }
      let(:attributes) { attributes_for(:invalid_project) }

      it 'does not change a project name' do
        patch :update, id: project, project: attributes
        expect(project.reload.name).to_not eq attributes[:name]
      end

      it 'returns an error' do
        patch :update, id: project, project: attributes
        expect(response.status).to eq 422
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:project) { create(:project, user_id: subject.current_user.id) }

    it 'deletes a project' do
      expect { delete :destroy, id: project }.to change(Project, :count).by(-1)
    end
  end
end
