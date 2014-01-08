require "spec_helper"

describe WithRecursive do

  describe "mix-in" do
    it { expect(Tree).to be_respond_to :with_recursive }
  end

  describe ".with_recursive" do
    context "with no args" do
      before { Tree.send(:with_recursive) }
      let(:config) { Tree.with_recursive_config }
      it { expect(config.foreign_key).to eq :parent_id }
      it { expect(config.order).to be_nil }
      it { expect(Tree.new).to be_a WithRecursive::ActiveRecordExtension::Associations }
    end
    context "with args" do
      before { Tree.send(:with_recursive, foreign_key: key, order: ord) }
      let(:key) { :foreign_key }
      let(:ord) { :order }
      let(:config) { Tree.with_recursive_config }
      it { expect(config.foreign_key).to eq key }
      it { expect(config.order).to eq ord }
      it { expect(Tree.new).to be_a WithRecursive::ActiveRecordExtension::Associations }
    end
  end

end
