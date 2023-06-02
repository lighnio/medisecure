// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract MedicalTestContract {
    uint256 public testCount = 0;

    struct Test {
        uint256 id;
        string title;
        string description;
    }

    mapping(uint256 => Test) public tests;

    event TestCreated(uint256 id, string title, string description);
    event TestDeleted(uint256 id);

    function createTest(string memory _title, string memory _description)
        public
    {
        tests[testCount] = Test(testCount, _title, _description);
        emit TestCreated(testCount, _title, _description);
        testCount++;
    }

    function deleteTest(uint256 _id) public {
        delete tests[_id];
        emit TestDeleted(_id);
        testCount--;
    }
}