// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PharmaSupplyChain {
    
    // Enum for batch status
    enum BatchStatus { Manufactured, InTransit, Delivered }
    
    // Struct to represent a drug batch
    struct DrugBatch {
        string batchNumber;
        string manufacturer;
        string expirationDate;
        address owner;
        BatchStatus status;
        uint createdAt;
    }

    // Mapping to store all batches by their batch number
    mapping(string => DrugBatch) public batches;
    
    // Event to log when a new batch is created
    event BatchCreated(string batchNumber, string manufacturer, address owner);
    
    // Event to log when a batch is transferred to a new owner
    event BatchTransferred(string batchNumber, address oldOwner, address newOwner);
    
    // Function to create a new drug batch
    function createDrugBatch(string memory _batchNumber, string memory _manufacturer, string memory _expirationDate) public {
        require(batches[_batchNumber].createdAt == 0, "Batch already exists");

        // Create a new batch
        batches[_batchNumber] = DrugBatch({
            batchNumber: _batchNumber,
            manufacturer: _manufacturer,
            expirationDate: _expirationDate,
            owner: msg.sender,
            status: BatchStatus.Manufactured,
            createdAt: block.timestamp
        });

        emit BatchCreated(_batchNumber, _manufacturer, msg.sender);
    }
    
    // Function to transfer ownership of a batch
    function transferBatch(string memory _batchNumber, address _newOwner) public {
        // Ensure the batch exists
        require(batches[_batchNumber].createdAt != 0, "Batch does not exist");

        // Ensure the caller is the current owner
        require(batches[_batchNumber].owner == msg.sender, "Only the owner can transfer the batch");

        // Transfer the batch to the new owner
        address oldOwner = batches[_batchNumber].owner;
        batches[_batchNumber].owner = _newOwner;

        emit BatchTransferred(_batchNumber, oldOwner, _newOwner);
    }
    
    // Function to get the details of a batch
    function getBatch(string memory _batchNumber) public view returns (string memory, string memory, string memory, address, BatchStatus, uint) {
        DrugBatch memory batch = batches[_batchNumber];
        require(batch.createdAt != 0, "Batch does not exist");

        return (batch.batchNumber, batch.manufacturer, batch.expirationDate, batch.owner, batch.status, batch.createdAt);
    }
    
    // Function to update the status of a batch
    function updateBatchStatus(string memory _batchNumber, BatchStatus _status) public {
        // Ensure the batch exists
        require(batches[_batchNumber].createdAt != 0, "Batch does not exist");

        // Ensure the caller is the owner
        require(batches[_batchNumber].owner == msg.sender, "Only the owner can update the batch status");

        // Update the batch status
        batches[_batchNumber].status = _status;

        require(batches[_batchNumber].status == BatchStatus.InTransit, "Intransit");

        require(batches[_batchNumber].status== BatchStatus.Delivered, "Delivered");
    }
}
