module Api
  @@url = "https://dev.acnv.club/api/pokemon/user"

  def self.makeRequest(data = {})
    return pbPostData(@@url, data)
  end
end

# Using that in a script like his Main.rb would look like

# p Api.makeRequest()