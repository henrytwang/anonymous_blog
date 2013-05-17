require 'faker'

10.times do 
  Tag.create(:name => Faker::Lorem.words(1)[0])
end

10.times do
  Post.create(:title => Faker::Lorem.word,
              :body => Faker::Lorem.sentences(3).join(" ")).tags << Tag.find(rand(1..10))

end
