# frozen_string_literal: true

RSpec.describe ChatKit::Session::Cancel::Scope do
  describe ".new" do
    it "initializes with customer_id" do
      instance = described_class.new(customer_id: "cust_123")
      expect(instance.customer_id).to eq("cust_123")
    end

    it "allows reading and writing customer_id" do
      instance = described_class.new(customer_id: "initial")
      instance.customer_id = "updated"
      expect(instance.customer_id).to eq("updated")
    end
  end

  describe ".deserialize" do
    context "when data is nil" do
      it "returns an instance with nil customer_id" do
        instance = described_class.deserialize(nil)
        expect(instance).to be_a(described_class)
        expect(instance.customer_id).to be_nil
      end
    end

    context "when data is an empty hash" do
      it "returns an instance with nil customer_id" do
        instance = described_class.deserialize({})
        expect(instance.customer_id).to be_nil
      end
    end

    context "when data contains customer_id" do
      it "sets the customer_id value" do
        data = { "customer_id" => "cust_999" }
        instance = described_class.deserialize(data)
        expect(instance.customer_id).to eq("cust_999")
      end
    end

    context "when data contains extra keys" do
      it "extracts only known keys" do
        data = { "customer_id" => "cust_x", "extra" => "ignored" }
        instance = described_class.deserialize(data)
        expect(instance.customer_id).to eq("cust_x")
      end
    end
  end
end
