json.extract! @comment, :id, :body, :created_at
json.user @comment.user.email