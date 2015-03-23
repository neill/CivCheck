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
            @players[x][:gamelist] = gamelist['response']['games']
            @players[x][:personaname] = user['response']['players'][0]['personaname']
            @players[x][:avatarurl] = user['response']['players'][0]['avatar']
        end

        @players.each do |key, array|
            array[:gamelist].each do |x|
                x.has_value?(235580) ? @bnw_class = 'full' : @bnw_class = 'dim'
                x.has_value?(16870) ? @gnk_class = 'full' : @gnk_class = 'dim'
                x.has_value?(235584) ? @scram_class = 'full' : @scram_class = 'dim'
                x.has_value?(235585) ? @scram_n_class = 'full' : @scram_n_class = 'dim'
                x.has_value?(16868) ? @baby_class = 'full' : @baby_class = 'dim'
                x.has_value?(16860) ? @med_class = 'full' : @med_class = 'dim'
                x.has_value?(16861) ? @asia_class = 'full' : @asia_class = 'dim'
                x.has_value?(16862) ? @amer_class = 'full' : @amer_class = 'dim'
                x.has_value?(16863) ? @meso_class = 'full' : @meso_class = 'dim'
                x.has_value?(16867) ? @spain_class = 'full' : @spain_class = 'dim'
                x.has_value?(99610) ? @poly_class = 'full' : @poly_class = 'dim'
                x.has_value?(99611) ? @den_class = 'full' : @den_class = 'dim'
                x.has_value?(16866) ? @expl_class = 'full' : @expl_class = 'dim'
                x.has_value?(99614) ? @scen_class = 'full' : @scen_class = 'dim'
                x.has_value?(99612) ? @kor_class = 'full' : @kor_class = 'dim'
            end
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
