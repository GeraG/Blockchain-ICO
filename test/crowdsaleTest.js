'use strict';

/* Add the dependencies you're testing */
const Crowdsale = artifacts.require("./Crowdsale.sol");
const Token = artifacts.require("./Token.sol");
const Queue = artifacts.require("./Queue.sol");

contract('crowdsaleTest', function(accounts) {
	const args = {exchangeRate: 5, totalSupply: 1000, timeCap: 5000};
	const clients = {_owner: accounts[0], user1: accounts[1], user2: accounts[2]};
	let crowdsale, token, queue;

	/* Do something before every `describe` method */
	beforeEach(async function() {
		crowdsale = await Crowdsale.new(
				args.exchangeRate,
				args.totalSupply,
				args.timeCap,
				{from: clients._owner},
		);
		token = Token.at(await crowdsale.token());
		queue = Queue.at(await crowdsale.q())
	});

	describe('Init Tests', function() {
		it("Testing initialization", async function() {
			let owner = await crowdsale.owner.call();
			let tokensSold = await crowdsale.tokensSold.call();
		  let crowdSaleBalance = await crowdsale.crowdSaleBalance.call();
		  let startTime = await crowdsale.startTime.call();
		  let endTime = await crowdsale.endTime.call();
			let linesize = await crowdsale.lineSize.call();

			assert.equal(clients._owner, owner.valueOf(), "Owner not set");
			assert.equal(0, tokensSold.valueOf(), "tokensSold should initially be 0");
			assert.equal(0, crowdSaleBalance.valueOf(), "crowdSaleBalance should initially be 0");
			assert.isAtLeast(
				endTime.valueOf(),
				startTime.valueOf(),
				"sale end time is not after start time",
			);
			assert.equal(linesize, 0, "Queue should be initially empty");
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
		it("Testing wei to dragonglass conversion", async function() {
			let way = 200;
			let dg = await crowdsale.weiToDragonGlass.call(way);
			assert.equal(dg.valueOf(), way * args.exchangeRate, "wei to dg exchange incorrect");
		});
		it("Testing dragonglass to wei conversion", async function() {
			let dg = 1000;
			let way = await crowdsale.dragonGlassToWei.call(dg);
			assert.equal(
				way.valueOf(),
				dg / args.exchangeRate,
				"dg to wei exchange incorrect",
			);
		});
		it("Testing successful sales", async function() {
			var tokensSold = await crowdsale.tokensSold.call();
			var crowdSaleBalance = await crowdsale.crowdSaleBalance.call();
			assert.equal(
				tokensSold.valueOf(),
				0,
				"Tokens sold should be 0 before any sale",
			);
			assert.equal(
				crowdSaleBalance.valueOf(),
				0,
				"Crowdsale balance should be 0 before any sale",
			);

			let size1 = await crowdsale.lineSize.call();
			assert.equal(
				size1.valueOf(),
				0,
				"Line size should be 0 at beginning of sale",
			);
			await crowdsale.getInLine(clients.user1);
			let size2 = await crowdsale.lineSize.call();
			assert.equal(
				size2.valueOf(),
				1,
				"Line size should be 1 for single seller before purchase completes",
			);
			let first = await crowdsale.firstInLine.call();
			assert.equal(
				first.valueOf(),
				clients.user1,
				"Solitary buyer should be first in line after enqueue",
			);

			// seller can only sell if there is someone in line behind them.
			await crowdsale.getInLine(clients.user2);
			let size3 = await crowdsale.lineSize.call();
			assert.equal(
				size3.valueOf(),
				2,
				"Line size should be 2 once another person is enqueued."
			);

			first = await crowdsale.firstInLine.call();
			assert.equal(
				first.valueOf(),
				clients.user1,
				"The same buyer should be first in line, even after enqueue",
			);

			let success = await crowdsale.sell.call({from: clients.user1, value: 1});
			assert(success.valueOf(), "simple sell failed");


			tokensSold = await crowdsale.tokensSold.call();
			crowdSaleBalance = await crowdsale.crowdSaleBalance.call();
			assert.equal(
				crowdSaleBalance.valueOf(),
				20,
				"crowdSaleBalance not updated after successful sale",
			);
			assert.equal(
				tokensSold.valueOf(),
				20 * args.exchangeRate,
				"tokensSold not updated after successful sale",
			);
		});
		it("Testing failed sell due to timeout", async function() {
			// TODO: implement
		});
		it("Testing failed sell due to insufficient funds", async function() {
			// TODO: implement
		});
		it("Testing failed sell due to sale cap exceeded", async function() {
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
