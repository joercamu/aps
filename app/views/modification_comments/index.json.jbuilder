json.array!(@modification_comments) do |modification_comment|
  json.extract! modification_comment, :id, :modification_id, :user_id, :body
  json.url modification_comment_url(modification_comment, format: :json)
end
