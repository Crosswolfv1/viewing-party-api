class UserSerializer
  include JSONAPI::Serializer
  attributes :name, :username, :api_key

  def self.format_user_list(users)
    { data:
        users.map do |user|
          {
            id: user.id.to_s,
            type: "user",
            attributes: {
              name: user.name,
              username: user.username
            }
          }
        end
    }
  end

  def self.user_details(user_id)
    user = User.find(user_id)
    { data: {
      id: user[:id],
      type: "user",
      attributes: {
        name: user[:name],
        username: user[:username],
        viewing_parties_hosted: user.hosted_viewing_party,
        viewing_parties_invited: user.invited_viewing_party
      }
      }
    }
  end
end