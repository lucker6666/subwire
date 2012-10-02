module LinksHelper
  def is_dn_link_showed?(idx, size)
    idx < size - 1
  end

  def is_up_link_showed?(idx)
    idx >= 1
  end
end