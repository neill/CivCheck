class Group < ActiveRecord::Base
    serialize :steamid_name
    before_create :randomize_id

    private
    def randomize_id
        begin
            self.id = SecureRandom.random_number(10_000_000)
        end while Group.where(id: self.id).exists?
    end
end
