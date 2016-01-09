module ApplicationHelper
  def slackify(content)
    return unless content.present?
    content_string = h(content).to_str
    content_string = extract_emojis(content_string)
    content_string = extract_links(content_string)
    content_string = extract_names(content_string)
    content_string = extract_labels(content_string)
    content_string.html_safe
  end

  def decorate(content)
    slackify(content)
  end

  private

  def extract_emojis(content_string)
    content_string.gsub(/:([\w+-]+):/) do |emoji_alias|
      emoji = Emoji.find_by_alias(emoji_alias)
      if emoji
        emoji_image_tag(emoji)
      else
        emoji_alias
      end
    end
  end

  def emoji_image_tag(emoji)
    attributes = {
      alt: 'emoji_alias',
      style: 'vertical-align:middle',
      width: 20,
      height: 20
    }

    image_tag("emoji/#{emoji.image_filename}", attributes)
  end

  def extract_links(content_string)
    content_string.gsub(/&lt;(http(.)+)&gt;/) { |url| link_to url, url }
  end

  def extract_names(content_string)
    content_string.gsub(/&lt;@((.)+)&gt;/) do |name_or_id|
      slackname = name_or_id.split('|')
      if slackname.count == 2
        name = slackname.last
      else
        users = Hash[User.pluck(:external_id, :name)]
        name = users.fetch(name_or_id, 'Noname')
      end
      %(<span class="media-heading label label-warning">#{name}</span>)
    end
  end

  def extract_labels(content_string)
    content_string.gsub(/&lt;!((.)+)&gt;/) do |label|
      %(<span class="media-heading label label-warning">#{label}</span>)
    end
  end
end
