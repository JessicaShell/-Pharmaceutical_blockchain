// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PharmaSupplyChain {
    
    enum BatchStatus { Manufactured, InTransit, Delivered }
    
    struct DrugBatch {
        string batchNumber;
        string manufacturer;
        string expirationDate;
        address owner;
        BatchStatus status;
        uint createdAt;
    }

    mapping(string => DrugBatch) public batches;

    mapping(address => string) public ownerNames;
    
    event BatchCreated(string batchNumber, string manufacturer, address owner, string ownerName);
    
    event BatchTransferred(string batchNumber, string oldOwnerName, address oldOwner, address newOwner);
    
    function createDrugBatch(
        string memory _batchNumber, 
        string memory _manufacturer, 
        string memory _expirationDate, 
        string memory _ownerName
    ) public {
        require(batches[_batchNumber].createdAt == 0, "Batch already exists");

        batches[_batchNumber] = DrugBatch({
            batchNumber: _batchNumber,
            manufacturer: _manufacturer,
            expirationDate: _expirationDate,
            owner: msg.sender,
            status: BatchStatus.Manufactured,
            createdAt: block.timestamp
        });

        ownerNames[msg.sender] = _ownerName;

        emit BatchCreated(_batchNumber, _manufacturer, msg.sender, _ownerName);
    }
    
    function transferBatch(string memory _batchNumber, address _newOwner, string memory _newOwnerName) public {
        
        require(batches[_batchNumber].createdAt != 0, "Batch does not exist");

        require(batches[_batchNumber].owner == msg.sender, "Only the owner can transfer the batch");

        string memory oldOwnerName = ownerNames[msg.sender];

        address oldOwner = batches[_batchNumber].owner;
        batches[_batchNumber].owner = _newOwner;

        ownerNames[_newOwner] = _newOwnerName;

        emit BatchTransferred(_batchNumber, oldOwnerName, oldOwner, _newOwner);
    }
    
    function getBatch(string memory _batchNumber) public view returns (
        string memory, string memory, string memory, address, BatchStatus, uint
    ) {
        DrugBatch memory batch = batches[_batchNumber];
        require(batch.createdAt != 0, "Batch does not exist");

        return (batch.batchNumber, batch.manufacturer, batch.expirationDate, batch.owner, batch.status, batch.createdAt);
    }
    
    function updateBatchStatus(string memory _batchNumber, BatchStatus _status) public {
      
        require(batches[_batchNumber].createdAt != 0, "Batch does not exist");

        require(batches[_batchNumber].owner == msg.sender, "Only the owner can update the batch status");

        batches[_batchNumber].status = _status;
    }
}
