get '/' do
  # Look in app/views/index.erb
  erb :index
end

get '/tag/:name' do
  @tag = Tag.find_all_by_name(params[:name])[0]
  erb :tag
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

post '/new-post' do
  params[:title]
  params[:description]
  params[:tags]

  post = Post.create(:title => params[:title], 
                     :body => params[:description])

  tags = params[:tags].split(",")

  tags.each do |tag_string|
    existing_tags = Tag.find_all_by_name(tag_string)
    if existing_tags.length != 0
      post.tags << existing_tags.first
    elsif existing_tags.length == 0
      new_tag = Tag.create(:name => tag_string)
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

  @post_to_edit.update_attributes(:title => params[:title],
    :body => params[:body])
  
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
end
