require "spec_helper"

describe WithRecursive::Configure do

  let(:config) { WithRecursive::Configure.new(foreign_key: key, order: ord) }
  let(:key) { :foo }
  let(:ord) { :baa }
  it { expect(config.foreign_key).to eq key }
  it { expect(config.order).to eq ord }

end
