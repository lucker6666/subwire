module MessagesHelper
  def get_is_important_text(v)
    v ? 'Message is unimportant' : 'Message is important'
  end
end