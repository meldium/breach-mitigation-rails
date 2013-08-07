require "spec_helper"
require "breach_mitigation/length_hiding"

describe BreachMitigation::LengthHiding do
  let(:length_hiding) { BreachMitigation::LengthHiding.new(double()) }

  describe "#random_html_comment" do
    it "should have different lengths on different runs" do
      lengths = []
      10.times do
        random_comment = length_hiding.send(:random_html_comment)
        lengths << random_comment.size
      end
      lengths.uniq.size.should > 1
    end
  end
end
