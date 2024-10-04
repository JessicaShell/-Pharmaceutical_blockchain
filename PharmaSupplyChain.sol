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
    
    event BatchCreated(string batchNumber, string manufacturer, address owner);
    
    event BatchTransferred(string batchNumber, address oldOwner, address newOwner);
    
    function createDrugBatch(string memory _batchNumber, string memory _manufacturer, string memory _expirationDate) public {
        require(batches[_batchNumber].createdAt == 0, "Batch already exists");

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
    
    function transferBatch(string memory _batchNumber, address _newOwner) public {
        
        require(batches[_batchNumber].createdAt != 0, "Batch does not exist");

        require(batches[_batchNumber].owner == msg.sender, "Only the owner can transfer the batch");

        address oldOwner = batches[_batchNumber].owner;
        batches[_batchNumber].owner = _newOwner;

        emit BatchTransferred(_batchNumber, oldOwner, _newOwner);
    }
    
    function getBatch(string memory _batchNumber) public view returns (string memory, string memory, string memory, address, BatchStatus, uint) {
        DrugBatch memory batch = batches[_batchNumber];
        require(batch.createdAt != 0, "Batch does not exist");

        return (batch.batchNumber, batch.manufacturer, batch.expirationDate, batch.owner, batch.status, batch.createdAt);
    }
    
    function updateBatchStatus(string memory _batchNumber, uint _status) public {
       
        require(batches[_batchNumber].createdAt != 0, "Batch does not exist");

        require(batches[_batchNumber].owner == msg.sender, "Only the owner can update the batch status");

        if (_status == 2) {
            batches[_batchNumber].status = BatchStatus.InTransit;
        } else if (_status == 3) {
            batches[_batchNumber].status = BatchStatus.Delivered;
        } else {
            revert("Invalid status. Use 2 for InTransit and 3 for Delivered.");
        }
    }
}
