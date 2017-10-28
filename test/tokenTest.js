'use strict';

/* Add the dependencies you're testing */
const Token = artifacts.require("./Token.sol");
// YOUR CODE HERE

contract('testTemplate', function(accounts) {
	/* Define your constant variables and instantiate constantly changing 
	 * ones
	 */
	const args = {_supply: 1000};
	let token;
	// YOUR CODE HERE

	/* Do something before every `describe` method */
	beforeEach(async function() {
		// YOUR CODE HERE
		token = await Token.new(args._supply);
	});

	/* Group test cases together 
	 * Make sure to provide descriptive strings for method arguements and
	 * assert statements
	 */
	describe('Token Works', function() {
		it("Testing transfer", async function() {
			let balance = await token.balanceOf.call(accounts[0]);
			assert.equal(balance.valueOf(), args._supply, "incorrect balance");

			await token.transfer(accounts[1], 10);

			balance = await token.balanceOf.call(accounts[0]);
			assert.equal(balance.valueOf(), args._supply - 10, "incorrect balance");

			balance = await token.balanceOf.call(accounts[1]);
			assert.equal(balance.valueOf(), 10, "incorrect balance");
		});
		it("Testing transferFrom, Approve, and Allowance", async function() {
			await token.approve(accounts[1], 50);
			let allowance = await token.allowance.call(accounts[0], accounts[1]);
			assert.equal(allowance.valueOf(), 50, "incorrect allowance");

			await token.approve(accounts[1], 50);
			allowance = await token.allowance.call(accounts[0], accounts[1]);
			assert.equal(allowance.valueOf(), 100, "incorrect allowance");

			await token.approve(accounts[2], 1000);
			allowance = await token.allowance.call(accounts[0], accounts[2]);
			assert.equal(allowance.valueOf(), 0, "incorrect allowance");

			await token.approve(accounts[2], 150);
			allowance = await token.allowance.call(accounts[0], accounts[2]);
			assert.equal(allowance.valueOf(), 150, "incorrect allowance");
		});
		it("Testing mint", async function() {
			await token.mint(100);
			let balance = await token.balanceOf.call(accounts[0]);
			assert.equal(balance.valueOf(), args._supply + 100, "incorrect balance");
		});
		it("Testing burn", async function() {
			await token.burn(100);
			let balance = await token.balanceOf.call(accounts[0]);
			assert.equal(balance.valueOf(), args._supply - 100, "incorrect balance");
		});
		it("Testing refund", async function() {
			await token.transfer(accounts[1], 10);

			let balance = await token.balanceOf.call(accounts[0]);
			assert.equal(balance.valueOf(), args._supply - 10, "incorrect balance");

			balance = await token.balanceOf.call(accounts[1]);
			assert.equal(balance.valueOf(), 10, "incorrect balance");

			await token.refund(accounts[1], 5);

			balance = await token.balanceOf.call(accounts[0]);
			assert.equal(balance.valueOf(), args._supply - 5, "incorrect balance");

			balance = await token.balanceOf.call(accounts[1]);
			assert.equal(balance.valueOf(), 5, "incorrect balance");
		});
	});
});
