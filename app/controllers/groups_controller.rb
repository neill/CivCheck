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
        @players = Hash.new do |hsh, key|
            hsh[key] = {
                id: key,
                gamelist: "",
                personaname: "",
                avatarurl: ""
            }
        end
        @group.steamid_name.each do |x|
            gamelist = HTTParty.get('http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=' + ENV['STEAM_API_KEY'] + '&steamid=' + x + '&format=json')
            user = HTTParty.get('http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=' + ENV['STEAM_API_KEY'] + '&steamids=' + x )
            Rails.logger.info(user['response']['players'][0]['personaname'])
            @players[x][:gamelist] = gamelist['response']['games']
            @players[x][:personaname] = user['response']['players'][0]['personaname']
            @players[x][:avatarurl] = user['response']['players'][0]['avatar']
        end
    end

    def create
        @group = Group.new
        @group.steamid_name = []
        params[:steamid_arr].delete_if { |k,v| v.blank? }
        params[:steamid_arr].each do |x, y|
            vanity = HTTParty.get('http://api.steampowered.com/ISteamUser/ResolveVanityURL/v0001/?key=' + ENV['STEAM_API_KEY'] + '&vanityurl=' + y )
            steamid = vanity['response']['steamid']
            @group.steamid_name << steamid
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
