class String
  def to_bool
    (self.to_s =~ /^true$/i) == 0
  end
end