'use strict';

/* Add the dependencies you're testing */
const Queue = artifacts.require("./Queue.sol");

contract('queueTest', function(accounts) {
	/* Define your constant variables and instantiate constantly changing 
	 * ones
	 */
	const args = {alice: 0x0001, bob: 0x0002, carlos: 0x0003, dave: 0x0004, eve:0x0005, frank: 0x0006};
	let queue;

	/* Do something before every `describe` method */
	beforeEach(async function() {
		queue = await Queue.new();
	});

	/* Group test cases together 
	 * Make sure to provide descriptive strings for method arguments and
	 * assert statements
	 */
	describe('Basic Functionality', function() {
		it("Instantiate a new queue and make sure it is empty.", async function() {
			let isEmpty = await queue.empty();
			assert.equal(isEmpty, true, "A new queue should be empty.");
		});

		it("Add a person to the queue and make sure the queue's size is correct.", async function() {
			await queue.enqueue(args.alice);
			let queueSize = await queue.qsize();
			assert.equal(queueSize, 1, "The queue should have a size of 1.");
		});

		it("Remove a person from the queue and make sure the queue's size is correct.", async function() {
			await queue.enqueue(args.alice);
			await queue.dequeue();
			let queueSize = await queue.qsize();
			let isEmpty = await queue.empty();
			assert.equal(queueSize, 0, "The queue should have a size of 0.");
			assert.equal(isEmpty, true, "The queue should be empty.");
		});
	});

	describe('Advanced Functionality', function() {
		// YOUR CODE HERE
	});
});
