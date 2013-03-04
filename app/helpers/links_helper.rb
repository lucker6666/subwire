module LinksHelper
  def display_down_link?(idx, size)
    idx < size - 1
  end

  def display_up_link?(idx)
    idx >= 1
  end
end