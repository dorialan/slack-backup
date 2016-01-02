module ApplicationHelper
  def emojify(content)
    h(content).to_str.gsub(/:([\w+-]+):/) do |match|
      if emoji = Emoji.find_by_alias($1)
        %(<img alt="#$1" src="#{image_path("emoji/#{emoji.image_filename}")}" style="vertical-align:middle" width="20" height="20" />)
      else
        match
      end
    end.html_safe if content.present?
  end

  def slackify(content)
    if content.present?
      content_string = h(content).to_str

      content_string.gsub!(/&lt;(http(.)+)&gt;/) do |match|
        link_to $1, $1
      end

      content_string.gsub!(/&lt;@((.)+)&gt;/) do |match|
        slackname = $1.split("|")
        if slackname.count == 2
          name = slackname.last
        else
          users = User.pluck(:external_id, :name).to_h
          name = users.fetch($1, "Noname")
        end
        %(<span class="media-heading label label-warning">#{name}</span>)
      end

      content_string.gsub!(/&lt;!((.)+)&gt;/) do |match|
        %(<span class="media-heading label label-warning">#$1</span>)
      end

      content_string.html_safe
    end
  end

  def decorate(content)
    content = slackify(content)
    content = emojify(content)
  end
end
