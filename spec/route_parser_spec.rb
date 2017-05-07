RSpec.describe RouteParser do
  describe '#parse' do
    let(:route_info) { double RouteInformation }
    let(:file_path) { 'spec/fixtures/kiwiland.csv' }

    subject(:route_parser) { described_class.new(file_path, route_info) }

    it 'parses the given route information' do
      expect(route_info).to receive(:add_route).with("A", "B", 5).once
      route_parser.parse
    end

    it 'raises an error for an invalid file' do
      message = 'please provide a correct file'
      expect { described_class.new('not a file', route_info) }.to raise_error ArgumentError, message
    end
  end
end
