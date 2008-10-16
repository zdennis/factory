class Factory
  
  def create(*args, &blk)
    type = self.class.name.sub(/Factory$/, '').constantize
    type.new *args, &blk
  end
  
  def create_collection(objects)
    type = self.class.name.sub(/Factory$/, '').constantize
    returning objects.map {|o| type.new(o.class.name.underscore.to_sym => o) } do |collection|
      collection.extend self.class.const_get(:CollectionMethods) if self.class.const_defined?(:CollectionMethods)
    end
  end
end