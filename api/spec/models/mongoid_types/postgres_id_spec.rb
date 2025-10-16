require "rails_helper"

RSpec.describe MongoidTypes::PostgresId, type: :model do
  let(:integer_id) { 1 }
  let(:hex_string_id) { "000000000000000000000001" }
  let(:object_id) { BSON::ObjectId.from_string(hex_string_id) }

  describe ".mongoize" do
    it "converts Integer to BSON::ObjectId" do
      expect(described_class.mongoize(integer_id)).to eq(object_id)
    end

    it "converts String to BSON::ObjectId" do
      expect(described_class.mongoize(hex_string_id)).to eq(object_id)
    end

    it "returns BSON::ObjectId as it is" do
      expect(described_class.mongoize(object_id)).to eq(object_id)
    end

    it "returns nil as it is" do
      expect(described_class.mongoize(nil)).to be_nil
    end

    it "raises error for invalid String" do
      expect { described_class.mongoize("invalid") }.to raise_error(BSON::Error::InvalidObjectId)
    end
  end

  describe ".demongoize" do
    it "converts BSON::ObjectId to Integer" do
      expect(described_class.demongoize(object_id)).to eq(integer_id)
    end

    it "returns Integer as it is" do
      expect(described_class.demongoize(integer_id)).to eq(integer_id)
    end

    it "returns nil as it is" do
      expect(described_class.demongoize(nil)).to be_nil
    end
  end
end
