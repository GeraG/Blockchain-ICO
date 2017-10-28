'use strict';

/* Add the dependencies you're testing */
const Crowdsale = artifacts.require("./Crowdsale.sol");

contract('crowdsaleTest', function(accounts) {
	const args = {exhangeRate: 1, totalSupply: 1000, timeCap: 50};
	let crowdsale;

	/* Do something before every `describe` method */
	beforeEach(async function() {
		crowdsale = await Crowdsale.new(
				args.exchangeRate,
				args.totalSupply,
				args.timeCap,
		);
	});

	describe('Initialization Tests', function() {
		it("Testing member variables initialization", async function() {
		});
		it("Testing wei to dragonglass conversion", async function() {
		});
		it("Testing dragonglass to wei conversion", async function() {
		});
	});

	describe('Timing Tests', function() {
		it("Testing sale ends after timeCap", async function() {
			// TODO: implement
		});
		it("Testing sell and refund fail after sale ends", async function() {
			// TODO: implement
		});
	});

	describe('Sale Functionality Tests', function() {
		it("Testing successful sales", async function() {
			// TODO: implement
			// NOTE: ensure that crowdSaleBalance is consistent with tokensSold
		});
		it("Testing failed sell due to timeout", async function() {
			// TODO: implement
		});
		it("Testing failed sell due to insufficient funds", async function() {
			// TODO: implement
		});
		it("Testing successful refunds", async function() {
			// TODO: implement
		});
		it("Testing failed refund due to insufficient funds", async function() {
			// TODO: implement
		});
		it("Testing funds tranferred to owner at end of sale", async function() {
			// TODO: implement
		});
	});

	describe('Security and Permission Tests', function() {
		it("Testing minting and burning fails for non-owner", async function() {
			// TODO: implement
		});
		it("Testing receiveFunds fails for non-owner", async function() {
			// TODO: implement
		});
	});
});
