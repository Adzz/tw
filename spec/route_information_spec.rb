RSpec.describe RouteInformation do
  let(:no_route_error) { RouteFinderError::NoSuchRoute }
  let(:error_message) { 'NO SUCH ROUTE' }
  subject(:route_info) { described_class.new }

  describe '#add_route' do
    it 'adds a route' do
      expect(route_info.routes).to be_empty
      add_first_route
      expect(route_info.routes).to eq({"A" => {"B" => 5}})
    end

    it 'groups together routes from the same starting destination' do
      add_first_route
      route_info.add_route("A", "C", 15)
      expect(route_info.routes).to eq({"A" => {"B" => 5, "C" => 15}})
    end

    it 'handles multiple start destinations' do
      add_first_route
      route_info.add_route("B", "C", 15)
      expect(route_info.routes).to eq({"A" => {"B" => 5}, "B" => { "C" => 15}})
    end

    it 'wont duplicate routes' do
      expect(route_info.routes).to be_empty
      add_first_route
      add_first_route
      expect(route_info.routes).to eq({"A" => {"B" => 5}})
    end
  end

  describe '#get_distance' do
    it 'returns the correct distance for a two destination route' do
      add_first_route
      expect(route_info.distance('A-B')).to eq 5
    end

    it 'handles multiple routes' do
      add_first_route
      route_info.add_route("B", "C", 20)
      route_info.add_route("C", "Z", 30)
      expect(route_info.distance('A-B-C-Z')).to eq 55
    end

    it 'returns NO SUCH ROUTE for a route that does not exist' do
      add_first_route
      expect {route_info.distance('A-B-Z')}.to raise_error no_route_error, error_message
    end
  end

  describe '#shortest_distance' do
    it 'returns the route distance for a direct route' do
      add_first_route
      expect(route_info.shortest_distance('A-B')).to eq 5
    end

    it 'riases a no route error if the requested route doesnt exist' do
      expect {route_info.shortest_distance('A-B') }.to raise_error no_route_error, error_message
    end

    it 'will find the shortest route when there is no direct route' do
      add_first_route
      route_info.add_route("B", "C", 6)
      route_info.add_route("A", "D", 10)
      route_info.add_route("D", "C", 20)
      route_info.add_route("D", "E", 20)
      route_info.add_route("E", "C", 20)
      route_info.add_route("C", "Z", 9)
      expect(route_info.shortest_distance('A-C')).to eq 5
    end
  end

  def add_first_route
    route_info.add_route("A", "B", 5)
  end
end
