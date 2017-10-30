'use strict';

/* Add the dependencies you're testing */
const Crowdsale = artifacts.require("./Crowdsale.sol");
const Token = artifacts.require("./Token.sol");
const Queue = artifacts.require("./Queue.sol");

contract('integrationTest', function(accounts) {
	/* Define your constant variables and instantiate constantly changing
	 * ones
	 */
 	const args = {exchangeRate: 5, totalSupply: 1000, timeCap: 5000};
	const clients = {_owner: accounts[1], user1: accounts[2], user2: accounts[3]};

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

	/* Group test cases together
	 * Make sure to provide descriptive strings for method arguements and
	 * assert statements
	 */
	describe('Basic Functionality', function() {

		it("Testing purchase", async function() {
			// await queue.enqueue.call(args.user1);
			// await queue.enqueue.call(args.user2);
			// let success = await crowdsale.sell.call({from: clients.user1, value: 10});
			// assert.equal(success.valueOf(), true, "purchase failed");
		});

		it("Testing refunds", async function() {
			// YOUR CODE HERE
		});

		it("Testing transfer", async function() {
			// YOUR CODE HERE
		});

	});

	describe('Advanced Functionality', function() {

		it("Testing transfer", async function() {
			// YOUR CODE HERE
		});

	});
});
