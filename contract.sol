// SPDX-License-Identifier:GPL-3.0
pragma solidity ^0.8.17;

contract EventOgraniser{
// Since there will be multiple events , so we create struct for its variables

    struct Event{
        address organiser;
        string name;
        uint date;
        uint ticket_count;
        uint ticket_price;
        uint ticket_remaining;
    }
mapping (uint=>Event) public events;

mapping (address=>mapping(uint=>uint)) public tickets;
uint public nextId;

function createEvent(string memory name,uint date, uint ticket_count,uint ticket_price) external{
    
    // NOTE:- use epoconverter.com for entering date in "timestamp" format

    // constraints / conditions to check in case of an event
    require(date>block.timestamp,"Create event only for future date");
    require(ticket_count>0,"Create event only when tickets are available");

    // The first event is being created
    events[nextId]=Event(msg.sender,name,date,ticket_price,ticket_count,ticket_count);
    
     
    nextId++;
}

function buyTicket(uint id,uint quantity)external payable{
    require(events[id].date!=0,"This event does not exist");
    require(events[id].date>block.timestamp,"Event has finished");
Event storage _event=events[id];
require(msg.value==(_event.ticket_price*quantity),"Not enough ether for buying tickets");
require(quantity<=_event.ticket_remaining,"Tickets not available");
_event.ticket_remaining-=quantity;
tickets[msg.sender][id]+=quantity;
}

function transferTickets(uint id,uint quantity,address friend)external{
    require(events[id].date!=0,"This event does not exist");
    require(events[id].date>block.timestamp,"Event has finished");
    require(quantity<=tickets[msg.sender][id],"Tickets not enough to send to someone");
    tickets[msg.sender][id]-=quantity;
    tickets[friend][id]+=quantity;
}

// To buy a ticket , first change the account address above the "deploy" button , and then enter the "value" in wei.
// Now without clicking the deploy button , click on transact to buy tickets from the selected account.
}