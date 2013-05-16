require 'bcrypt'

get '/' do
  # Look in app/views/index.erb
  erb :index
end

get '/tag/:name' do
  @tag = Tag.find_all_by_name(params[:name])[0]
  erb :tag
end

get '/users/:user/posts' do
  @user = User.find_all_by_id(params[:user])[0]
  erb :user_posts
end


post '/edit-post' do
  @post = params[:id]
  redirect "/edit/#{@post}"
end

post '/delete-post' do
  post_id = params[:id]
  Post.find_all_by_id(post_id)[0].destroy
  erb :index
end

post '/delete-tag' do
  tag_id = params[:id]
  Tag.find_all_by_id(tag_id)[0].destroy
  erb :index
end

post '/new-post' do
  post = Post.create(:title                 => params[:title], 
                     :body                  => params[:description],
                     :authenticated_user_id => session[:user_id])

  tags = params[:tags].split(",")

  tags.each do |tag_string|
    existing_tags = Tag.find_all_by_name(tag_string)
    if existing_tags.length != 0
      post.tags << existing_tags.first
    elsif existing_tags.length == 0
      new_tag = Tag.create(:name => tag_string,
                           :authenticated_user_id => session[:user_id])
      post.tags << new_tag
    end
  end

  erb :index
end

get '/edit/:post' do
  post_id = params[:post]
  @post_to_edit = Post.find_all_by_id(post_id)[0]
  erb :edit
end

post '/update-post/:id' do
  @post_to_edit = Post.find_all_by_id(params[:id])[0]
  if session[:user_id] = @post_to_edit.authenticated_user_id

        @post_to_edit.update_attributes(:title => params[:title],
                                        :body  => params[:body])
        
        tags = params[:tags].split(", ")

        @post_to_edit.tags = []

        tags.each do |tag_string|
          existing_tags = Tag.find_all_by_name(tag_string)
          if existing_tags.length == 0
            new_tag = Tag.create(:name => tag_string)
            @post_to_edit.tags << new_tag 
          elsif !@post_to_edit.tags.map{|tag| tag.name }.include?(tag_string)
            @post_to_edit.tags << existing_tags.first 
          end
        end

        erb :index
  else
        erb :index
  end
end

post '/creation_success' do
  if user_already_exists?(params[:email])
    @duplicate_user = true
    erb :index
  else 
    encryp_psswd = BCrypt::Password.create(params[:password])
    user = User.create(:name     => params[:name],
                :email    => params[:email],
                :password => encryp_psswd)
    session[:user_id] = user.id
    @name = params[:name]
    erb :index
  end
end

post '/login' do
  if @user = User.authenticate(params[:email], params[:password])
    session[:user_id] = @user.id
    erb :index
  else
    erb :index
  end
end

post '/logout' do
  session.clear
  erb :index
end
