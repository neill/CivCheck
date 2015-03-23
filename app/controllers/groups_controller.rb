class GroupsController < ApplicationController
    def index
        @group = Group.new
    end

    def new
        @group = Group.new
    end

    def edit
        @group = Group.find(params[:id])
    end

    def show
        @group = Group.find(params[:id])
    end

    def create
        @group = Group.new
        @group.steamid_name = []
        params[:steamid_arr].each do |x, y|
            @group.steamid_name << y
        end
        if @group.save
            redirect_to group_path(@group)
        else
            redirect_to root_path, alert: "Error checking ID's. Try again!"
        end
    end

    def update
    end

    def destroy
    end

    private
    def group_params
        params.require(:group).permit(:steamid, :steamid_name)
    end
end
