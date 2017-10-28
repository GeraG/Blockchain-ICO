'use strict';

/* Add the dependencies you're testing */
const Crowdsale = artifacts.require("./Crowdsale.sol");
// YOUR CODE HERE

contract('crowdsaleTest', function(accounts) {
	/* Define your constant variables and instantiate constantly changing
	 * ones
	 */
	const args = {};
	let x, y, z;
	// YOUR CODE HERE

	/* Do something before every `describe` method */
	beforeEach(async function() {
		queue = await Queue.new();
	});

	/* Group test cases together
	 * Make sure to provide descriptive strings for method arguements and
	 * assert statements
	 */
	describe('Unit Tests', function() {
		it("your string here", async function() {
			// YOUR CODE HERE
		});
		// YOUR CODE HERE
	});

	describe('Integration Tests', function() {
		// YOUR CODE HERE
	});
});
