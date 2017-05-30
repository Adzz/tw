RSpec.describe Routes do
  describe '#generate_possible_journeys_from_stages' do
    it 'generates all possible journeys for a straight connecting journey' do
      subject.add_stage('A', 'B', 10)
      subject.add_stage('B', 'C', 10)
      subject.add_stage('C', 'D', 10)
      subject.generate_possible_journeys_from_stages
      expect(subject.routes.map(&:to_s).join).to eq "A-10-B  -->  B-10-C  -->  C-10-D"
    end
# branchin possibilities are multiple possible routes
# means we have to recur - go depth first - as many times as there are nodes to traverse down?
    it 'handles branching possibilities' do
      subject.add_stage('A', 'B', 10)
      subject.add_stage('A', 'C', 10)
      subject.add_stage('C', 'D', 10)
      subject.add_stage('B', 'E', 10)
      subject.generate_possible_journeys_from_stages
      expect(subject.routes.map(&:to_s).join("\n")).to eq "A-10-B  -->  B-10-E\nA-10-C  -->  C-10-D"
    end
  end
end
