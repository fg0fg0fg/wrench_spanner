module ApplicationHelper

  def sort_posts(posts)
    if params[:latest]
      posts.latest
    elsif params[:old]
      posts.old
    elsif params[:star_count]
      posts.star_count
    else
      posts.latest
    end
  end

end
