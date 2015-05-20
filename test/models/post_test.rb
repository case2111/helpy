# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  topic_id   :integer
#  user_id    :integer
#  body       :text
#  kind       :string
#  active     :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class PostTest < ActiveSupport::TestCase

  should belong_to(:topic)
  should belong_to(:user)
  should validate_presence_of(:body)
  should validate_presence_of(:kind)

  # first post should be kind first
  # post belonging to a topic with multiple posts should be a reply

  test "a new post should also add to the topic cache field for searchability" do

    @user = User.first
    assert_difference 'Topic.count', 1 do
      @topic = Topic.create(forum_id: 1, name: "Test topic", user_id: @user.id)
    end
    assert_difference 'Post.count', 1 do
      @post = @topic.posts.create(body: "this is a reply", kind: "first", user_id: @user.id)
    end

    assert @topic.post_cache == " #{@post.body}"

  end

end
