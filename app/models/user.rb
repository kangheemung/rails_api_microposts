class User < ApplicationRecord
    has_many :microposts, class_name: "micropost"
end
