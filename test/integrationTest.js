'use strict';

/* Add the dependencies you're testing */
const Crowdsale = artifacts.require("./Crowdsale.sol");
// YOUR CODE HERE

contract('integrationTest', function(accounts) {
	/* Define your constant variables and instantiate constantly changing 
	 * ones
	 */
	const args = {};
	let x, y, z;
	// YOUR CODE HERE

	/* Do something before every `describe` method */
	beforeEach(async function() {
		// YOUR CODE HERE
	});

	/* Group test cases together 
	 * Make sure to provide descriptive strings for method arguements and
	 * assert statements
	 */
	describe('Basic Functionality', function() {

		it("Testing purchase", async function() {
			// YOUR CODE HERE
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
