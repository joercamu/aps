json.extract! @comment, :id, :body, :created_at
json.user @comment.user.email
json.username @comment.user.email.split('@').first