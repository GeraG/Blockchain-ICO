pragma solidity ^0.4.15;

/**
 * @title Queue
 * @dev Data structure contract used in `Crowdsale.sol`
 * Allows buyers to line up on a first-in-first-out basis
 * See this example: http://interactivepython.org/courselib/static/pythonds/BasicDS/ImplementingaQueueinPython.html
 */

contract Queue {
	/* State variables */
	uint8 size = 5;
	uint timeLimit = 10;
	uint8 numPeople;
	address[] people;
	uint[] times;

	/* Add events */
	event Expelled(address addr);

	/* Add constructor */
	function Queue() {
		numPeople = 0;
		people = new address[](size);
		times = new uint[](size);
	}

	/* Returns the number of people waiting in line */
	function qsize() constant returns(uint8) {
		return numPeople;
	}

	/* Returns whether the queue is empty or not */
	function empty() constant returns(bool) {
		return (qsize() == 0);
	}
	
	/* Returns the address of the person in the front of the queue */
	function getFirst() constant returns(address) {
		if (qsize() > 0) {
			return people[0];
		}
		return address(0);
	}
	
	/* Allows `msg.sender` to check their position in the queue.
	 * Returns the 1-indexed position of the sender in the line.
	 * If person is not in line, returns 0.
	 */
	function checkPlace() constant returns(uint8) {
		for (uint8 i = 0; i < numPeople; i++) {
			if (people[i] == msg.sender) {
				return i+1;
			}
		}
		return 0;
	}
	
	/* Allows anyone to expel the first person in line if their time
	 * limit is up
	 */
	function checkTime() {
		if (qsize() > 0 && now > times[0] + timeLimit) {
			Expelled(people[0]);
			dequeue();
		}
	}
	
	/* Removes the first person in line; either when their time is up or when
	 * they are done with their purchase
	 */
	function dequeue() {
		if (qsize() > 0) {
			for (uint8 i = 1; i < numPeople; i++) {
				people[i-1] = people[i];
				times[i-1] = times[i];
			}
			numPeople -= 1;
			people[qsize()] = address(0);
			times[qsize()] = 0;
		}
	}

	/* Places `addr` in the first empty position in the queue */
	function enqueue(address addr) {
		if (qsize() < size) {
			people[qsize()] = addr;
			times[qsize()] = now;
			numPeople += 1;
		}
	}
}
