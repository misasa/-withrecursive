require "spec_helper"

describe WithRecursive::ActiveRecord::Associations do

  before { Tree.send(:with_recursive, order: :code) }
  let(:tree) { Tree.create(parent_id: parent_id, code: code) }
  let(:parent_id) { nil }
  let(:code) { nil }

  describe "associations" do
    describe ".parent" do
      let(:parent) { Tree.create }
      let(:parent_id) { parent.id }
      it { expect(tree.parent).to eq parent }
    end
    
    describe ".children" do
      before { @child = Tree.create(parent_id: tree.id) }
      it { expect(tree.children).to eq [@child] }
    end
  end

  describe "class methods" do
    describe ".roots" do
      before do
        @parent = Tree.create
        @child = Tree.create(parent_id: @parent.id)
      end
      it { expect(Tree.roots).to eq [@parent] }
    end

    describe ".root" do
      before do
        @parent = Tree.create
        @child = Tree.create(parent_id: @parent.id)
      end
      it { expect(Tree.root).to eq @parent }
    end

    describe ".ancestors_by_id" do
      let(:ancestors) { Tree.ancestors_by_id(tree.id) }
      let(:root) { Tree.create }
      let(:parent) { Tree.create(parent_id: root.id) }
      let(:parent_id) { parent.id }
      before { Tree.create(parent_id: tree.id) }
      it { expect(ancestors.length).to eq 2 }
      it { expect(ancestors).to be_include root }
      it { expect(ancestors).to be_include parent }
    end

    describe ".descendants" do
      let(:descendants) { Tree.descendants_by_id(tree.id) }
      let(:parent) { Tree.create }
      let(:parent_id) { parent.id }
      before do
        @child = Tree.create(parent_id: tree.id)
        @descendant = Tree.create(parent_id: @child.id)
      end
      it { expect(descendants.length).to eq 2 }
      it { expect(descendants).to be_include @child }
      it { expect(descendants).to be_include @descendant }
    end

    describe ".root_by_id" do
      let(:root_by_id) { Tree.root_by_id(tree.id) }
      let(:root) { Tree.create }
      let(:parent) { Tree.create(parent_id: root.id) }
      let(:parent_id) { parent.id }
      before { Tree.create(parent_id: tree.id) }
      it { expect(root_by_id).to eq root }
    end
  end

  describe "instance methods" do
    describe ".ancestors" do
      let(:ancestors) { tree.ancestors }
      let(:root) { Tree.create }
      let(:parent) { Tree.create(parent_id: root.id) }
      let(:parent_id) { parent.id }
      before { Tree.create(parent_id: tree.id) }
      it { expect(ancestors.length).to eq 2 }
      it { expect(ancestors[0]).to eq root }
      it { expect(ancestors[1]).to eq parent }
    end

    describe ".descendants" do
      let(:descendants) { tree.descendants }
      let(:parent) { Tree.create }
      let(:parent_id) { parent.id }
      before do
        @child = Tree.create(parent_id: tree.id)
        @descendant = Tree.create(parent_id: @child.id)
      end
      it { expect(descendants.length).to eq 2 }
      it { expect(descendants[0]).to eq @child }
      it { expect(descendants[1]).to eq @descendant }
    end

    describe ".root_by_id" do
      let(:root_record) { tree.root }
      let(:root) { Tree.create }
      let(:parent) { Tree.create(parent_id: root.id) }
      let(:parent_id) { parent.id }
      before { Tree.create(parent_id: tree.id) }
      it { expect(root_record).to eq root }
    end

    describe ".siblings" do
      let(:siblings) { tree.siblings }
      let(:parent) { Tree.create }
      let(:parent_id) { parent.id }
      before do
        @sibling1 = Tree.create(parent_id: parent.id, code: 1)
        @sibling2 = Tree.create(parent_id: parent.id, code: 2)
      end
      it { expect(siblings.length).to eq 2 }
      it { expect(siblings[0]).to eq @sibling1 }
      it { expect(siblings[1]).to eq @sibling2 }
    end

    describe ".self_and_siblings" do
      let(:siblings) { tree.self_and_siblings }
      let(:parent) { Tree.create }
      let(:parent_id) { parent.id }
      let(:code) { 3 }
      before do
        @sibling1 = Tree.create(parent_id: parent.id, code: 1)
        @sibling2 = Tree.create(parent_id: parent.id, code: 2)
      end
      it { expect(siblings.length).to eq 3 }
      it { expect(siblings[0]).to eq @sibling1 }
      it { expect(siblings[1]).to eq @sibling2 }
      it { expect(siblings[2]).to eq tree }
    end
  end

end
