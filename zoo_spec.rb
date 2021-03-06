# Zoo spec file
require "./zoo"
require "rspec"
require '../../spec_helper'

class Grasshoppers < Food; end
class Salad < Food; end

describe Tacos do
	it "should know all tacos are equal" do
		(Tacos.new == Tacos.new).should be_true
	end
end

describe Panda do

	it "should like bamboo" do
		Panda.new.likes?(Bamboo.new).should eq(true)
	end

	it "should not like grasshoppers" do
		Panda.new.likes?(Grasshoppers.new).should eq(false)
	end

	it "should be able to eat the food" do
		Panda.new.eat(Bamboo.new).should be_true
	end

	it "should be full after eating 30 bamboo" do
		panda = Panda.new
		31.times do
			panda.eat(Bamboo.new)	
		end
		panda.should be_full
	end

	it "should not be full after 1" do
		panda = Panda.new
		panda.eat(Bamboo.new)	
		panda.should_not be_full
	end
end

describe Lion do
	it "should like wildebeests" do
		Lion.new.likes?(Wildebeests.new).should eq(true)
	end

	it "should like zeebras" do
		Lion.new.likes?(Zeebras.new).should eq(true)
	end

	it "should not like salad" do
		Lion.new.likes?(Salad.new).should eq(false)
	end

	it "should take 11 meals to be full" do
		lion = Lion.new
		lion.eat(Zeebras.new)
		lion.should_not be_full
	end
	it "should take 11 meals to be full" do
		lion = Lion.new
		11.times do
			lion.eat(Zeebras.new)
		end
		lion.should be_full
	end
end

describe Zookeeper do
	it "should be able to feed bamboo to the pandas" do
		panda = Panda.new
		panda.should_receive(:eat).with(:bamboo)
		Zookeeper.new.feed(food: :bamboo, to: panda)
	end

	it "should be able to feed zeebras to the lions" do
		lion = Lion.new
		lion.should_receive(:eat).with(:zeebras)
		Zookeeper.new.feed(food: :zeebras, to: lion)
	end

	it "should feed the panda the bamboo when foodbarge is received" do
		foodbarge = FoodBarge.new
		zookeeper = Zookeeper.new
		panda = Panda.new
		bamboo = Bamboo.new
		foodbarge.food_for(food: bamboo, to: zookeeper, animal: panda)
		expect(panda.eat(bamboo)).to eq(true)
	end

	it "should feed the lion the zeebras when foodbarge is received" do
		foodbarge = FoodBarge.new
		zookeeper = Zookeeper.new
		lion = Lion.new
		zeebras = Zeebras.new
		foodbarge.food_for(food: zeebras, to: zookeeper, animal: lion)
		expect(lion.eat(zeebras)).to eq(true)
	end

	it "should not feed the lion the bamboo when foodbarge is received" do
		foodbarge = FoodBarge.new
		zookeeper = Zookeeper.new
		lion = Lion.new
		bamboo = Bamboo.new
		foodbarge.food_for(food: bamboo, to: zookeeper, animal: lion)
		expect(lion.eat(bamboo)).to eq(false)
	end
end

describe Human do
	it "should like bacon" do
		expect(Human.new.likes?(Bacon.new)).to eq(true)
	end

	it "should like tacos" do
		expect(Human.new.likes?(Tacos.new)).to eq(true)
	end

	it "should not like bamboo" do
		expect(Human.new.likes?(Bamboo.new)).to eq(false)
	end
end

describe FoodBarge do
	it "should be sent to zookeeper with bamboo for a panda" do
		zookeeper = Zookeeper.new
		bamboo = Bamboo.new
		panda = Panda.new
		expect(zookeeper).to receive(:receive).with(food: bamboo, to: panda)
		expect(FoodBarge.new.food_for(food: bamboo, to: zookeeper, animal: panda))
	end

	it "should be sent to zookeeper with zeebras for a lion" do
		zookeeper = Zookeeper.new
		zeebras = Zeebras.new
		lion = Lion.new
		expect(zookeeper).to receive(:receive).with(food: zeebras, to: lion)
		expect(FoodBarge.new.food_for(food: zeebras, to: zookeeper, animal: lion))
	end
end

