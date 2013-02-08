module MessagesHelper
  def get_is_important_text(v)
    v ? 'unmark important' : 'mark as important'
  end
end