module UserFinder
    extend ActiveSupport::Concern

    private 

    def get_user
        @user = User.find params[:id]
    end
end