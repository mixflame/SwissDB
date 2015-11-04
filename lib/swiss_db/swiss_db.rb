module SwissDB
  class << self

    attr_accessor :store

    def setup(context)
      @store = DataStore.new(context)
    end
  end
end
