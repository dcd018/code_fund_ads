# frozen_string_literal: true

class UserSearchesController < ApplicationController
  def create
    session[:user_search] = UserSearch.new(user_search_params).to_gid_param
    redirect_to users_path
  end

  def destroy
    session[:user_search] = UserSearch.new.to_gid_param
    redirect_to users_path
  end

  private

    def user_search_params
      params.require(:user_search).permit(:name, :email, :company_name, roles: [])
    end
end
