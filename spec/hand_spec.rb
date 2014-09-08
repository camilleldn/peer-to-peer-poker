require 'spec_helper'
require 'hand'
require 'hand_array_parser'
require 'card_parser'
require 'card'

describe Hand do

  let(:card_parser) { CardParser.new }
  let(:hand_parser) { HandArrayParser.new(card_parser) }
  let(:pair_hand_string_array) { ["5h", "5d", "6d", "7d", "8d"] }
  let(:hand_string_array) { pair_hand_string_array }
  let(:hand) { described_class.new(hand_string_array, hand_parser) }

  describe "hand comparisons" do
    it "tells me if the hand is better" do
      four_of_a_kind_hand = described_class.new(["5h", "5d", "5s", "5c", "8d"] , hand_parser)
      full_house_hand = described_class.new(["5h", "5d", "5s", "6c", "6h"], hand_parser)

      expect(four_of_a_kind_hand).to be > full_house_hand
    end
  end

  describe "#rank" do
    context "pair hand" do
      it "ranks the hand correctly" do
        expect(hand.rank.fetch(:type)).to eq :pair
      end
      it "returns the value correctly" do
        expect(hand.rank.fetch(:value)).to eq 5
      end
      it "returns the other cards correctly" do
        expect(hand.rank.fetch(:cards)).to eq [8,7,6]
      end
    end

    context "high card" do
      let(:hand_string_array) { ["4h", "5d", "6d", "7d", "9d"] }
      it "ranks the hand correctly" do
        expect(hand.rank.fetch(:type)).to eq :highest
      end
      it "returns the other cards correctly" do
        expect(hand.rank.fetch(:cards)).to eq [9,7,6,5,4]
      end
    end

    context "three of a kind" do
      let(:hand_string_array) { ["5h", "5d", "5s", "7d", "8d"] }
      it "ranks the hand correctly" do
        expect(hand.rank.fetch(:type)).to eq :three_of_a_kind
      end
      it "returns the value correctly" do
        expect(hand.rank.fetch(:value)).to eq 5
      end
      it "returns the other cards correctly" do
        expect(hand.rank.fetch(:cards)).to eq [8,7]
      end
    end

    context "four of a kind" do
      let(:hand_string_array) { ["5h", "5d", "5s", "5c", "8d"] }
      it "ranks the hand correctly" do
        expect(hand.rank.fetch(:type)).to eq :four_of_a_kind
      end
      it "sets the value correctly" do
        expect(hand.rank.fetch(:value)).to eq 5
      end
      it "sets the kicker correctly" do
        expect(hand.rank.fetch(:kicker)).to eq 8
      end
    end

    context "full house" do
      let(:hand_string_array) { ["5h", "5d", "5s", "6c", "6h"] }
      it "ranks the hand correctly" do
        expect(hand.rank.fetch(:type)).to eq :full_house
      end
    end
    
    context "flush hand" do
      let(:hand_string_array) { ["5h", "6h", "7h", "8h", "10h"] }
      it "ranks the hand correctly" do
        expect(hand.rank.fetch(:type)).to eq :flush
      end
      it "returns the other cards correctly" do
        expect(hand.rank.fetch(:cards)).to eq [10,8,7,6,5]
      end
    end

    context "straight hand" do
      let(:hand_string_array) { ["5h", "6h", "7h", "8h", "9d"] }
      it "ranks the hand correctly" do
        expect(hand.rank.fetch(:type)).to eq :straight
      end
      it "sets the highest hand correctly" do
        expect(hand.rank.fetch(:highest)).to eq 9
      end
    end

    context "straight with low ace hand" do
      let(:hand_string_array) { ["2h", "3h", "4h", "5h", "ad"] }
      it "ranks the hand correctly" do
        expect(hand.rank.fetch(:type)).to eq :straight
      end
      it "sets the highest hand correctly" do
        expect(hand.rank.fetch(:highest)).to eq 5
      end
    end

    context "straight with high ace hand" do
      let(:hand_string_array) { ["10h", "jh", "qh", "kh", "ad"] }
      it "ranks the hand correctly" do
        expect(hand.rank.fetch(:type)).to eq :straight
      end
      it "sets the highest hand correctly" do
        expect(hand.rank.fetch(:highest)).to eq 14
      end
    end

    context "two pairs" do
      let(:hand_string_array) { ["4h", "4d", "6d", "6h", "9s"] }
      it "ranks the hand correctly" do
        expect(hand.rank.fetch(:type)).to eq :two_pair
      end
      it "sets the pairs correctly" do
        expect(hand.rank.fetch(:pairs)).to eq [4,6]
      end
      it "sets the kicker correctly" do
        expect(hand.rank.fetch(:kicker)).to eq 9
      end
    end

    context "two pairs with low kicker" do
      let(:hand_string_array) { ["4h", "4d", "6d", "6h", "2s"] }
      it "sets the kicker correctly" do
        expect(hand.rank.fetch(:kicker)).to eq 2
      end
    end

    context "straight flush" do
      let(:hand_string_array) { ["5h", "6h", "7h", "8h", "9h"] }
      it "ranks the hand correctly" do
        expect(hand.rank.fetch(:type)).to eq :straight_flush
      end
    end
  end
end