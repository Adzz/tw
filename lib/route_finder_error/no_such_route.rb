module RouteFinderError
  class NoSuchRoute < StandardError
    def initialize(msg="NO SUCH ROUTE")
      super
    end
  end
end
