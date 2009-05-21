module FFI
  def self.alias_types(type,aliased)
    add_typedef(find_type(type),aliased.to_sym)
  end

  alias_types :uint, :size_t
end
